//
//  AddNewDeviceRouter.swift
//  Collections
//
//  Created by Lexi Hanina on 3/19/22.
//

import Foundation
import UIKit

typealias AddNewDeviceEntryPoint = AddNewDeviceViewControllerProtocol & UIViewController

protocol AddNewDeviceRouterProtocol: AnyObject {
    var addNewDeviceEntryPoint: AddNewDeviceEntryPoint? { get }
    func dismissViewController()
}

final class AddNewDeviceRouter: AddNewDeviceRouterProtocol {
    var addNewDeviceEntryPoint: AddNewDeviceEntryPoint?
    
    init(viewController: AddNewDeviceViewController) {
            self.addNewDeviceEntryPoint = viewController
        }
    
    func dismissViewController() {
        addNewDeviceEntryPoint?.dismiss(animated: true, completion: nil)
    }

}
