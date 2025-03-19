//
//  AppCoordinator.swift
//  CoolReceipts
//
//  Created by Elano Vasconcelos on 19/03/25.
//

import SwiftUI

final class AppCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let viewFactory: ViewFactoryProtocol
    private var receiptListViewModel: ReceiptListView.ViewModel?
    
    init(navigationController: UINavigationController,
         viewFactory: ViewFactoryProtocol = ViewFactory()) {
        self.navigationController = navigationController
        self.viewFactory = viewFactory
    }
    
    /// Starts the coordinator by displaying the list screen
    func start() {
        let view = viewFactory.makeReceiptListView { [weak self] action in
            switch action {
            case .didTapCapture:
                self?.openCapture()
            }
        }
        receiptListViewModel = view.viewModel
        
        push(view, title: "List", animated: false)
    }
    
    func openCapture() {
        print("openCapture")
    }
}
