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
        
        // Extract total amount: the bigger value
        let amountRegex = try? NSRegularExpression(pattern: "(\\d+[\\.,]\\d{2})")
        let amountMatches = amountRegex?.matches(in: text, range: NSRange(text.startIndex..., in: text))
        var maxAmount: Double?
        if let matches = amountMatches {
            for match in matches {
                if let range = Range(match.range(at: 1), in: text) {
                    let amountString = String(text[range]).replacingOccurrences(of: ",", with: ".")
                    if let amount = Double(amountString) {
                        maxAmount = max(maxAmount ?? amount, amount)
                    }
                }
            }
        }
        
        // Determine currency
        let currency = text.contains("EUR") || text.contains("€") ? "€" : "Unknown"
        
        if let date = date, let totalAmount = maxAmount {
            return ReceiptData(date: date, totalAmount: totalAmount, currency: currency, storeName: "Lidl")
        }
        return nil
    }
}
