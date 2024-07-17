//
//  AddEditCoreDataViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 16/07/24.
//

import UIKit

class AddEditCoreDataViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uploadImageBtn: UIButton!
    @IBOutlet weak var fnameTxtFd: UITextField!
    @IBOutlet weak var LnameTxtFd: UITextField!
    @IBOutlet weak var emailTxtFd: UITextField!
    @IBOutlet weak var bioTxtFd: UITextView!
    @IBOutlet weak var mobileNumberTxtFd: UITextField!
    @IBOutlet weak var dobPicker: UIDatePicker!
    @IBOutlet weak var saveBtnOutlet: UIButton!
    
    // MARK: - Variable
    var imagePickerHelper: ImagePickerHelper?
    private let manager =  DatabaseManager()
    private var imageSelectedByUser: Bool = false
    var user: UserEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialCall()
    }
    // MARK: - Initial Setup
    func initialCall() {
        setupButtonTitle()
        setupProfileImage()
        setupTextViews()
        userDetailConfiguration()
    }
    
    // MARK: - Actions
    @IBAction func uploadImageAction(_ sender: UIButton) {
        imagePickerHelper = ImagePickerHelper()
        imagePickerHelper?.presentImagePicker(in: self) { [weak self] selectedImage in
            if let image = selectedImage {
                self?.imageView.image = selectedImage
                self?.imageSelectedByUser = true
            }
        }
    }
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        saveProfile()
    }
}

// MARK: - Extension for Helper Method
extension AddEditCoreDataViewController {
    // Configures the view with user details if available.
    func userDetailConfiguration() {
        if let user {
            saveBtnOutlet.setTitle("Update", for: .normal)
            navigationItem.title = "Update User"
            fnameTxtFd.text = user.firstName
            LnameTxtFd.text = user.lastName
            emailTxtFd.text = user.email
            bioTxtFd.text = user.bioData
            mobileNumberTxtFd.text = "\(user.mobileNumber)"
            dobPicker.date = user.dob!
            
            if let imageURL = FileManagerHelper.getImageURL(for: user.userImage) {
                imageView.image = UIImage(contentsOfFile: imageURL.path)
            }
            
            imageSelectedByUser = true
        }else {
            navigationItem.title = "Add User"
            saveBtnOutlet.setTitle("Save", for: .normal)
        }
    }
    
    // Validates and saves the user profile.
    func saveProfile() {
        guard let firstName = fnameTxtFd.text, !firstName.isEmpty else {
            showAlert(message: "Please enter your first name")
            return
        }
        guard let lastName = LnameTxtFd.text, !lastName.isEmpty else {
            showAlert(message: "Please enter your last name")
            return
        }
        guard let email = emailTxtFd.text, !email.isEmpty else {
            showAlert(message: "Please enter your email address")
            return
        }
        guard let bioData = bioTxtFd.text, !bioData.isEmpty else {
            showAlert(message: "Please enter your bio data")
            return
        }
        guard let number = mobileNumberTxtFd.text, !number.isEmpty else {
            showAlert(message: "Please enter your mobile number")
            return
        }
        
        if !imageSelectedByUser {
            showAlert(message: "Please choose your profile image.")
            return
        }
        let dob = dobPicker.date
        if let user {
            let newUser = UserDataModel(
                userId: user.userId!,
                userImage: user.userImage!,
                firstName: firstName,
                lastName: lastName,
                email: email,
                bioData: bioData,
                mobileNumber: Int(number)!,
                dob: dob
            )
            
            manager.updateUser(user: newUser, userEntity: user)
            saveImageToDocumentDirectory(imageName: newUser.userImage)
        }else {
            let id = UUID().uuidString
            let imageName = id
            let newUser = UserDataModel(
                userId: id,
                userImage: imageName,
                firstName: firstName,
                lastName: lastName,
                email: email,
                bioData: bioData,
                mobileNumber: Int(number)!,
                dob: dob
            )
            saveImageToDocumentDirectory(imageName: imageName)
            manager.addUser(newUser)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // Saves the selected image to the document directory.
    func saveImageToDocumentDirectory(imageName: String) {
        guard let imageURL = FileManagerHelper.getImageURL(for: imageName) else {
            print("Invalid image name.")
            return
        }
        
        if let data = imageView.image?.pngData() {
            do {
                try data.write(to: imageURL) // Save
            } catch {
                print("Saving image to Document Directory error:", error)
            }
        }
    }
    
    // Displays an alert with a given message.
    private func showAlert(message: String) {
        AlertHelper.showAlert(withTitle: "Alert", message: message, from: self)
    }
    
    // MARK: - UI Setup
    func setupTextViews() {
        // Set border for descTxtFd
        bioTxtFd.layer.borderWidth = 1.0
        bioTxtFd.layer.borderColor = UIColor.systemGray3.cgColor
        bioTxtFd.layer.cornerRadius = 5.0
    }
    
    // Configures the bio text view.
    func setupButtonTitle() {
        uploadImageBtn.setTitle("", for: .normal)
        uploadImageBtn.layer.cornerRadius = uploadImageBtn.frame.size.width / 2
    }
    
    // Configures the profile image view.
    func setupProfileImage() {
        // Make profile image circular
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 3.0
        imageView.backgroundColor = UIColor.lightGray
    }
}

// MARK: - Extension for shared instance
extension AddEditCoreDataViewController {
    static func sharedInstance() -> AddEditCoreDataViewController {
        return AddEditCoreDataViewController.instantiateFromStoryboard("AddEditCoreDataViewController")
    }
}
