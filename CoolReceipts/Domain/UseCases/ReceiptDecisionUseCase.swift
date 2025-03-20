//
//  ReceiptDecisionUseCase.swift
//  CoolReceipts
//
//  Created by Elano Vasconcelos on 19/03/25.
//

import Foundation

protocol ReceiptDecisionUseCaseProtocol {
    func execute(text: String) -> ReceiptData?
}

struct ReceiptDecisionUseCase: ReceiptDecisionUseCaseProtocol {
    private let parsers: [ReceiptParser]
    
    init(parsers: [ReceiptParser] = ReceiptDecisionUseCase.all()) {
        self.parsers = parsers
    }
    
    // Iterates over available parsers and returns the first that can handle the text.
    func execute(text: String) -> ReceiptData? {
        for parser in parsers {
            if parser.canParse(text: text) {
                return parser.parse(text: text)
            }
        }
        return nil
    }
}

extension ReceiptDecisionUseCase {
    static func all() -> [ReceiptParser] {
        [LidlReceiptParser()]
    }
}
