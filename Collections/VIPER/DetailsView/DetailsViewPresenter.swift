//
//  DetailsViewPresenter.swift
//  Collections
//
//  Created by Lexi Hanina on 3/16/22.
//

import Foundation
import UIKit

protocol DetailsViewControllerDelegate: AnyObject {
    func deviceInfoViewController(_ controller: DetailsViewController,
                                  didSaveInfo info: String,
                                  withName name: String)
    func deviceInfoViewController(_ controller: DetailsViewController,
                                  didSaveImage image: UIImage)
}

protocol DetailsPresenterProtocol: AnyObject {
    var router: DetailsRouterProtocol? { get set }
    var interactor: DetailsInteractorProtocol? { get set }
    var view: DetailsViewControllerProtocol? { get set }
    var delegate: DetailsViewControllerDelegate? { get set }
    func passSavedText(info: String, name: String)
    func passSavedPhoto(photo: UIImage)
}

final class DetailsViewPresenter: DetailsPresenterProtocol{
    var router: DetailsRouterProtocol?
    var interactor: DetailsInteractorProtocol?
    weak var view: DetailsViewControllerProtocol?
    weak var delegate: DetailsViewControllerDelegate?
    
    required init(view: DetailsViewControllerProtocol) {
        self.view = view
    }
    
    func passSavedText(info: String, name: String) {
        guard let view = view as? DetailsViewController else { return }
        delegate?.deviceInfoViewController(view, didSaveInfo: info, withName: name)
    }
    
    func passSavedPhoto(photo: UIImage) {
        guard let view = view as? DetailsViewController else { return }
        delegate?.deviceInfoViewController(view, didSaveImage: photo)
    }
}
