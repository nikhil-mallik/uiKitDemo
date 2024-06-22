//
//  CountryViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 20/06/24.
//

import UIKit

class CountryViewController: UIViewController {
    
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
    
    // Label for displaying all selected fields
    @IBOutlet weak var allSelectedFieldLbl: UILabel!
    
    let viewModel = CountryViewModel()  // ViewModel instance
    var currentDropdownType: DropdownType = .country // Current dropdown type
    var tapGestureRecognizer: UITapGestureRecognizer? // Tap gesture recognizer for dismissing dropdown
    
    // MARK: - Selected values
    var selectedCountry: Country?
    var selectedState: Statess?
    var selectedCity: String?
    
    // MARK: - DropdownType Enum
    enum DropdownType {
        case country, state, city
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.vc = self
        initialCall()
    }
    
    // MARK: - Initial Setup
    func initialCall() {
        setupButtons()
        setupBindings()
        hideAllTableViews()
        viewModel.fetchCountries()
        setupTableViewDelegates()
        registerCells()
        setupTapGestureRecognizer()
        updateAllSelectedFieldLabel()
        checkButtonEnableDisable()
    }
    
    // MARK: - Setup Button title empty
    func setupButtons() {
        [chooseCountryBtnOutlet, chooseStateBtnOutlet, chooseCityBtnOutlet].forEach {
            $0?.setTitle("", for: .normal)
        }
    }
    
    // MARK: - Actions for Dropdown Buttons
    @IBAction func chooseCountryDropdownAction(_ sender: UIButton) {
        print("country btn Action")
        handleDropdownAction(type: .country, tableView: countryTableViewOutlet)
    }
    
    @IBAction func chooseStateDropdownAction(_ sender: UIButton) {
        print("state btn Action")
        handleDropdownAction(type: .state, tableView: stateTableViewOutlet)
    }
    
    @IBAction func chooseCityDropdownAction(_ sender: UIButton) {
        print("city btn Action")
        handleDropdownAction(type: .city, tableView: cityTableViewOutlet)
    }
}

// MARK: - Extension for shared instance
extension CountryViewController {
    static func sharedIntance() -> CountryViewController {
        return CountryViewController.instantiateFromStoryboard("CountryViewController")
    }
}

// MARK: - Extension for Helper Function
extension CountryViewController {
    
    // Setup bindings to update UI based on ViewModel changes
    func setupBindings() {
        viewModel.$countries.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.reloadTableView(for: .country)
        }.store(in: &viewModel.cancellables)
        
        viewModel.$states.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.reloadTableView(for: .state)
        }.store(in: &viewModel.cancellables)
        
        viewModel.$cities.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.reloadTableView(for: .city)
        }.store(in: &viewModel.cancellables)
    }
    
    // Reloads the appropriate table view based on the dropdown type
    func reloadTableView(for type: DropdownType) {
        switch type {
        case .country:
            countryTableViewOutlet.reloadData()
        case .state:
            stateTableViewOutlet.reloadData()
        case .city:
            cityTableViewOutlet.reloadData()
        }
    }
    
    // Handles the action when a dropdown button is tapped
    func handleDropdownAction(type: DropdownType, tableView: UITableView) {
            currentDropdownType = type
            toggleDropdown(for: tableView)
            hideOtherTableViews(except: tableView)
            checkButtonEnableDisable()
            updateAllSelectedFieldLabel()
    }
    
    // Hides all table views except the one passed as parameter
    func hideOtherTableViews(except tableView: UITableView) {
        [countryTableViewOutlet, stateTableViewOutlet, cityTableViewOutlet].forEach {
            $0.isHidden = $0 != tableView
        }
    }
    
    // Sets up delegates for all table views
    func setupTableViewDelegates() {
        [countryTableViewOutlet, stateTableViewOutlet, cityTableViewOutlet].forEach {
            $0?.delegate = self
            $0?.dataSource = self
        }
    }
    
    // Registers table view cells for all table views
    func registerCells() {
        [countryTableViewOutlet, stateTableViewOutlet, cityTableViewOutlet].forEach {
            $0?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    
    // Hides all dropdown table views
    func hideAllTableViews() {
        [countryTableViewOutlet, stateTableViewOutlet, cityTableViewOutlet].forEach {
            $0?.isHidden = true
        }
    }
    
    // Checks and enables/disables state and city buttons based on selected values
    func checkButtonEnableDisable() {
        chooseStateBtnOutlet.isEnabled = !viewModel.states.isEmpty
        chooseCityBtnOutlet.isEnabled = !viewModel.cities.isEmpty
    }
    
    // Updates the UI labels based on the selected dropdown type
    func updateDropdownSelection() {
        updateSelectedLabels()
        updateAllSelectedFieldLabel()
    }
    
    // Updates individual selected labels (country, state, city)
    func updateSelectedLabels() {
        switch currentDropdownType {
        case .country:
            selectedCountryNameLbl.text = selectedCountry?.name ?? "Select Country"
            selectedStateNameLbl.text = "Select State"
            selectedCityNameLbl.text = "Select City"
            chooseStateBtnOutlet.isEnabled = selectedCountry != nil
            chooseCityBtnOutlet.isEnabled = false
        case .state:
            selectedStateNameLbl.text = selectedState?.name ?? "Select State"
            selectedCityNameLbl.text = "Select City"
            chooseCityBtnOutlet.isEnabled = selectedState != nil
        case .city:
            selectedCityNameLbl.text = selectedCity ?? "Select City"
        }
    }
    
    // Updates the label displaying all selected fields (country, state, city)
    func updateAllSelectedFieldLabel() {
        if let country = selectedCountry, let state = selectedState, let city = selectedCity {
            allSelectedFieldLbl.text = """
                Country: \(country.name)
                State: \(state.name)
                City: \(city)
                
                Country iso3: \(country.Iso3)
                State code: \(state.stateCode ?? "")
                
                Country: \(country.name), State: \(state.name), City: \(city)
                Country iso3: \(country.Iso3), State code: \(state.stateCode ?? "")
                """
            allSelectedFieldLbl.isHidden = false
        } else {
            allSelectedFieldLbl.isHidden = true
        }
    }
    
    // Sets up tap gesture recognizer to handle taps outside dropdowns
    func setupTapGestureRecognizer() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideDropdown(_:)))
        tapGestureRecognizer?.cancelsTouchesInView = false
        if let tapGestureRecognizer = tapGestureRecognizer {
            view.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    // Handles tap events outside dropdowns to dismiss them
    @objc func handleTapOutsideDropdown(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if !isTapInsideView(location: location, views: [countryTableViewOutlet, chooseCountryBtnOutlet]) {
            countryTableViewOutlet.isHidden = true
        }
        if !isTapInsideView(location: location, views: [stateTableViewOutlet, chooseStateBtnOutlet]) {
            stateTableViewOutlet.isHidden = true
        }
        if !isTapInsideView(location: location, views: [cityTableViewOutlet, chooseCityBtnOutlet]) {
            cityTableViewOutlet.isHidden = true
        }
    }
    
    // Checks if the tap location is inside any of the specified views
    func isTapInsideView(location: CGPoint, views: [UIView]) -> Bool {
        return views.contains { $0.frame.contains(location) }
    }
}

