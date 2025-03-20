//
//  ReceiptOCRUseCase.swift
//  CoolReceipts
//
//  Created by Elano Vasconcelos on 19/03/25.
//

import UIKit
@preconcurrency import Vision

protocol ReceiptOCRUseCaseProtocol {
    func execute(image: UIImage) async -> String
}

struct ReceiptOCRUseCase: ReceiptOCRUseCaseProtocol {
    func execute(image: UIImage) async -> String {
        await withCheckedContinuation { continuation in
            guard let cgImage = image.cgImage else {
                continuation.resume(returning: "")
                return
            }
            
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    print("OCR Error: \(error)")
                    continuation.resume(returning: "")
                    return
                }
                let texts = request.results?.compactMap { result in
                    (result as? VNRecognizedTextObservation)?.topCandidates(1).first?.string
                }
                continuation.resume(returning: texts?.joined(separator: "\n") ?? "")
            }
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["pt-BR", "pt-PT", "en-US"]
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try requestHandler.perform([request])
                } catch {
                    print("Failed to perform OCR: \(error)")
                    continuation.resume(returning: "")
                }
            }
        }
    }
}
