//
//  ProcessReceiptUseCaseTests.swift
//  CoolReceiptsTests
//
//  Created by Elano Vasconcelos on 21/03/25.
//

import XCTest
@testable import CoolReceipts

final class ProcessReceiptUseCaseTests: XCTestCase {

    /// Given a sample ReceiptData representing a valid receipt.
    var sampleReceiptData: ReceiptData {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return ReceiptData(
            date: formatter.date(from: "2025-03-16")!,
            totalAmount: 22.82,
            currency: "€",
            storeName: "Lidl"
        )
    }
    
    /// Given an OCR use case that returns an empty string,
    /// when executing the process receipt use case,
    /// then it should throw a .ocrFailed error.
    func testExecute_whenOCRReturnsEmpty_thenThrowsOCRFailed() async {
        // Given
        let fakeOCR = FakeReceiptOCRUseCase()
        fakeOCR.recognizedText = ""
        
        let fakeDecision = FakeReceiptDecisionUseCase()
        fakeDecision.receiptData = sampleReceiptData
        
        let fakeRepository = FakeReceiptRepository()
        let useCase = ProcessReceiptUseCase(
            ocrUseCase: fakeOCR,
            decisionUseCase: fakeDecision,
            repository: fakeRepository
        )
        let dummyImage = UIImage()
        
        // When & Then
        do {
            _ = try await useCase.execute(image: dummyImage)
            XCTFail("Expected ProcessReceiptError.ocrFailed to be thrown, but no error was thrown.")
        } catch let error as ProcessReceiptError {
            // Then
            switch error {
            case .ocrFailed:
                // success
                break
            default:
                XCTFail("Expected error .ocrFailed, but got \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    /// Given an OCR use case that returns non-empty text but a decision use case that fails to parse,
    /// when executing the process receipt use case,
    /// then it should throw a .parsingFailed error.
    func testExecute_whenParsingFails_thenThrowsParsingFailed() async {
        // Given
        let fakeOCR = FakeReceiptOCRUseCase()
        fakeOCR.recognizedText = "Some non-empty text that cannot be parsed"
        
        let fakeDecision = FakeReceiptDecisionUseCase()
        fakeDecision.receiptData = nil // Simulate parsing failure.
        
        let fakeRepository = FakeReceiptRepository()
        let useCase = ProcessReceiptUseCase(
            ocrUseCase: fakeOCR,
            decisionUseCase: fakeDecision,
            repository: fakeRepository
        )
        let dummyImage = UIImage()
        
        // When & Then
        do {
            _ = try await useCase.execute(image: dummyImage)
            XCTFail("Expected ProcessReceiptError.parsingFailed to be thrown, but no error was thrown.")
        } catch let error as ProcessReceiptError {
            // Then
            switch error {
            case .parsingFailed:
                // success
                break
            default:
                XCTFail("Expected error .parsingFailed, but got \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    /// Given an OCR use case that returns valid text and a decision use case that returns valid data,
    /// when executing the process receipt use case but the repository fails to save,
    /// then it should throw a .repositoryError error.
    func testExecute_whenRepositoryFails_thenThrowsRepositoryError() async {
        // Given
        let fakeOCR = FakeReceiptOCRUseCase()
        fakeOCR.recognizedText = "Valid OCR text"
        
        let fakeDecision = FakeReceiptDecisionUseCase()
        fakeDecision.receiptData = sampleReceiptData
        
        let fakeRepository = FakeReceiptRepository()
        fakeRepository.shouldThrowError = true
        fakeRepository.errorToThrow = NSError(domain: "TestError", code: 1, userInfo: nil)
        
        let useCase = ProcessReceiptUseCase(
            ocrUseCase: fakeOCR,
            decisionUseCase: fakeDecision,
            repository: fakeRepository
        )
        let dummyImage = UIImage()
        
        // When & Then
        do {
            _ = try await useCase.execute(image: dummyImage)
            XCTFail("Expected ProcessReceiptError.repositoryError to be thrown, but no error was thrown.")
        } catch let error as ProcessReceiptError {
            // Then
            switch error {
            case .repositoryError(let underlyingError):
                XCTAssertEqual((underlyingError as NSError).domain, "TestError", "Expected repository error with domain 'TestError'")
            default:
                XCTFail("Expected repositoryError, but got \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    /// Given valid OCR and decision use cases that return expected text and data,
    /// when executing the process receipt use case,
    /// then it should return a valid ReceiptRealmModel containing the expected receipt information.
    func testExecute_whenEverythingSucceeds_thenReturnsSavedReceipt() async {
        // Given
        let fakeOCR = FakeReceiptOCRUseCase()
        fakeOCR.recognizedText = "Valid OCR text"
        
        let fakeDecision = FakeReceiptDecisionUseCase()
        fakeDecision.receiptData = sampleReceiptData
        
        let fakeRepository = FakeReceiptRepository()
        let useCase = ProcessReceiptUseCase(
            ocrUseCase: fakeOCR,
            decisionUseCase: fakeDecision,
            repository: fakeRepository
        )
        let dummyImage = UIImage()
        
        // When
        do {
            let result = try await useCase.execute(image: dummyImage)
            // Then: Verify that the returned ReceiptRealmModel contains the expected data.
            XCTAssertEqual(result.storeName, sampleReceiptData.storeName)
            XCTAssertEqual(result.totalAmount, sampleReceiptData.totalAmount, accuracy: 0.01)
            XCTAssertEqual(result.currency, sampleReceiptData.currency)
            XCTAssertEqual(result.date, sampleReceiptData.date)
            
            // Additionally, verify that listReceipts returns the saved receipt.
            let listedReceipts = try fakeRepository.listReceipts()
            XCTAssertEqual(listedReceipts.count, 1, "Expected one saved receipt.")
            XCTAssertEqual(listedReceipts.first?.storeName, sampleReceiptData.storeName)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

}
