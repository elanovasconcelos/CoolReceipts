//
//  ReceiptDetailsView.swift
//  CoolReceipts
//
//  Created by Elano Vasconcelos on 20/03/25.
//

import SwiftUI

struct ReceiptDetailsView: View {
    @State var viewModel: ViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let uiImage = viewModel.image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 400)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 300)
                        .overlay(Text("Image not available")
                                    .foregroundColor(.gray))
                        .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.storeText)
                        .font(.headline)
                    Text(viewModel.totalText)
                        .font(.subheadline)
                    Text(viewModel.dateText)
                        .font(.subheadline)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
    }
}

extension ReceiptDetailsView {
    
    @Observable
    final class ViewModel {
        let receipt: ReceiptRealmModel
        private let loadImageUseCase: LoadReceiptImageUseCaseProtocol
        
        init(receipt: ReceiptRealmModel,
             loadImageUseCase: LoadReceiptImageUseCaseProtocol = LoadReceiptImageUseCase()) {
            self.receipt = receipt
            self.loadImageUseCase = loadImageUseCase
        }
        
        private var formattedDate: String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: receipt.date)
        }
        
        var storeText: String {
            "Store: \(receipt.storeName)"
        }

        var totalText: String {
            "Total: \(String(format: "%.2f", receipt.totalAmount)) \(receipt.currency)"
        }
        
        var dateText: String {
            "Date: \(formattedDate)"
        }
        
        var image: UIImage? {
            loadImageUseCase.execute(receipt: receipt)
        }
    }
}
