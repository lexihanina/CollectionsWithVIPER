//
//  SortedDevicesConfigurator.swift
//  Collections
//
//  Created by Lexi Hanina on 3/21/22.
//

import Foundation

protocol SortedDevicesViewConfiguratorProtocol {
    func configure(with viewController: SortedDevicesViewController)
}

final class SortedDevicesViewConfigurator: SortedDevicesViewConfiguratorProtocol {
    func configure(with viewController: SortedDevicesViewController) {
        let presenter = SortedDevicesViewPresenter(view: viewController)
        let interactor = SortedDevicesViewInteractor(presenter: presenter)
        let router = SortedDevicesViewRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
