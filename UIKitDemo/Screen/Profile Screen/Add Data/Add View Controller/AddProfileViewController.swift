//
//  AddProfileViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 01/07/24.
//

import UIKit

class AddProfileViewController: UIViewController {
    // MARK: - Image Outlet
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var coverImageChangeBtn: UIButton!
    @IBOutlet weak var profileImageChangeBtn: UIButton!
    // MARK: - Profile Fields
    @IBOutlet weak var firstNameTxtFd: UITextField!
    @IBOutlet weak var lastNameTxtFd: UITextField!
    @IBOutlet weak var emailTxtFd: UITextField!
    @IBOutlet weak var mobileTxtFd: UITextField!
    // MARK: - Text View
    @IBOutlet weak var addressTxtFd: UITextView!
    @IBOutlet weak var descTxtFd: UITextView!
    // MARK: - Date picker and UIButton
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var submitButton: UIButton!
    // MARK: - Country Outlets
    @IBOutlet weak var countryOutletView: UIView!
    @IBOutlet weak var chooseCountryBtnOutlet: UIButton!
    @IBOutlet weak var selectedCountryNameLbl: UILabel!
    @IBOutlet weak var selectCountryImg: UIImageView!
    @IBOutlet weak var countryTableViewOutlet: UITableView!
    // MARK: - State Outlet
    @IBOutlet weak var stateOutletView: UIView!
    @IBOutlet weak var chooseStateBtnOutlet: UIButton!
    @IBOutlet weak var selectedStateNameLbl: UILabel!
    @IBOutlet weak var selectStateImg: UIImageView!
    @IBOutlet weak var stateTableViewOutlet: UITableView!
    // MARK: - City Outlet
    @IBOutlet weak var cityOutletView: UIView!
    @IBOutlet weak var chooseCityBtnOutlet: UIButton!
    @IBOutlet weak var selectedCityNameLbl: UILabel!
    @IBOutlet weak var selectCityImg: UIImageView!
    @IBOutlet weak var cityTableViewOutlet: UITableView!
    // MARK: - SearchBars Outlets
    @IBOutlet weak var countrySearchBar: UISearchBar!
    @IBOutlet weak var stateSearchBar: UISearchBar!
    @IBOutlet weak var citySearchBar: UISearchBar!
    
    let viewModel = ProfileAddViewModel.shared
    var currentDropdownType: DropdownType = .country
    var tapGestureRecognizer: UITapGestureRecognizer?
    // MARK: - Selected values
    var selectedCountry: Country?
    var selectedState: Statess?
    var selectedCity: String?
    var imagePickerHelper: ImagePickerHelper?
    var coverPickedImage: UIImage?
    var profilePickedImage: UIImage?
    var profileInfo : ProfileModel?
    var isProfileEditing: Bool = false
    var profileId: Int = 0
    
    // MARK: - DropdownType Enum
    enum DropdownType {
        case country, state, city
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Profile"
        viewModel.vc = self
        setupSearchBars()
        initialCall()
    }
    
    // MARK: - Initial Setup
    func initialCall() {
        setupButtonTitle()
        setupProfileImage()
        setupTextViews()
        checkForEditing()
        callForEditing()
    }
    
    // MARK: - Editing Initial Setup
    func callForEditing() {
        setupBindings()
        setupButtons()
        hideAllTableViews()
        viewModel.fetchCountries()
        setupTableViewDelegates()
        registerCells()
        setupTapGestureRecognizer()
        checkButtonEnableDisable()
    }
    
    // MARK: - Action
    @IBAction func coverImageChangeAction(_ sender: Any) {
        imagePickerHelper = ImagePickerHelper()
        imagePickerHelper?.presentImagePicker(in: self) { [weak self] selectedImage in
            if let image = selectedImage {
                self?.coverPickedImage = image
                self?.coverImage.image = selectedImage
            }
        }
    }
    
