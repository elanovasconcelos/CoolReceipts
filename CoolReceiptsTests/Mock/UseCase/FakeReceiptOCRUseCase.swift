//
//  FakeReceiptOCRUseCase.swift
//  CoolReceipts
//
//  Created by Elano Vasconcelos on 21/03/25.
//

import UIKit
@testable import CoolReceipts

class FakeReceiptOCRUseCase: ReceiptOCRUseCaseProtocol {
    var recognizedText: String = ""
    func execute(image: UIImage) async -> String {
        return recognizedText
    }
}
