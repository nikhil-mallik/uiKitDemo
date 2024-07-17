//
//  ImagePickerHelper.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 25/06/24.
//

import UIKit

class ImagePickerHelper: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var imagePicker: UIImagePickerController?
    private var viewController: UIViewController?
    var completionHandler: ((UIImage?) -> Void)?
    
    var isImagePickerPresented: Bool {
        return imagePicker != nil && imagePicker?.presentingViewController != nil
    }
    func presentImagePicker(in viewController: UIViewController, completion: @escaping (UIImage?) -> Void) {
        self.viewController = viewController
        self.completionHandler = completion
        
        let actionSheet = UIAlertController(title: "Select Image", message: nil, preferredStyle: .alert)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.checkCameraSupport()
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { [weak self] _ in
            self?.presentImagePicker(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cancelAction)
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = viewController.view.bounds
        }
        
        viewController.present(actionSheet, animated: true, completion: nil)
    }
    
    // Method to check if camera is supported and present it
    private func checkCameraSupport() {
        guard let viewController = viewController else { return }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            presentImagePicker(sourceType: .camera)
        } else {
            let alert = UIAlertController(title: "Camera Not Available", message: "This device does not support camera.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard let viewController = viewController else {
            return
        }
        
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.sourceType = sourceType
        
        viewController.present(imagePicker!, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        completionHandler?(selectedImage)
        
        completionHandler = nil
        imagePicker?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        completionHandler?(nil)
        
        completionHandler = nil
        imagePicker?.dismiss(animated: true, completion: nil)
    }
}

class FileManagerHelper {
    // get the imageURL
    static func getImageURL(for imageName: String?) -> URL? {
        guard let imageName = imageName else { return nil }
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(imageName).appendingPathExtension("png")
    }
}
