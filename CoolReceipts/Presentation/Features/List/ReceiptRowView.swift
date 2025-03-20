//
//  ReceiptRowView.swift
//  CoolReceipts
//
//  Created by Elano Vasconcelos on 19/03/25.
//

import SwiftUI

struct ReceiptRowView: View {
    var receipt: ReceiptRealmModel
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(receipt.storeName)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Date: \(receipt.date, formatter: Self.dateFormatter)")
                    .font(.caption)
            }
            
            Text("Total: \(receipt.totalAmount, specifier: "%.2f") \(receipt.currency)")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
