//
//  ReceiptListViewTests.swift
//  CoolReceiptsTests
//
//  Created by Elano Vasconcelos on 21/03/25.
//

import XCTest
import SwiftUI
import RealmSwift
import ViewInspector
@testable import CoolReceipts

final class ReceiptListViewTests: XCTestCase {

    override func setUpWithError() throws {
        // Use an in-memory Realm for testing so that we don't persist data between tests.
        var config = Realm.Configuration()
        config.inMemoryIdentifier = "TestRealm"
        Realm.Configuration.defaultConfiguration = config
    }

    override func tearDownWithError() throws {
        // Clean up the in-memory Realm after each test.
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }

    /// Given an empty receipts collection,
    /// when the ReceiptListView is displayed,
    /// then it should show the "No receipts found." message.
    func testReceiptListView_whenReceiptsEmpty_thenShowsNoReceiptsText() throws {
        // Given: an empty Realm and a dummy view model.
        let viewModel = ReceiptListView.ViewModel()
        let view = ReceiptListView(viewModel: viewModel)
        
        // When: inspecting the view.
        let list = try view.inspect().find(ViewType.List.self)
        
        // Then: verify that the list contains the "No receipts found." text.
        let noReceiptsText = try list.find(text: "No receipts found.")
        XCTAssertEqual(try noReceiptsText.string(), "No receipts found.")
    }
    
    /// Given a non-empty receipts collection,
    /// when the ReceiptListView is displayed,
    /// then it should show a ReceiptRowView for each receipt.
    func testReceiptListView_whenReceiptsNonEmpty_thenShowsReceiptRowViews() throws {
        // Given: add a test receipt to the in-memory Realm.
        let realm = try! Realm()
        try! realm.write {
            let receipt = ReceiptRealmModel()
            receipt.storeName = "Test Store"
            receipt.totalAmount = 10.0
            receipt.currency = "$"
            receipt.date = Date()
            realm.add(receipt)
        }
        
        let viewModel = ReceiptListView.ViewModel()
        let view = ReceiptListView(viewModel: viewModel)
        
        // When: inspecting the List.
        let list = try view.inspect().find(ViewType.List.self)
        // Then: expect at least one ReceiptRowView to be present.
        let rows = list.findAll(ReceiptRowView.self)
        XCTAssertFalse(rows.isEmpty, "Expected at least one receipt row when receipts exist.")
    }
    
    /// Given a ReceiptListView,
    /// when the view model's captureNewReceipt function is called,
    /// then it should trigger the didTapCapture action.
    func testReceiptListView_captureNewReceipt_triggersDidTapCapture() {
        // Given: a view model with an expectation.
        let expectation = self.expectation(description: "Capture new receipt action triggered")
        let viewModel = ReceiptListView.ViewModel { action in
            if case .didTapCapture = action {
                expectation.fulfill()
            }
        }
        
        // When: calling captureNewReceipt directly.
        viewModel.captureNewReceipt()
        
        // Then: wait for the expectation to be fulfilled.
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    /// Given a ReceiptListView with a receipt in the list,
    /// when a receipt row is tapped,
    /// then it should trigger the viewModel.didSelectItem action.
    func testReceiptListView_receiptRowTapped_triggersDidSelectItem() throws {
        // Given: add a test receipt to the in-memory Realm.
        let realm = try! Realm()
        var testReceipt: ReceiptRealmModel!
        try! realm.write {
            testReceipt = ReceiptRealmModel()
            testReceipt.storeName = "Test Store"
            testReceipt.totalAmount = 10.0
            testReceipt.currency = "$"
            testReceipt.date = Date()
            realm.add(testReceipt)
        }
        
        let expectation = self.expectation(description: "Did select item action triggered")
        let viewModel = ReceiptListView.ViewModel { action in
            if case .didSelectItem(let receipt) = action, receipt.id == testReceipt.id {
                expectation.fulfill()
            }
        }
        let view = ReceiptListView(viewModel: viewModel)
        
        // When: simulate tapping the first receipt row.
        let list = try view.inspect().find(ViewType.List.self)
        // Locate the ReceiptRowView and simulate the onTapGesture.
        let row = try list.find(ReceiptRowView.self)
        try row.callOnTapGesture()
        
        // Then: wait for the expectation.
        waitForExpectations(timeout: 1, handler: nil)
    }

}
