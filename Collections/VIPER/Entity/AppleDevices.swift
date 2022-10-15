//
//  AppleDevices.swift
//  Collections
//
//  Created by Lexi Hanina on 23.02.2022.
//

import Foundation
import UIKit

protocol AppleDevices {
    var name: String { get set }
    var info: String { get set }
    var image: UIImage { get set }
}

struct iPhone: AppleDevices {
    var name: String
    var info: String
    var image: UIImage
}

struct iPad: AppleDevices {
    var name: String
    var info: String
    var image: UIImage
}

struct DeviceManager {
    static var alliPhones: [AppleDevices] = Device.allPhones.map { Device in
        let phone = iPhone(name: Device.description,
                           info: "PPI: \(Device.ppi ?? 0), diagonal: \(Device.diagonal)",
                           image: (UIImage(named: Device.rawValue.lowercased()) ?? UIImage(named: "Unknown"))!)
        return phone
    }
    
    static var alliPads: [AppleDevices] = Device.allPads.map { Device in
        let pad = iPhone(name: Device.description,
                           info: "PPI: \(Device.ppi ?? 0), diagonal: \(Device.diagonal)",
                           image: (UIImage(named: Device.rawValue.lowercased()) ?? UIImage(named: "Unknown"))!)
        return pad
    }
}

struct Expandable {
    var isExpanded: Bool
    var devicesArray: [AppleDevices]
}
