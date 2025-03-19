//
//  ViewFactoryProtocol.swift
//  CoolReceipts
//
//  Created by Elano Vasconcelos on 19/03/25.
//

import Foundation

protocol ViewFactoryProtocol {
    func makeReceiptListView(onActionSelected: @escaping ReceiptListView.ActionHandler) -> ReceiptListView
}
