//
//  AddNewDeviceConfigurator.swift
//  Collections
//
//  Created by Lexi Hanina on 3/21/22.
//

import Foundation

protocol AddNewDeviceViewConfiguratorProtocol {
    func configure(with viewController: AddNewDeviceViewController)
}

final class AddNewDeviceViewConfigurator: AddNewDeviceViewConfiguratorProtocol {
    func configure(with viewController: AddNewDeviceViewController) {
        let presenter = AddNewDevicePresenter(view: viewController)
        let interactor = AddNewDeviceInteractor(presenter: presenter)
        let router = AddNewDeviceRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
