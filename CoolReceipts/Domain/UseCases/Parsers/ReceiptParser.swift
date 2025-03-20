//
//  ReceiptParser.swift
//  CoolReceipts
//
//  Created by Elano Vasconcelos on 19/03/25.
//

import Foundation

protocol ReceiptParser {
    // Determines if this parser can handle the provided text.
    func canParse(text: String) -> Bool
    // Parses the text and returns a ReceiptData struct if successful.
    func parse(text: String) -> ReceiptData?
}
