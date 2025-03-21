//
//  LidlReceiptParser.swift
//  CoolReceipts
//
//  Created by Elano Vasconcelos on 19/03/25.
//

import Foundation

struct LidlReceiptParser: ReceiptParser {
    func canParse(text: String) -> Bool {
        return text.lowercased().contains("lidl")
    }
    
    func parse(text: String) -> ReceiptData? {
        print("LidlReceiptParser - text: \(text)")
        // Extract date using a regex matching yyyy-MM-dd format
        let dateRegex = try? NSRegularExpression(pattern: "\\d{4}-\\d{2}-\\d{2}")
        let dateMatches = dateRegex?.matches(in: text, range: NSRange(text.startIndex..., in: text))
        var date: Date? = nil
        if let match = dateMatches?.first, let range = Range(match.range, in: text) {
            let dateString = String(text[range])
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            date = formatter.date(from: dateString)
        }
        
        // Get totalAmount
        var totalAmount: Double? = nil
        let lines = text.components(separatedBy: "\n")
        
        if let ivaIndex = lines.firstIndex(where: { $0.replacingOccurrences(of: " ", with: "").contains("Val.IVA") || $0.contains("ValTotal") }) {
            for line in lines[..<ivaIndex].reversed() {
                let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if let value = Double(trimmed.replacingOccurrences(of: ",", with: ".")) {
                    totalAmount = value
                    break
                }
            }
        }
        
        // Determine currency
        let currency = text.contains("EUR") || text.contains("€") ? "€" : "Unknown"
        
        if let date = date, let totalAmount = totalAmount {
            return ReceiptData(date: date, totalAmount: totalAmount, currency: currency, storeName: "Lidl")
        }
        return nil
    }
}
