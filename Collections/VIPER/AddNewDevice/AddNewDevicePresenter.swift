//
//  AddNewDevicePresenter.swift
//  Collections
//
//  Created by Lexi Hanina on 3/19/22.
//

import Foundation

protocol AddNewDeviceDelegate: AnyObject {
    func saveNewDevice(device: AppleDevices, forSection: Int)
}

protocol AddNewDevicePresenterProtocol: AnyObject {
    var router: AddNewDeviceRouterProtocol? { get set }
    var interactor: AddNewDeviceInteractorProtocol? { get set }
    var view: AddNewDeviceViewControllerProtocol? { get set }
    var delegate: AddNewDeviceDelegate? { get set }
    func passNew(device: AppleDevices, toSection: Int)
}

final class AddNewDevicePresenter: AddNewDevicePresenterProtocol{
    var router: AddNewDeviceRouterProtocol?
    var interactor: AddNewDeviceInteractorProtocol?
    weak var view: AddNewDeviceViewControllerProtocol?
    weak var delegate: AddNewDeviceDelegate?
    
    required init(view: AddNewDeviceViewControllerProtocol) {
        self.view = view
    }
    
    
    func passNew(device: AppleDevices, toSection: Int) {
        delegate?.saveNewDevice(device: device, forSection: toSection)
        router?.dismissViewController()
    }
}
