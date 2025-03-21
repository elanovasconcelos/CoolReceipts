//
//  FakeReceiptRepository.swift
//  CoolReceipts
//
//  Created by Elano Vasconcelos on 21/03/25.
//

import UIKit
@testable import CoolReceipts

class FakeReceiptRepository: ReceiptRepositoryProtocol {
    var shouldThrowError: Bool = false
    var errorToThrow: Error?
    var savedReceipts: [ReceiptRealmModel] = []
    
    func saveReceipt(receiptData: ReceiptData, image: UIImage) throws -> ReceiptRealmModel {
        if shouldThrowError, let error = errorToThrow {
            throw error
        }
        
        let receipt = ReceiptRealmModel()
        receipt.storeName = receiptData.storeName
        receipt.totalAmount = receiptData.totalAmount
        receipt.currency = receiptData.currency
        receipt.date = receiptData.date

        savedReceipts.append(receipt)
        
        return receipt
    }
    
    func listReceipts() throws -> [ReceiptRealmModel] {
        return savedReceipts
    }
}
