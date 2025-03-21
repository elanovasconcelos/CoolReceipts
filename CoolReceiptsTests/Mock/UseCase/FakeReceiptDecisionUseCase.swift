//
//  FakeReceiptDecisionUseCase.swift
//  CoolReceipts
//
//  Created by Elano Vasconcelos on 21/03/25.
//

import UIKit
@testable import CoolReceipts

class FakeReceiptDecisionUseCase: ReceiptDecisionUseCaseProtocol {
    var receiptData: ReceiptData? = nil
    func execute(text: String) -> ReceiptData? {
        return receiptData
    }
}
