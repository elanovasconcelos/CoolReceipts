//
//  ReceiptDetailsViewTests.swift
//  CoolReceiptsTests
//
//  Created by Elano Vasconcelos on 21/03/25.
//

import XCTest
import SwiftUI
import RealmSwift
import ViewInspector
@testable import CoolReceipts

final class ReceiptDetailsViewTests: XCTestCase {

    /// Given a receipt with known properties.
    func makeTestReceipt() -> ReceiptRealmModel {
        let receipt = ReceiptRealmModel()
        receipt.storeName = "Test Store"
        receipt.totalAmount = 10.0
        receipt.currency = "$"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        receipt.date = formatter.date(from: "2025-03-16")!
        
        return receipt
    }
    
    /// Given a valid receipt with an available image,
    /// when displaying the ReceiptDetailsView,
    /// then it should display the image and correct text information.
    func testReceiptDetailsView_whenImageAvailable_thenDisplaysImageAndText() throws {
        // Given
        let receipt = makeTestReceipt()
        let testImage = UIImage(systemName: "star.fill")! // Use a system image for testing.
        let fakeImageUseCase = FakeLoadReceiptImageUseCase()
        fakeImageUseCase.fakeImage = testImage
        
        let viewModel = ReceiptDetailsView.ViewModel(receipt: receipt, loadImageUseCase: fakeImageUseCase)
        let view = ReceiptDetailsView(viewModel: viewModel)
        
        // When: Inspect the view hierarchy.
        let inspectedView = try view.inspect()
        
        // Then: Verify that an Image view is displayed somewhere in the hierarchy.
        let imageView = try inspectedView.find(ViewType.Image.self)
        XCTAssertNotNil(imageView, "Expected an Image view when an image is available.")
        
        // Then: Verify that the expected text values are present.
        let storeText = try inspectedView.find(text: "Store: \(receipt.storeName)").string()
        XCTAssertEqual(storeText, "Store: \(receipt.storeName)")
        
        let totalText = try inspectedView.find(text: "Total: \(String(format: "%.2f", receipt.totalAmount)) \(receipt.currency)").string()
        XCTAssertEqual(totalText, "Total: \(String(format: "%.2f", receipt.totalAmount)) \(receipt.currency)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let expectedDateText = "Date: \(dateFormatter.string(from: receipt.date))"
        let dateText = try inspectedView.find(text: expectedDateText).string()
        XCTAssertEqual(dateText, expectedDateText)
    }
    
    /// Given a valid receipt with no available image,
    /// when displaying the ReceiptDetailsView,
    /// then it should display the placeholder text "Image not available".
    func testReceiptDetailsView_whenImageNotAvailable_thenDisplaysPlaceholderText() throws {
        // Given
        let receipt = makeTestReceipt()
        let fakeImageUseCase = FakeLoadReceiptImageUseCase()
        fakeImageUseCase.fakeImage = nil // Simulate no image available.
        
        let viewModel = ReceiptDetailsView.ViewModel(receipt: receipt, loadImageUseCase: fakeImageUseCase)
        let view = ReceiptDetailsView(viewModel: viewModel)
        
        // When: Inspect the view hierarchy.
        let inspectedView = try view.inspect()
        
        // Then: Verify that the view contains the text "Image not available".
        let placeholderText = try inspectedView.find(text: "Image not available").string()
        XCTAssertEqual(placeholderText, "Image not available")
    }

}