    @IBAction func profileImageChangeAction(_ sender: Any) {
        imagePickerHelper = ImagePickerHelper()
        imagePickerHelper?.presentImagePicker(in: self) { [weak self] selectedImage in
            if let image = selectedImage {
                self?.profilePickedImage = image
                self?.profileImage.image = selectedImage
            }
        }
    }
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        saveProfile()
    }
    
    // MARK: - Actions for Dropdown Buttons
    @IBAction func chooseCountryDropdownAction(_ sender: UIButton) {
        handleDropdownAction(type: .country, tableView: countryTableViewOutlet)
    }
    
    @IBAction func chooseStateDropdownAction(_ sender: UIButton) {
        handleDropdownAction(type: .state, tableView: stateTableViewOutlet)
    }
    
    @IBAction func chooseCityDropdownAction(_ sender: UIButton) {
        handleDropdownAction(type: .city, tableView: cityTableViewOutlet)
    }
}

// MARK: - Extension for shared instance
extension AddProfileViewController {
    static func sharedIntance() -> AddProfileViewController {
        return AddProfileViewController.instantiateFromStoryboard("AddProfileViewController")
    }
}

// MARK: - Extension for Helper Method
extension AddProfileViewController {
    // MARK: - Setup Button title empty
    func setupButtons() {
        [chooseCountryBtnOutlet, chooseStateBtnOutlet, chooseCityBtnOutlet].forEach {
            $0?.setTitle("", for: .normal)
        }
    }
    
    func setupTextViews() {
        addressTxtFd.isScrollEnabled = false
        // Set border for addressTxtFd
        addressTxtFd.layer.borderWidth = 1.0
        addressTxtFd.layer.borderColor = UIColor.systemGray3.cgColor
        addressTxtFd.layer.cornerRadius = 5.0
        // Set border for descTxtFd
        descTxtFd.layer.borderWidth = 1.0
        descTxtFd.layer.borderColor = UIColor.systemGray3.cgColor
        descTxtFd.layer.cornerRadius = 5.0
    }
    
    func setupButtonTitle() {
        coverImageChangeBtn.setTitle("", for: .normal)
        profileImageChangeBtn.setTitle("", for: .normal)
        profileImageChangeBtn.layer.cornerRadius = profileImageChangeBtn.frame.size.width / 2
    }
    
    func setupProfileImage() {
        // Make profile image circular
        coverImage.layer.borderColor = UIColor.black.cgColor
        coverImage.layer.borderWidth = 1.0
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.borderWidth = 3.0
        profileImage.backgroundColor = UIColor.lightGray
    }
    
    func checkForEditing() {
        if isProfileEditing == true {
            prefillData()
            callForEditing()
        } else {
            clearProfileFields()
        }
    }
    
    func prefillData() {
        guard let profile = profileInfo else { return }
        selectedCountry = profile.countryName
        selectedState = profile.stateName
        selectedCity = profile.cityName
        coverImage.image = profile.coverImages
        profileImage.image = profile.profileImages
        firstNameTxtFd.text = profile.firstNames
        lastNameTxtFd.text = profile.lastNames
        emailTxtFd.text = profile.email
        mobileTxtFd.text = profile.mobileNumbers
        descTxtFd.text = profile.bioData
        datepicker.date = profile.dob
        addressTxtFd.text = profile.address
        selectedCountryNameLbl.text = profile.countryName.name
        selectedStateNameLbl.text = profile.stateName.name
        selectedCityNameLbl.text = profile.cityName
        viewModel.fetchStates(for: profile.countryName.name)
        viewModel.fetchCities(for: profile.countryName.name, state: profile.stateName.name)
        updateDropdownSelection()
    }
    
    func saveProfile() {
        if isProfileEditing {
            updateProfile()
        } else {
            createNewProfile()
            //            fakeData()
        }
    }
    
    func navigateToFetchScreen() {
        navigationController?.popViewController(animated: true)
        clearProfileFields()
    }
    
    func navigateToFetchScreenAfterEditing() {
        navigationController?.popViewController(animated: true)
        if let fetchProfileVC = navigationController?.viewControllers.last as? FetchProfileTableViewController {
            fetchProfileVC.updateProfileData()
        }
        clearProfileFields()
    }
    