// MARK: - Table Delegate
extension CountryViewController: UITableViewDelegate{
    
    // Toggles the visibility of the dropdown for the selected table view
    func toggleDropdown(for tableView: UITableView) {
        tableView.reloadData()
        tableView.isHidden.toggle()
        if !tableView.isHidden {
            adjustTableViewHeight(tableView)
        } else {
            collapseTableView(tableView)
        }
    }
    
    // Adjusts the height of the dropdown table view based on dropdown type
    func adjustTableViewHeight(_ tableView: UITableView) {
        tableView.translatesAutoresizingMaskIntoConstraints = true
        switch self.currentDropdownType {
        case .country:
            tableView.frame.size.height = 650
        case .state:
            let maxHeight = CGFloat(viewModel.states.count * 44)
            let adjustedHeight = min(maxHeight, 500)
            tableView.frame.size.height = adjustedHeight
        case .city:
            let maxHeight = CGFloat(viewModel.cities.count * 44)
            let adjustedHeight = min(maxHeight, 400)
            tableView.frame.size.height = adjustedHeight
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // Collapses the dropdown table view
    func collapseTableView(_ tableView: UITableView) {
        UIView.animate(withDuration: 0.3, animations: {
            tableView.frame.size.height = 0
            self.view.layoutIfNeeded()
        }) { _ in
            tableView.isHidden = true
        }
    }
    
    // Handle selection of a row in the dropdown
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch currentDropdownType {
        case .country:
            selectedCountry = viewModel.countries[indexPath.row]
            selectedState = nil
            selectedCity = nil
            viewModel.fetchStates(for: selectedCountry!.name)
        case .state:
            selectedState = viewModel.states.isEmpty ? nil : viewModel.states[indexPath.row]
            selectedCity = nil
            if let country = selectedCountry {
                viewModel.fetchCities(for: country.name, state: selectedState?.name ?? "")
            }
        case .city:
            guard indexPath.row < viewModel.cities.count else { return  }
            selectedCity = viewModel.cities[indexPath.row]
        }
        updateDropdownSelection()
        tableView.reloadData()
        toggleDropdown(for: tableView)
    }
}

// MARK: - Table View Data Source
extension CountryViewController: UITableViewDataSource{
    
    // Number of rows in section for the selected dropdown type
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentDropdownType {
        case .country:
            return viewModel.countries.count
        case .state:
            return viewModel.states.isEmpty ? 0 :viewModel.states.count
        case .city:
            print("city count -> \(viewModel.cities.count)")
            return viewModel.cities.isEmpty ? 0 : viewModel.cities.count
        }
    }
    
    // Configures and returns a table view cell for the selected dropdown type
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch currentDropdownType {
        case .country:
            guard indexPath.row < viewModel.countries.count else { return cell }
            cell.textLabel?.text = viewModel.countries[indexPath.row].name
        case .state:
            guard indexPath.row < viewModel.states.count else { return cell }
            cell.textLabel?.text = viewModel.states.isEmpty ? "State not available" : viewModel.states[indexPath.row].name
        case .city:
            guard indexPath.row < viewModel.cities.count else { return cell }
            cell.textLabel?.text = viewModel.cities.isEmpty ? "City not available" : viewModel.cities[indexPath.row]
        }
        cell.backgroundColor = .systemGray5
        return cell
    }
}
