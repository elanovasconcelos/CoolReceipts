//
//  LoadReceiptImageUseCase.swift
//  CoolReceipts
//
//  Created by Elano Vasconcelos on 20/03/25.
//

import UIKit

protocol LoadReceiptImageUseCaseProtocol {
    func execute(receipt: ReceiptRealmModel) -> UIImage?
}

struct LoadReceiptImageUseCase: LoadReceiptImageUseCaseProtocol {
    func execute(receipt: ReceiptRealmModel) -> UIImage? {
        let fileName = (receipt.imagePath as NSString).lastPathComponent
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileURL.path)
    }
}
