//
//  AppCoordinator.swift
//  CoolReceipts
//
//  Created by Elano Vasconcelos on 19/03/25.
//

import SwiftUI

final class AppCoordinator: NSObject, Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let viewFactory: ViewFactoryProtocol
    private var receiptListViewModel: ReceiptListView.ViewModel?
    private let useCase: ProcessReceiptUseCaseProtocol
    
    init(navigationController: UINavigationController,
         viewFactory: ViewFactoryProtocol = ViewFactory(),
         useCase: ProcessReceiptUseCaseProtocol = ProcessReceiptUseCase()) {
        self.navigationController = navigationController
        self.viewFactory = viewFactory
        self.useCase = useCase
    }
    
    /// Starts the coordinator by displaying the list screen
    func start() {
        let view = viewFactory.makeReceiptListView { [weak self] action in
            switch action {
            case .didTapCapture:
                self?.openCapture()
            case .didSelectItem(let item):
                self?.openDetails(item: item)
            }
        }
        receiptListViewModel = view.viewModel
        
        push(view, title: "Receipts", animated: false)
    }
    
    func openCapture() {
        let sourceType: UIImagePickerController.SourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        
        navigationController.present(imagePicker, animated: true)
    }
    
    func openDetails(item: ReceiptRealmModel) {
        let view = viewFactory.makeReceiptDetailsView(receipt: item)
        
        print("item: \(item)")
        
        push(view, title: "Receipt Details", animated: true)
    }
    
    func showError(message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let topViewController = self.navigationController.topViewController else { return }
            
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            topViewController.present(alert, animated: true, completion: nil)
        }
    }
}

extension AppCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        receiptListViewModel?.showLoading()
        Task {
            defer {
                receiptListViewModel?.hideLoading()
            }
            do {
                let _ = try await useCase.execute(image: image)
            } catch {
                showError(message: error.localizedDescription)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
