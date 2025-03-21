//
//  ProcessReceiptUseCase.swift
//  CoolReceipts
//
//  Created by Elano Vasconcelos on 19/03/25.
//

import UIKit

enum ProcessReceiptError: Error, LocalizedError {
    case ocrFailed
    case parsingFailed
    case repositoryError(Error)
    
    var errorDescription: String? {
        switch self {
        case .ocrFailed:
            return "Failed to perform OCR on the image."
        case .parsingFailed:
            return "Failed to extract receipt information from the OCR text."
        case .repositoryError(let error):
            return "Repository error: \(error.localizedDescription)"
        }
    }
}

protocol ProcessReceiptUseCaseProtocol {
    func execute(image: UIImage) async throws -> ReceiptRealmModel
}

struct ProcessReceiptUseCase: ProcessReceiptUseCaseProtocol {
    private let ocrUseCase: ReceiptOCRUseCaseProtocol
    private let decisionUseCase: ReceiptDecisionUseCaseProtocol
    private let repository: ReceiptRepositoryProtocol

    init(ocrUseCase: ReceiptOCRUseCaseProtocol = ReceiptOCRUseCase(),
         decisionUseCase: ReceiptDecisionUseCaseProtocol = ReceiptDecisionUseCase(),
         repository: ReceiptRepositoryProtocol = ReceiptRepository()) {
        self.ocrUseCase = ocrUseCase
        self.decisionUseCase = decisionUseCase
        self.repository = repository
    }
    
    func execute(image: UIImage) async throws -> ReceiptRealmModel {
        let recognizedText = await ocrUseCase.execute(image: image)
        
        if recognizedText.isEmpty {
            throw ProcessReceiptError.ocrFailed
        }
        
        guard let receiptData = decisionUseCase.execute(text: recognizedText) else {
            throw ProcessReceiptError.parsingFailed
        }
        
        do {
            return try repository.saveReceipt(receiptData: receiptData, image: image)
        } catch {
            throw ProcessReceiptError.repositoryError(error)
        }
    }
}
