//
//  ReceiptRepository.swift
//  CoolReceipts
//
//  Created by Elano Vasconcelos on 19/03/25.
//

import RealmSwift
import UIKit

protocol ReceiptRepositoryProtocol {
    /// Save receipt along with its image, returning the saved Realm model.
    func saveReceipt(receiptData: ReceiptData, image: UIImage) throws -> ReceiptRealmModel
    /// Retrieve all receipts stored in Realm.
    func listReceipts() throws -> [ReceiptRealmModel]
}

final class ReceiptRepository: ReceiptRepositoryProtocol {

    func saveReceipt(receiptData: ReceiptData, image: UIImage) throws -> ReceiptRealmModel {
        let realm = try Realm()
        
        let receipt = ReceiptRealmModel()
        receipt.date = receiptData.date
        receipt.totalAmount = receiptData.totalAmount
        receipt.currency = receiptData.currency
        receipt.storeName = receiptData.storeName
        
        if let imagePath = saveImageToDocuments(image: image, id: receipt.id) {
            receipt.imagePath = imagePath
        } else {
            print("Failed to save image for receipt with id: \(receipt.id)")
        }
        
        try realm.write {
            realm.add(receipt)
        }
        
        return receipt
    }
    
    func listReceipts() throws -> [ReceiptRealmModel] {
        let realm = try Realm()
        
        let receipts = realm.objects(ReceiptRealmModel.self)
        return Array(receipts)
    }
    
    private func saveImageToDocuments(image: UIImage, id: String) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }

        let filename = "receipt_\(id).jpg"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        do {
            try data.write(to: fileURL)
            return fileURL.path
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
}
