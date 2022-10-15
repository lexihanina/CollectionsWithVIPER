//
//  Interactor.swift
//  Collections
//
//  Created by Lexi Hanina on 3/14/22.
//

import Foundation

protocol FirstInteractorProtocol: AnyObject {
    var presenter: FirstPresenterProtocol? { get set }
    func getAllDevices() -> [AppleDevices]
}

final class FirstViewInteractor: FirstInteractorProtocol {
    var presenter: FirstPresenterProtocol?
    
    required init(presenter: FirstPresenterProtocol) {
            self.presenter = presenter
        }
    
    func getAllDevices() -> [AppleDevices] {
        return DeviceManager.alliPads + DeviceManager.alliPhones
    }
    
    
}
