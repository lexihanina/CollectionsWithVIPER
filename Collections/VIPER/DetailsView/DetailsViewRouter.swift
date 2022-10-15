//
//  DetailsViewRouter.swift
//  Collections
//
//  Created by Lexi Hanina on 3/16/22.
//

import Foundation
import UIKit

typealias DetailsEntryPoint = DetailsViewControllerProtocol & UIViewController

protocol DetailsRouterProtocol: AnyObject {
    var detailsViewController: DetailsEntryPoint? { get }
}

final class DetailsViewRouter: DetailsRouterProtocol {
    var detailsViewController: DetailsEntryPoint?
    
    init(viewController: DetailsViewController) {
            self.detailsViewController = viewController
        }
}
