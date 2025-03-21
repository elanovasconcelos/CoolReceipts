//
//  FakeLoadReceiptImageUseCase.swift
//  CoolReceipts
//
//  Created by Elano Vasconcelos on 21/03/25.
//

import UIKit
@testable import CoolReceipts

class FakeLoadReceiptImageUseCase: LoadReceiptImageUseCaseProtocol {
    var fakeImage: UIImage?
    func execute(receipt: ReceiptRealmModel) -> UIImage? {
        return fakeImage
    }
}
