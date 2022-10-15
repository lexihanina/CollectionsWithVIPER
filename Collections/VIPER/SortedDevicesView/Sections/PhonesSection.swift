//
//  PhonesSection.swift
//  Collections
//
//  Created by Lexi Hanina on 23.02.2022.
//

import UIKit

protocol PhonesSectionDelegate: AnyObject {
    func addPhone(_ section: PhonesSection, didAddPhoneToSection sect: Int)
}

class PhonesSection: UITableViewHeaderFooterView {
    
    weak var delegate: PhonesSectionDelegate?
    var phonesSection: Int?
    
    @IBAction func didTapAdd(_ sender: Any) {
        guard let phonesSection = phonesSection else { return }
        delegate?.addPhone(self, didAddPhoneToSection: phonesSection)
    }
}
