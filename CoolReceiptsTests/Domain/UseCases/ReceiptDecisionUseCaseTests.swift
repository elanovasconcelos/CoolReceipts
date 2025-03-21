//
//  ReceiptDecisionUseCaseTests.swift
//  CoolReceiptsTests
//
//  Created by Elano Vasconcelos on 21/03/25.
//

import XCTest
@testable import CoolReceipts

final class ReceiptDecisionUseCaseTests: XCTestCase {

    var decisionUseCase: ReceiptDecisionUseCaseProtocol!
    
    override func setUpWithError() throws {
        decisionUseCase = ReceiptDecisionUseCase()
    }

    override func tearDownWithError() throws {
        decisionUseCase = nil
    }

    /// Given a sample receipt text containing "lidl",
    /// when executing the decision use case,
    /// then it should return valid ReceiptData with the expected values.
    func testExecute_whenTextMatchesLidl_thenReturnsReceiptData() {
        // Given: a sample receipt text with expected values
        let sampleText = """
        
        www.lidlpt
        LIDL & Cia - Porto - Rotunda AEP
        Original
        Data de Venda:
        2025-03-16
        SACO DE PAPEL
        Total
        MULTIBANCO
        Taxa
        A 23%
        6%
        C 13%
        Val. Total
        11,52
        9,12
        2,18
        EUR
        0,15 A
        1,95 B
        ------
        22,82
        22,82
        Val .IVA
        2,15
        """
        
        // When: execute the decision use case with the sample text
        let receiptData = decisionUseCase.execute(text: sampleText)
        
        // Then: verify that receiptData is not nil and contains the expected values.
        XCTAssertNotNil(receiptData, "Expected ReceiptData to be returned for valid Lidl receipt text.")
        if let data = receiptData {
            XCTAssertEqual(data.storeName, "Lidl")
            
            // Create the expected date from the string "2025-03-16"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let expectedDate = dateFormatter.date(from: "2025-03-16")
            XCTAssertEqual(data.date, expectedDate)
            
            // Verify the total amount using an accuracy parameter due to floating-point precision.
            XCTAssertEqual(data.totalAmount, 22.82, accuracy: 0.01, "Total amount should be 22.82")
            
            // Verify the currency.
            XCTAssertEqual(data.currency, "€")
        }
    }
    
    /// Given a text that does not contain any known keywords,
    /// when executing the decision use case,
    /// then it should return nil.
    func testExecute_whenTextDoesNotMatchAnyParser_thenReturnsNil() {
        // Given: a sample text that doesn't contain "lidl"
        let sampleText = "This is a random text that does not contain the keyword."
        
        // When: execute the decision use case with non-matching text
        let receiptData = decisionUseCase.execute(text: sampleText)
        
        // Then: verify that the use case returns nil.
        XCTAssertNil(receiptData, "Expected nil when text does not match any parser.")
    }

}
