//
//  DetailsViewConfigurtor.swift
//  Collections
//
//  Created by Lexi Hanina on 3/21/22.
//

import Foundation

protocol DetailsViewConfiguratorProtocol {
    func configure(with viewController: DetailsViewController)
}

final class DetailsViewConfigurator: DetailsViewConfiguratorProtocol {
    func configure(with viewController: DetailsViewController) {
        let presenter = DetailsViewPresenter(view: viewController)
        let interactor = DetailsViewInteractor(presenter: presenter)
        let router = DetailsViewRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
