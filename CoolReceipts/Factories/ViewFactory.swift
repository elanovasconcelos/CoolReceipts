//
//  ViewFactory.swift
//  CoolReceipts
//
//  Created by Elano Vasconcelos on 19/03/25.
//

import Foundation

final class ViewFactory: ViewFactoryProtocol {
    
    init() {

    }
    
    func makeReceiptListView(onActionSelected: @escaping ReceiptListView.ActionHandler) -> ReceiptListView {
        let viewModel = ReceiptListView.ViewModel(onActionSelected: onActionSelected)
        return ReceiptListView(viewModel: viewModel)
    }
    
    func makeReceiptDetailsView(receipt: ReceiptRealmModel) -> ReceiptDetailsView {
        let viewModel = ReceiptDetailsView.ViewModel(receipt: receipt)
        return ReceiptDetailsView(viewModel: viewModel)
    }
}
