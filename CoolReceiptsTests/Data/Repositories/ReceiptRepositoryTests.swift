//
//  ReceiptRepositoryTests.swift
//  CoolReceiptsTests
//
//  Created by Elano Vasconcelos on 21/03/25.
//

import XCTest
import RealmSwift
import UIKit
@testable import CoolReceipts

final class ReceiptRepositoryTests: XCTestCase {

    /// Given an in‑memory Realm configuration,
    /// when the tests run,
    /// then the repository operations will be isolated.
    override func setUpWithError() throws {
        var config = Realm.Configuration()
        config.inMemoryIdentifier = "ReceiptRepositoryTests"
        Realm.Configuration.defaultConfiguration = config
    }

    override func tearDownWithError() throws {
        // Clean up Realm data.
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
        // Clean up any files created in the Documents directory.
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileManager = FileManager.default
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                if fileURL.lastPathComponent.hasPrefix("receipt_") {
                    try fileManager.removeItem(at: fileURL)
                }
            }
        } catch {
            print("Error cleaning up files: \(error)")
        }
    }

    /// Given a valid ReceiptData and a valid image,
    /// when saving a receipt,
    /// then it should return a ReceiptRealmModel with matching values
    /// and the image file should exist at the specified path.
    func testSaveReceipt_shouldSaveReceiptCorrectly() throws {
        // Given
        let now = Date()
        let receiptData = ReceiptData(date: now, totalAmount: 12.34, currency: "$", storeName: "Test Store")
        let dummyImage = UIImage(systemName: "star.fill") ?? UIImage()
        
        let repository: ReceiptRepositoryProtocol = ReceiptRepository()
        
        // When
        let savedReceipt = try repository.saveReceipt(receiptData: receiptData, image: dummyImage)
        
        // Then
        XCTAssertEqual(savedReceipt.storeName, receiptData.storeName)
        XCTAssertEqual(savedReceipt.totalAmount, receiptData.totalAmount, accuracy: 0.01)
        XCTAssertEqual(savedReceipt.currency, receiptData.currency)
        XCTAssertEqual(savedReceipt.date, receiptData.date)
        XCTAssertFalse(savedReceipt.imagePath.isEmpty, "Expected a non-empty image path.")
        
        let fileManager = FileManager.default
        XCTAssertTrue(fileManager.fileExists(atPath: savedReceipt.imagePath), "Expected image file to exist at the saved path.")
    }
    
    /// Given one or more receipts saved in the repository,
    /// when listing receipts,
    /// then it should return an array containing all the saved ReceiptRealmModel objects.
    func testListReceipts_shouldReturnSavedReceipts() throws {
        // Given
        let receiptData1 = ReceiptData(date: Date(), totalAmount: 12.34, currency: "$", storeName: "Test Store 1")
        let receiptData2 = ReceiptData(date: Date(), totalAmount: 56.78, currency: "€", storeName: "Test Store 2")
        let dummyImage = UIImage(systemName: "star.fill") ?? UIImage()
        
        let repository: ReceiptRepositoryProtocol = ReceiptRepository()
        _ = try repository.saveReceipt(receiptData: receiptData1, image: dummyImage)
        _ = try repository.saveReceipt(receiptData: receiptData2, image: dummyImage)
        
        // When
        let receipts = try repository.listReceipts()
        
        // Then
        XCTAssertEqual(receipts.count, 2, "Expected 2 receipts in the list.")

        let firstReceipt = receipts.first
        XCTAssertEqual(firstReceipt?.storeName, receiptData1.storeName)
    }

}
