//
//  ReceiptOCRUseCaseTests.swift
//  CoolReceiptsTests
//
//  Created by Elano Vasconcelos on 21/03/25.
//

import XCTest
@testable import CoolReceipts

final class ReceiptOCRUseCaseTests: XCTestCase {

    var ocrUseCase: ReceiptOCRUseCaseProtocol!
    var testBundle: Bundle!
    
    override func setUpWithError() throws {
        ocrUseCase = ReceiptOCRUseCase()
        testBundle = Bundle(for: type(of: self))
    }

    override func tearDownWithError() throws {
        ocrUseCase = nil
        testBundle = nil
    }

    /// Given an image with nil cgImage,
    /// when executing the OCR use case,
    /// then it should return an empty string.
    func testExecute_whenCGImageIsNil_thenReturnsEmptyString() async {
        // Given
        let ciImage = CIImage(color: .white)
        let testImage = UIImage(ciImage: ciImage)
        
        // When
        let result = await ocrUseCase.execute(image: testImage)
        
        // Then
        XCTAssertEqual(result, "", "Expected empty OCR result when cgImage is nil.")
    }
    

    /// Given a valid receipt image in the test bundle,
    /// when executing the OCR use case,
    /// then it should return a non-empty result containing 'lidl'.
    func testExecute_whenUsingRealReceiptImage_thenReturnsExpectedText() async throws {
        // Given: Load the test image from the test bundle.
        guard let imageURL = testBundle.url(forResource: "receipt_sample", withExtension: "jpeg") else {
            XCTFail("Failed to find receipt_sample.jpeg in the test bundle.")
            return
        }
        let imageData = try Data(contentsOf: imageURL)
        guard let testImage = UIImage(data: imageData) else {
            XCTFail("Failed to load image from receipt_sample.jpg")
            return
        }
        
        // When: Execute the OCR process.
        let result = await ocrUseCase.execute(image: testImage)
        
        // Then: Assert that the result is non-empty and contains the expected substring.
        XCTAssertFalse(result.isEmpty, "Expected non-empty OCR result from a real image.")
        XCTAssertTrue(result.lowercased().contains("lidl"), "OCR result should contain 'lidl'.")
    }

}
