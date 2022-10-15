//
//  SortedDevicesPresenter.swift
//  Collections
//
//  Created by Lexi Hanina on 3/18/22.
//

import Foundation
import UIKit

protocol SortedDevicesPresenterProtocol: AnyObject {
    var router: SortedDevicesRouterProtocol? { get set }
    var interactor: SortedDevicesInteractorProtocol? { get set }
    var view: SortedDevicesViewControllerProtocol? { get set }
    func configureView()
    func didTapForDetails(device: AppleDevices)
    func didTapAdd(toSection: Int)
}

final class SortedDevicesViewPresenter: SortedDevicesPresenterProtocol{
    var router: SortedDevicesRouterProtocol?
    var interactor: SortedDevicesInteractorProtocol?
    weak var view: SortedDevicesViewControllerProtocol?
    
    required init(view: SortedDevicesViewControllerProtocol) {
        self.view = view
    }
    
    func configureView() {
        guard let pads = interactor?.getAllPads() else { return }
        guard let phones = interactor?.getAllPhones() else { return }
        view?.update(with: pads, phones: phones)
    }
    
    func didTapForDetails(device: AppleDevices) {
        router?.openDetailsScreen(forDevice: device)
    }
    
    func didTapAdd(toSection: Int) {
        router?.openAddNewDevice(toSection: toSection)
    }
}

extension SortedDevicesViewPresenter: DetailsViewControllerDelegate {
    func deviceInfoViewController(_ controller: DetailsViewController,
                                  didSaveInfo info: String,
                                  withName name: String) {
        view?.updateTextWithChanges(withName: name, info: info)
    }
    
    func deviceInfoViewController(_ controller: DetailsViewController,
                                  didSaveImage image: UIImage) {
        view?.updateImageWithChanges(withImage: image)
    }
}
