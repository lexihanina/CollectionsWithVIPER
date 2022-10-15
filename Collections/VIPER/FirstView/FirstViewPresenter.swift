//
//  Presenter.swift
//  Collections
//
//  Created by Lexi Hanina on 3/14/22.
//

import Foundation
import UIKit

protocol FirstPresenterProtocol: AnyObject {
    var router: FirstRouterProtocol? { get set }
    var interactor: FirstInteractorProtocol? { get set }
    var view: FirstViewControllerProtocol? { get set }
    func configureView()
    func didTapForDetails(device: AppleDevices)
}

final class FirstViewPresenter: FirstPresenterProtocol {
    var router: FirstRouterProtocol?
    var interactor: FirstInteractorProtocol?
    weak var view: FirstViewControllerProtocol?
    
    required init(view: FirstViewControllerProtocol) {
        self.view = view
    }
    
    func configureView() {
        guard let devices = interactor?.getAllDevices() else { return }
        view?.update(with: devices)
    }
    
    func didTapForDetails(device: AppleDevices) {
        router?.openDetailsScreen(forDevice: device)
    }
}

extension FirstViewPresenter: DetailsViewControllerDelegate {
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
