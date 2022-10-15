//
//  DetailsViewInteractor.swift
//  Collections
//
//  Created by Lexi Hanina on 3/16/22.
//

import Foundation

protocol DetailsInteractorProtocol: AnyObject {
    var presenter: DetailsPresenterProtocol? { get set }
}

final class DetailsViewInteractor: DetailsInteractorProtocol {
    var presenter: DetailsPresenterProtocol?
    
    required init(presenter: DetailsPresenterProtocol) {
            self.presenter = presenter
        }
}
