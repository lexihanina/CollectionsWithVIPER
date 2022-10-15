//
//  Router.swift
//  Collections
//
//  Created by Lexi Hanina on 3/14/22.
//

import Foundation
import UIKit

typealias EntryPoint = FirstViewControllerProtocol & UIViewController

protocol FirstRouterProtocol: AnyObject {
    var viewController: EntryPoint? { get }
    func openDetailsScreen(forDevice: AppleDevices)
}

final class FirstViewRouter: FirstRouterProtocol {
    var viewController: EntryPoint?
    private let detailsNibName = String(describing: DetailsViewController.self)
    
    init(viewController: FirstViewController) {
            self.viewController = viewController
        }
    
    func openDetailsScreen(forDevice: AppleDevices) {
        let detailsVC = DetailsViewController(nibName: detailsNibName, bundle: nil)
        let configurator = DetailsViewConfigurator()
        configurator.configure(with: detailsVC)
        detailsVC.device = forDevice
//        detailsVC.presenter?.delegate = viewController as? DetailsViewControllerDelegate
        detailsVC.presenter?.delegate = viewController?.presenter as? DetailsViewControllerDelegate
        
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}