    func updateProfile() {
        guard let profileImage = profileImage.image,
              let coverImage = coverImage.image,
              let firstName = firstNameTxtFd.text, !firstName.isEmpty,
              let lastName = lastNameTxtFd.text, !lastName.isEmpty,
              let email = emailTxtFd.text, !email.isEmpty,
              let mobileText = mobileTxtFd.text, !mobileText.isEmpty,
              let address = addressTxtFd.text, !address.isEmpty,
              let bioData = descTxtFd.text, !bioData.isEmpty
        else {
            AlertHelper.showAlert(withTitle: "Alert", message: "All fields are required", from: self)
            return
        }
        let profile = ProfileModel(id: profileId,
                                   profileImages: profileImage,
                                   coverImages: coverImage,
                                   firstNames: firstName,
                                   lastNames: lastName,
                                   email: email,
                                   mobileNumbers: mobileText,
                                   address: address,
                                   bioData: bioData,
                                   countryName: selectedCountry!,
                                   stateName: selectedState!,
                                   cityName: selectedCity!,
                                   dob: datepicker.date)
        
        if let index = viewModel.userData.firstIndex(where: { $0.id == profile.id }) {
            viewModel.userData[index] = profile
        }
        navigateToFetchScreenAfterEditing()
    }
    
    func createNewProfile() {
        guard let profileImage = profileImage.image,
              let coverImage = coverImage.image,
              let firstName = firstNameTxtFd.text, !firstName.isEmpty,
              let lastName = lastNameTxtFd.text, !lastName.isEmpty,
              let email = emailTxtFd.text, !email.isEmpty,
              let mobileText = mobileTxtFd.text, !mobileText.isEmpty,
              let address = addressTxtFd.text, !address.isEmpty,
              let bioData = descTxtFd.text, !bioData.isEmpty,
              let countryName = selectedCountry,
              let stateName = selectedState,
              let cityName = selectedCity else {
            AlertHelper.showAlert(withTitle: "Alert", message: "All fields are required", from: self)
            return
        }
        
        let dob = datepicker.date
        let newProfileID = (viewModel.userData.last?.id ?? 0) + 1
        let profile = ProfileModel(
            id: newProfileID,
            profileImages: profileImage,
            coverImages: coverImage,
            firstNames: firstName,
            lastNames: lastName,
            email: email,
            mobileNumbers: mobileText,
            address: address,
            bioData: bioData,
            countryName: countryName,
            stateName: stateName,
            cityName: cityName,
            dob: dob
        )
        profileInfo = profile
        viewModel.userData.append(profile)
        viewModel.userData.sort { $0.id < $1.id }
        navigateToFetchScreen()
    }
    
    func clearProfileFields() {
        // Clear images
        profileImage.image = nil
        coverImage.image = nil
        // Clear text fields
        firstNameTxtFd.text = ""
        lastNameTxtFd.text = ""
        emailTxtFd.text = ""
        mobileTxtFd.text = ""
        addressTxtFd.text = ""
        descTxtFd.text = ""
        // Clear selected country, state, and city
        selectedCountry = nil
        selectedState = nil
        selectedCity = nil
        // Reset the date picker to the current date
        datepicker.date = Date()
        selectedCountryNameLbl.text = "Select Country"
        selectedStateNameLbl.text = "Select State"
        selectedCityNameLbl.text = "Select City"
        
        print("All fields cleared")
    }
}

// MARK: - Fake Data
extension AddProfileViewController {
    func fakeData() {
        let dob = datepicker.date
        let newProfileID = (viewModel.userData.last?.id ?? 0) + 1 // Assign a unique ID
        let profile = ProfileModel(
            id: newProfileID,
            profileImages: UIImage(named: "login")!,
            coverImages: UIImage(named: "login")!,
            firstNames: "Lorem ipsum dolor sit",
            lastNames: "Lorem ipsum dolor",
            email: "nikhilmallik@test@test@test@",
            mobileNumbers: "12345678901234567890",
            address: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu,Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.",
            bioData: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda. Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu,Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.",
            countryName: Country(name: "Afghanistan", Iso2: "AF", Iso3: "AFG"),
            stateName: Statess(name: "Badakhshan", stateCode: Optional("BDS")),
            cityName: "Ashkāsham",
            dob: dob
        )
        profileInfo = profile
        viewModel.userData.append(profile)
        if isProfileEditing == false {
            navigateToFetchScreen()
        } else {
            navigateToFetchScreenAfterEditing()
        }
    }
}
