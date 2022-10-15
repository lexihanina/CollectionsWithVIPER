//
//  View.swift
//  Collections
//
//  Created by Lexi Hanina on 3/14/22.
//

import Foundation
import UIKit

protocol FirstViewControllerProtocol: AnyObject {
    var presenter: FirstPresenterProtocol? { get set }
    var configurator: FirstViewConfiguratorProtocol { get }
    func update(with devices: [AppleDevices])
    func updateTextWithChanges(withName name: String, info: String)
    func updateImageWithChanges(withImage image: UIImage)
}

final class FirstViewController: UIViewController, FirstViewControllerProtocol {
    var presenter: FirstPresenterProtocol?
    let configurator: FirstViewConfiguratorProtocol = FirstViewConfigurator()
    
    private let tableView = UITableView()
    private var allDevices: [AppleDevices] = []
    private var cellID = "DeviceCell"
    private var deviceInfoVCNib = "DeviceInfoViewController"
    private var index: Int = 0
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
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    func update(with devices: [AppleDevices]) {
        allDevices = devices
    }
    
    func updateTextWithChanges(withName name: String, info: String) {
        allDevices[index].info = info
        allDevices[index].name = name
        tableView.reloadData()
    }
    
    func updateImageWithChanges(withImage image: UIImage) {
        allDevices[index].image = image
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FirstViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allDevices.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? DeviceCell
        else {
            return UITableViewCell()
        }
        
        cell.setDevice(allDevices[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        let device = allDevices[index]
        presenter?.didTapForDetails(device: device)
    }
}
