//
//  AddNewDeviceViewController.swift
//  Collections
//
//  Created by Lexi Hanina on 3/19/22.
//

import Foundation
import UIKit

protocol AddNewDeviceViewControllerProtocol: AnyObject {
    var presenter: AddNewDevicePresenterProtocol? { get set }
    var section: Int? { get set }
    var delegate: AddNewDeviceDelegate? { get set }
}

final class AddNewDeviceViewController: UIViewController, AddNewDeviceViewControllerProtocol, UINavigationControllerDelegate {
    
    @IBOutlet private weak var deviceImage: UIImageView!
    @IBOutlet private weak var deviceName: UITextField!
    @IBOutlet private weak var deviceInfo: UITextView!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topConstraint: NSLayoutConstraint!
    
    var presenter: AddNewDevicePresenterProtocol?
    var section: Int?
    weak var delegate: AddNewDeviceDelegate?
    private var savedImage = UIImage(named: String(describing: "Unknown"))!
    private var imagePicker = UIImagePickerController()
    private let tapRecognizer = UITapGestureRecognizer()
    private var topConstraintWithoutKeyboard: CGFloat = 445
    private var bottomConstraintWithoutKeyboard: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        deviceImage.isUserInteractionEnabled = true
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        tapRecognizer.addTarget(self, action: #selector(didTapImage))
        deviceImage.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let info = sender.userInfo,
              let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height,
              let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        else {
            return
        }
        
        deviceImage.isHidden = true
        topConstraint.constant = topConstraintWithoutKeyboard - keyboardSize - 20
        bottomConstraint.constant = view.safeAreaLayoutGuide.layoutFrame.size.height - keyboardSize
        
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        guard let info = sender.userInfo,
              let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        else {
            return
        }
        
        deviceImage.isHidden = false
        topConstraint.constant = topConstraintWithoutKeyboard
        bottomConstraint.constant = bottomConstraintWithoutKeyboard
        
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        var newDevice: AppleDevices
        
        if section == 0 {
            newDevice = iPad(name: deviceName.text ?? "", info: deviceInfo.text ?? "", image: savedImage)
        } else {
            newDevice = iPhone(name: deviceName.text ?? "", info: deviceInfo.text ?? "", image: savedImage)
        }
        
        let section = section ?? 0
        
        presenter?.passNew(device: newDevice, toSection: section)
    }
    
    @objc func didTapImage() {
        let optionMenu = UIAlertController(title: nil, message: "Add Photo", preferredStyle: .actionSheet)
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default, handler:{
            (alert: UIAlertAction!) -> Void in
            self.addImageOnTapped()
        })
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler:{
            (alert: UIAlertAction!) -> Void in
            self.openCameraButton()
        })
        
        let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{
            (alert: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        optionMenu.addAction(galleryAction)
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(cancleAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
}

//MARK: - UIImagePickerControllerDelegate
extension AddNewDeviceViewController: UIImagePickerControllerDelegate {
    
    func openCameraButton(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerController.SourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func addImageOnTapped(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            savedImage = image
            deviceImage.image = savedImage
            imagePicker.dismiss(animated: true, completion: nil);
        }
    }
}
