//
//  SortedDevicesRouter.swift
//  Collections
//
//  Created by Lexi Hanina on 3/18/22.
//

import Foundation
import UIKit

typealias SortedDevicesEntryPoint = SortedDevicesViewControllerProtocol & UIViewController

protocol SortedDevicesRouterProtocol: AnyObject {
    var sortedDevicesViewController: SortedDevicesEntryPoint? { get }
    func openDetailsScreen(forDevice: AppleDevices)
    func openAddNewDevice(toSection: Int)
}

final class SortedDevicesViewRouter: SortedDevicesRouterProtocol {
    var sortedDevicesViewController: SortedDevicesEntryPoint?
    private let detailsNibName = String(describing: DetailsViewController.self)
    private let addNewDeviceNibName = String(describing: AddNewDeviceViewController.self)
    
    init(viewController: SortedDevicesViewController) {
            self.sortedDevicesViewController = viewController
        }
    
    func openDetailsScreen(forDevice: AppleDevices) {
        let detailsVC = DetailsViewController(nibName: detailsNibName, bundle: nil)
        let configurator = DetailsViewConfigurator()
        configurator.configure(with: detailsVC)
        detailsVC.device = forDevice
        detailsVC.presenter?.delegate = sortedDevicesViewController?.presenter as? DetailsViewControllerDelegate
        
        sortedDevicesViewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func openAddNewDevice(toSection: Int) {
        let addNewDeviceVC = AddNewDeviceViewController(nibName: addNewDeviceNibName, bundle: nil)
        let configurator = AddNewDeviceViewConfigurator()
        configurator.configure(with: addNewDeviceVC)
    
        addNewDeviceVC.presenter?.delegate = sortedDevicesViewController as? AddNewDeviceDelegate
        addNewDeviceVC.section = toSection
        
        sortedDevicesViewController?.present(addNewDeviceVC, animated: true, completion: nil)
    }
}
