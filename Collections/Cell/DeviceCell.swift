//
//  DeviceCell.swift
//  Collections
//
//  Created by Lexi Hanina on 23.02.2022.
//

import UIKit

class DeviceCell: UITableViewCell {

    @IBOutlet private weak var deviceImage: UIImageView!
    @IBOutlet private weak var deviceName: UILabel!
    @IBOutlet private weak var deviceDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDevice(_ device: AppleDevices) {
        deviceName.text = device.name
        deviceDescription.text = device.info
        deviceImage.image = device.image
    }
}
