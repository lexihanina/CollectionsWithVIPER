//
//  FirstViewConfigurator.swift
//  Collections
//
//  Created by Lexi Hanina on 3/21/22.
//

import Foundation

protocol FirstViewConfiguratorProtocol {
    func configure(with viewController: FirstViewController)
}

final class FirstViewConfigurator: FirstViewConfiguratorProtocol {
    func configure(with viewController: FirstViewController) {
        let presenter = FirstViewPresenter(view: viewController)
        let interactor = FirstViewInteractor(presenter: presenter)
        let router = FirstViewRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
