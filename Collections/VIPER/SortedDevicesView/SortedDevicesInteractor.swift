//
//  SortedDevicesInteractor.swift
//  Collections
//
//  Created by Lexi Hanina on 3/18/22.
//

import Foundation

protocol SortedDevicesInteractorProtocol: AnyObject {
    var presenter: SortedDevicesPresenterProtocol? { get set }
    func getAllPads() -> [AppleDevices]
    func getAllPhones() -> [AppleDevices]
}

final class SortedDevicesViewInteractor: SortedDevicesInteractorProtocol {
    var presenter: SortedDevicesPresenterProtocol?
    
    required init(presenter: SortedDevicesPresenterProtocol) {
            self.presenter = presenter
        }
    
    func getAllPads() -> [AppleDevices] {
        return DeviceManager.alliPads
    }
    
    func getAllPhones() -> [AppleDevices] {
        return DeviceManager.alliPhones
    }
}
