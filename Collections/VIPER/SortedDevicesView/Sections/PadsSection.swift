//
//  PadsSection.swift
//  Collections
//
//  Created by Lexi Hanina on 23.02.2022.
//

import UIKit

protocol PadsSectionDelegate: AnyObject {
    func addPad(_ section: PadsSection, didAddPadToSection sect: Int)
}

class PadsSection: UITableViewHeaderFooterView {
    
    weak var delegate: PadsSectionDelegate?
    var padsSection: Int?
    
    @IBAction func didTapAdd(_ sender: Any) {
        guard let padsSection = padsSection else { return }
        delegate?.addPad(self, didAddPadToSection: padsSection)
    }
}




