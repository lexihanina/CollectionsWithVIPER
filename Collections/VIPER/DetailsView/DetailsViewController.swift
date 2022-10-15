//
//  DetailsViewController.swift
//  Collections
//
//  Created by Lexi Hanina on 3/16/22.
//

import UIKit

protocol DetailsViewControllerProtocol: AnyObject {
    var presenter: DetailsPresenterProtocol? { get set }
    var device: AppleDevices? { get set }
}

final class DetailsViewController: UIViewController, DetailsViewControllerProtocol, UINavigationControllerDelegate {
    @IBOutlet private weak var detailsDeviceImage: UIImageView!
    @IBOutlet private weak var detailsDeviceName: UITextField!
    @IBOutlet private weak var detailsDeviceInfo: UITextView!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topConstraint: NSLayoutConstraint!

    var presenter: DetailsPresenterProtocol?
    var device: AppleDevices?
    weak var delegate: DetailsViewControllerDelegate?
    private var imagePicker = UIImagePickerController()
    private var file: UIImage?
    private var topConstraintWithoutKeyboard: CGFloat = 445
    private var bottomConstraintWithoutKeyboard: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails(device)
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(didTapEdit))
        detailsDeviceInfo.delegate = self
        detailsDeviceName.delegate = self
        imagePicker.delegate = self
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let info = sender.userInfo,
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height,
        let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        else {
            return
        }
        
        detailsDeviceImage.isHidden = true
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
        
        detailsDeviceImage.isHidden = false
        topConstraint.constant = topConstraintWithoutKeyboard
        bottomConstraint.constant = bottomConstraintWithoutKeyboard
        
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
    private func getDetails(_ device: AppleDevices?) {
        detailsDeviceName.text = device?.name ?? ""
        detailsDeviceImage.image = device?.image ?? UIImage(named: "Unknown")
        detailsDeviceInfo.text = device?.info ?? ""
    }
    
    @objc func didTapEdit() {
        detailsDeviceInfo.isEditable = true
        detailsDeviceName.isEnabled = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change photo",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapChangePhoto))
    }
    
    @objc func didTapChangePhoto() {
        let optionMenu = UIAlertController(title: nil,
                                           message: "Add Photo",
                                           preferredStyle: .actionSheet)
        
        let galleryAction = UIAlertAction(title: "Gallery",
                                          style: .default,
                                          handler: {
            (alert: UIAlertAction) -> Void in
            self.addImageOnTapped()
        })
        
        let cameraAction = UIAlertAction(title: "Camera",
                                         style: .default,
                                         handler: {
            (alert: UIAlertAction) -> Void in
            self.openCameraButton()
        })
        
        let cancleAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: {
            (alert: UIAlertAction) -> Void in
            print("Cancel")
        })
        
        optionMenu.addAction(galleryAction)
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(cancleAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
}

// MARK: - UITextViewDelegate, UITextFieldDelegate
extension DetailsViewController: UITextViewDelegate, UITextFieldDelegate {
    func changeNavBarButtom() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(didTapSave))
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        changeNavBarButtom()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        changeNavBarButtom()
    }
    
    @objc func didTapSave() {
        presenter?.passSavedText(info: detailsDeviceInfo.text, name: detailsDeviceName.text ?? "")
        let alert = UIAlertController(title: "Successe",
                                      message: "Changes was saved",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Done",
                                           style: .default))
        present(alert, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEdit))
        detailsDeviceInfo.isEditable = false
        detailsDeviceName.isEnabled = false
    }
}

// MARK: - UIImagePickerControllerDelegate
extension DetailsViewController: UIImagePickerControllerDelegate {
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
            file = image
            detailsDeviceImage.image = image
            imagePicker.dismiss(animated: true, completion: nil);
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save photo",
                                                            style: .plain, target: self,
                                                            action: #selector(didTapSavePhoto))
    }
    
    @objc func didTapSavePhoto() {
        if let photo = file {
            presenter?.passSavedPhoto(photo: photo)
        }
        
        let alert = UIAlertController(title: "Successe",
                                      message: "Changes was saved",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Done",
                                           style: .default))
        present(alert, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(didTapEdit))
    }
}
