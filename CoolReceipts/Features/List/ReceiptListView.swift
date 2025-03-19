//
//  ReceiptListView.swift
//  CoolReceipts
//
//  Created by Elano Vasconcelos on 19/03/25.
//

import SwiftUI

struct ReceiptListView: View {
    
    @State var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Button(action: {
                viewModel.captureNewReceipt()
            }) {
                Image(systemName: "camera")
            }
        }
    }
}


extension ReceiptListView {
    
    typealias ActionHandler = (ReceiptListView.Action) -> Void

    // MARK: - Action
    enum Action {
        case didTapCapture
    }
    
    @Observable
    final class ViewModel {
        
        // MARK: - Action Handler
        private let onActionSelected: ActionHandler
        
        // MARK: - Initializer
        init(onActionSelected: @escaping ActionHandler = { _ in }) {
            self.onActionSelected = onActionSelected
        }
        
        func captureNewReceipt() {
            onActionSelected(.didTapCapture)
        }
    }
}



#Preview {
    ReceiptListView(viewModel: ReceiptListView.ViewModel())
}
