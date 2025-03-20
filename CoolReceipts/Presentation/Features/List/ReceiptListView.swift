//
//  ReceiptListView.swift
//  CoolReceipts
//
//  Created by Elano Vasconcelos on 19/03/25.
//

import SwiftUI
import RealmSwift

struct ReceiptListView: View {

    @State var viewModel: ViewModel
    // Automatically update the list when Realm data changes
    @ObservedResults(ReceiptRealmModel.self) var receipts
    
    var body: some View {
        ZStack {
            List {
                if receipts.isEmpty {
                    Text("No receipts found.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(receipts) { receipt in
                        ReceiptRowView(receipt: receipt)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.didSelectItem(receipt)
                            }
                    }
                }
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.captureNewReceipt()
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}


extension ReceiptListView {
    
    typealias ActionHandler = (ReceiptListView.Action) -> Void

    // MARK: - Action
    enum Action {
        case didTapCapture
        case didSelectItem(ReceiptRealmModel)
    }
    
    @Observable
    final class ViewModel {
        
        // MARK: - Action Handler
        private let onActionSelected: ActionHandler
        
        private(set) var isLoading: Bool = false
        
        // MARK: - Initializer
        init(onActionSelected: @escaping ActionHandler = { _ in }) {
            self.onActionSelected = onActionSelected
        }
        
        func captureNewReceipt() {
            onActionSelected(.didTapCapture)
        }
        
        func didSelectItem(_ receipt: ReceiptRealmModel) {
            onActionSelected(.didSelectItem(receipt))
        }
        
        func showLoading() {
            isLoading = true
        }
        
        func hideLoading() {
            isLoading = false
        }
    }
}



#Preview {
    ReceiptListView(viewModel: ReceiptListView.ViewModel())
}
