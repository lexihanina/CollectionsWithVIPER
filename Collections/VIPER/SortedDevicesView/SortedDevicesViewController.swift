//
//  SortedDevicesViewController.swift
//  Collections
//
//  Created by Lexi Hanina on 3/18/22.
//

import Foundation
import UIKit

protocol SortedDevicesViewControllerProtocol: AnyObject {
    var presenter: SortedDevicesPresenterProtocol? { get set }
    var configurator: SortedDevicesViewConfiguratorProtocol { get }
    func update(with pads: [AppleDevices], phones: [AppleDevices])
    func updateTextWithChanges(withName name: String, info: String)
    func updateImageWithChanges(withImage image: UIImage)
}

final class SortedDevicesViewController: UIViewController, SortedDevicesViewControllerProtocol {
    var presenter: SortedDevicesPresenterProtocol?
    let configurator: SortedDevicesViewConfiguratorProtocol = SortedDevicesViewConfigurator()
    
    private let tableView = UITableView()
    private var allDevices = [Expandable]()
    private var allPads: [Expandable] = []
    private var allPhones: [Expandable] = []
    private var cellID = "DeviceCell"
    private var padsSectionID = "PadsSection"
    private var phonesSectionID = "PhonesSection"
    private var index: Int = 0
    private var section: Int = 0
    private var phonesSection: Int = 1
    private var headerView: UIView?
    private var heightForRow: CGFloat = 77
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        configurator.configure(with: self)
        presenter?.configureView()
    }
    
    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellID, bundle: nil),
                                 forCellReuseIdentifier: cellID)
        tableView.register(UINib(nibName: padsSectionID, bundle: nil),
                                 forHeaderFooterViewReuseIdentifier: padsSectionID)
        tableView.register(UINib(nibName: phonesSectionID, bundle: nil),
                                 forHeaderFooterViewReuseIdentifier: phonesSectionID)
    }
    
    func update(with pads: [AppleDevices], phones: [AppleDevices]) {
        allPads = [Expandable(isExpanded: false, devicesArray: pads)]
        allPhones = [Expandable(isExpanded: false, devicesArray: phones)]
        allDevices = allPads + allPhones
    }
    
    func updateTextWithChanges(withName name: String, info: String) {
        allDevices[section].devicesArray[index].info = info
        allDevices[section].devicesArray[index].name = name
        tableView.reloadData()
    }
    
    func updateImageWithChanges(withImage image: UIImage) {
        allDevices[section].devicesArray[index].image = image
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SortedDevicesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let devices = allDevices
        
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allDevices[section].isExpanded {
            return allDevices[section].devicesArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? DeviceCell
        else {
            return UITableViewCell()
        }
        
        cell.setDevice(allDevices[indexPath.section].devicesArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let padsHeaderView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: padsSectionID) as? PadsSection
            padsHeaderView?.delegate = self
            padsHeaderView?.padsSection = section
            headerView = padsHeaderView
        } else if section == 1 {
            let phonesHeaderView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: phonesSectionID) as? PhonesSection
            phonesHeaderView?.delegate = self
            phonesHeaderView?.phonesSection = section
            headerView = phonesHeaderView
        }
        
        let expandableSection = UIButton(frame: headerView!.frame)
        expandableSection.addTarget(self, action: #selector(handleExpand), for: .touchUpInside)
        expandableSection.tag = section
        headerView!.addSubview(expandableSection)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            tableView.beginUpdates()
            let deleteSection = indexPath.section
            let deleteIndex = indexPath.row
            allDevices[deleteSection].devicesArray.remove(at: deleteIndex)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if allDevices[deleteSection].devicesArray.count == 0 {
                allDevices.remove(at: deleteSection)
                tableView.deleteSections(IndexSet(integer: deleteSection), with: .fade)
                
                if deleteSection == 0 {
                    phonesSection = 0
                    (headerView as? PhonesSection)?.phonesSection = 0
                }
            }
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        section = indexPath.section
        let device = allDevices[section].devicesArray[index]
        
        presenter?.didTapForDetails(device: device)
    }
    
    
    @objc func handleExpand(button: UIButton) {
        var section: Int
        
        if button.tag == 1 {
            section = phonesSection
        } else {
            section = button.tag
        }
        
        var indexPaths = [IndexPath]()
        for row in allDevices[section].devicesArray.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = allDevices[section].isExpanded
        allDevices[section].isExpanded = !isExpanded
        
        if !isExpanded {
            tableView.insertRows(at: indexPaths, with: .fade)
        } else {
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
}

// MARK: - AddNewDeviceDelegate
extension SortedDevicesViewController: AddNewDeviceDelegate {
    func saveNewDevice(device: AppleDevices, forSection: Int) {
        allDevices[forSection].devicesArray.append(device)
        tableView.reloadData()
    }
}

// MARK: - PhonesSectionDelegate, PadsSectionDelegate
extension SortedDevicesViewController: PhonesSectionDelegate, PadsSectionDelegate {
    func addPad(_ section: PadsSection, didAddPadToSection sect: Int) {
        presenter?.didTapAdd(toSection: sect)
    }
    
    func addPhone(_ section: PhonesSection, didAddPhoneToSection sect: Int) {
        presenter?.didTapAdd(toSection: sect)
    }
}

