//
//  Coordinator.swift
//  CoolReceipts
//
//  Created by Elano Vasconcelos on 19/03/25.
//

import SwiftUI

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    /// Start the coordinator
    func start()
}

extension Coordinator {
    func push(_ view: some View, title: String = "", animated: Bool = true) {
        let controller = host(view, title: title)
        
        navigationController.pushViewController(controller, animated: animated)
    }
    
    func present(_ view: some View, title: String = "") {
        let controller = host(view, title: title)
        
        navigationController.present(controller, animated: true)
    }
    
    func host(_ view: some View, title: String = "") -> UIViewController {
        let hostingController = UIHostingController(rootView: view)
        hostingController.title = title
        
        return hostingController
    }
}
