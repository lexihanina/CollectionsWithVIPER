//
//  AddNewDeviceInteractor.swift
//  Collections
//
//  Created by Lexi Hanina on 3/19/22.
//

import Foundation

protocol AddNewDeviceInteractorProtocol: AnyObject {
    var presenter: AddNewDevicePresenterProtocol? { get set }
}

final class AddNewDeviceInteractor: AddNewDeviceInteractorProtocol {
    var presenter: AddNewDevicePresenterProtocol?
    
    required init(presenter: AddNewDevicePresenterProtocol) {
            self.presenter = presenter
        }
}
