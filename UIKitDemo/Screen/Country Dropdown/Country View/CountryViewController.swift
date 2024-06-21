//
//  CountryViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 20/06/24.
//

import UIKit

class CountryViewController: UIViewController {
    
    // Country Outlets
    @IBOutlet weak var countryOutletView: UIView!
    @IBOutlet weak var chooseCountryBtnOutlet: UIButton!
    @IBOutlet weak var selectedCountryNameLbl: UILabel!
    @IBOutlet weak var selectCountryImg: UIImageView!
    @IBOutlet weak var countryTableViewOutlet: UITableView!
    
    // State Outlet
    @IBOutlet weak var stateOutletView: UIView!
    @IBOutlet weak var chooseStateBtnOutlet: UIButton!
    @IBOutlet weak var selectedStateNameLbl: UILabel!
    @IBOutlet weak var selectStateImg: UIImageView!
    @IBOutlet weak var stateTableViewOutlet: UITableView!
    
    // City Outlet
    @IBOutlet weak var cityOutletView: UIView!
    @IBOutlet weak var chooseCityBtnOutlet: UIButton!
    @IBOutlet weak var selectedCityNameLbl: UILabel!
    @IBOutlet weak var selectCityImg: UIImageView!
    @IBOutlet weak var cityTableViewOutlet: UITableView!
    
    // Label for displaying all selected fields
    @IBOutlet weak var allSelectedFieldLbl: UILabel!
    
    // ViewModel instance
    let viewModel = CountryViewModel()
    // Current dropdown type
    var currentDropdownType: DropdownType = .country
    
    // Tap gesture recognizer for dismissing dropdown
    var tapGestureRecognizer: UITapGestureRecognizer?
        
    // Selected values
    var selectedCountry: Country?
    var selectedState: Statess?
    var selectedCity: String?
        
    enum DropdownType {
        case country, state, city
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.vc = self
        initialCall()
    }
    
    func initialCall() {
        chooseCountryBtnOutlet.setTitle("", for: .normal)
        chooseStateBtnOutlet.setTitle("", for: .normal)
        chooseCityBtnOutlet.setTitle("", for: .normal)
        setupBindings()
        hideTableView()
        viewModel.fetchCountries()
        setupTableViewDelegates()
        registerCells()
        setupTapGestureRecognizer()
        updateAllSelectedFieldLabel()
    }
        
    // Action for choosing Country dropdown
    @IBAction func chooseCountryDropdownAction(_ sender: UIButton) {
        print("country btn Action")
        currentDropdownType = .country
        toggleDropdown(for: countryTableViewOutlet)
        stateTableViewOutlet.isHidden = true
        cityTableViewOutlet.isHidden = true
        checkButtonEnableDisable()
        updateAllSelectedFieldLabel()
    }
        
    // Action for choosing State dropdown
    @IBAction func chooseStateDropdownAction(_ sender: UIButton) {
        print("state btn Action")
        currentDropdownType = .state

        if viewModel.states.isEmpty {
            selectedStateNameLbl.text = "No State available"
            selectedCityNameLbl.text = "No City available"
            chooseStateBtnOutlet.isEnabled = false
            chooseCityBtnOutlet.isEnabled = false
            stateTableViewOutlet.isHidden = true
        } else {
            toggleDropdown(for: stateTableViewOutlet)
            countryTableViewOutlet.isHidden = true
            cityTableViewOutlet.isHidden = true
            checkButtonEnableDisable()
        }
            updateAllSelectedFieldLabel()
    }
    
    // Action for choosing City dropdown
    @IBAction func chooseCityDropdownAction(_ sender: UIButton) {
        print("city btn Action")
        currentDropdownType = .city
        if viewModel.cities.isEmpty {
            selectedCityNameLbl.text = "No City available"
            chooseCityBtnOutlet.isEnabled = false
            cityTableViewOutlet.isHidden = true
        } else {
            toggleDropdown(for: cityTableViewOutlet)
            countryTableViewOutlet.isHidden = true
            stateTableViewOutlet.isHidden = true
        }
        updateAllSelectedFieldLabel()
    }
}

// MARK: - Extension for shared instance creation
extension CountryViewController {
    static func sharedIntance() -> CountryViewController {
        return CountryViewController.instantiateFromStoryboard("CountryViewController")
    }
    // MARK: - Helper Function
    
    // Setup bindings to update UI based on ViewModel changes
    func setupBindings() {
        viewModel.$countries
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                if self?.currentDropdownType == .country {
                    self?.countryTableViewOutlet.reloadData()
                }
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$states
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                if self?.currentDropdownType == .state {
                    self?.stateTableViewOutlet.reloadData()
                }
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$cities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                if self?.currentDropdownType == .city {
                    self?.cityTableViewOutlet.reloadData()
                }
            }
            .store(in: &viewModel.cancellables)
    }
    
    // Setup delegates for table views
    func setupTableViewDelegates() {
        countryTableViewOutlet.delegate = self
        countryTableViewOutlet.dataSource = self
        stateTableViewOutlet.delegate = self
        stateTableViewOutlet.dataSource = self
        cityTableViewOutlet.delegate = self
        cityTableViewOutlet.dataSource = self
    }
    
    // Register table view cells
    func registerCells() {
        countryTableViewOutlet.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        stateTableViewOutlet.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        cityTableViewOutlet.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // Hide all dropdowns
    func hideTableView() {
        countryTableViewOutlet.isHidden = true
        stateTableViewOutlet.isHidden = true
        cityTableViewOutlet.isHidden = true
    }
    
    func checkButtonEnableDisable() {
        if selectedCountryNameLbl.text == "" {
            chooseStateBtnOutlet.isEnabled = false
            chooseCityBtnOutlet.isEnabled = false
        }
        if selectedStateNameLbl.text == "" {
            chooseCityBtnOutlet.isEnabled = false
        }
    }
    
    // Update selected values and enable/disable dropdowns
    func updateDropdownSelection() {
        switch currentDropdownType {
        case .country:
            if let country = selectedCountry {
                selectedCountryNameLbl.text = country.name
                selectedStateNameLbl.text = "select state"
                selectedCityNameLbl.text = "select city"
                chooseStateBtnOutlet.isEnabled = true
                stateTableViewOutlet.isHidden = true
                chooseCityBtnOutlet.isEnabled = false
                cityTableViewOutlet.isHidden = true
            } else {
                selectedCountryNameLbl.text = "select Country"
                selectedStateNameLbl.text = "select State"
                selectedCityNameLbl.text = "select City"
                chooseStateBtnOutlet.isEnabled = false
                stateTableViewOutlet.isHidden = true
                chooseCityBtnOutlet.isEnabled = false
                cityTableViewOutlet.isHidden = true
            }
        case .state:
            if viewModel.states.isEmpty  {
                selectedStateNameLbl.text = "No State"
                selectedCityNameLbl.text = "No City"
                chooseStateBtnOutlet.isEnabled = false
                stateTableViewOutlet.isHidden = true
                chooseCityBtnOutlet.isEnabled = false
                cityTableViewOutlet.isHidden = true
            }
            else if let state = selectedState {
                selectedStateNameLbl.text = state.name
                selectedCityNameLbl.text = "select City"
                chooseCityBtnOutlet.isEnabled = true
                cityTableViewOutlet.isHidden = true
            }  else {
                selectedStateNameLbl.text = "select State"
                selectedCityNameLbl.text = "select City"
                chooseCityBtnOutlet.isEnabled = false
                cityTableViewOutlet.isHidden = true
            }
            
        case .city:
            if let city = selectedCity {
                selectedCityNameLbl.text = city
            } else {
                selectedCityNameLbl.text = ""
            }
        }
        updateAllSelectedFieldLabel()
    }
    
    // Update 'allSelectedFieldLbl' based on current selections
    func updateAllSelectedFieldLabel() {
        guard let country = selectedCountry,
              let state = selectedState,
              let city = selectedCity else {
            allSelectedFieldLbl.isHidden = true
            return
        }
        allSelectedFieldLbl.isHidden = false
        allSelectedFieldLbl.text = """
        Country: \(country.name), iso3: \(country.Iso3)
        State: \(state.name), code: \(String(describing: state.stateCode!))
        City: \(city)
        """
    }
    
    func setupTapGestureRecognizer() {
        // Create a UITapGestureRecognizer instance with target and action
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideDropdown(_:)))
        
        // Allow other gestures to be recognized simultaneously
        tapGesture.cancelsTouchesInView = false
        
        // Add the tap gesture recognizer to the main view
        self.view.addGestureRecognizer(tapGesture)
    }

    @objc func handleTapOutsideDropdown(_ sender: UITapGestureRecognizer) {
        // Get the location of the tap gesture in the main view
        let location = sender.location(in: self.view)
        
        // Check if the tap is outside of the country dropdown and button
        if !countryTableViewOutlet.frame.contains(location) &&
           !chooseCountryBtnOutlet.frame.contains(location) {
            // If outside, hide the country dropdown
            countryTableViewOutlet.isHidden = true
        }
        
        // Check if the tap is outside of the state dropdown and button
        if !stateTableViewOutlet.frame.contains(location) &&
           !chooseStateBtnOutlet.frame.contains(location) {
            // If outside, hide the state dropdown
            stateTableViewOutlet.isHidden = true
        }
        
        // Check if the tap is outside of the city dropdown and button
        if !cityTableViewOutlet.frame.contains(location) &&
           !chooseCityBtnOutlet.frame.contains(location) {
            // If outside, hide the city dropdown
            cityTableViewOutlet.isHidden = true
        }
    }

}

// MARK: - Table Delegate and DataSource
extension CountryViewController: UITableViewDelegate, UITableViewDataSource{
    
    // Toggle dropdown visibility for the selected table view
    func toggleDropdown(for tableView: UITableView) {
        tableView.reloadData()
        print("toggle btn Action before -> \(tableView.isHidden)")
        if tableView.isHidden {
            print("toggle btn Action After -> \(tableView.isHidden)")
            // Ensure table view is visible and animate the dropdown
            tableView.isHidden = false
            // Position the table view just below the selected view
            tableView.translatesAutoresizingMaskIntoConstraints = true

            // Adjust table view height based on the dropdown type
            switch self.currentDropdownType {
            case .country:
                tableView.frame.size.height = 500
            case .state:
                tableView.frame.size.height = 400
            case .city:
                tableView.frame.size.height = CGFloat(self.viewModel.cities.count * 44)
            }
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else {
            // Collapse the dropdown if already visible
            UIView.animate(withDuration: 0.3, animations: {
                tableView.frame.size.height = 0
                self.view.layoutIfNeeded()
            }) { _ in
                tableView.isHidden = true
            }
        }
    }
    
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
    
    // Configure cells for the selected dropdown type
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch currentDropdownType {
        case .country:
            cell.textLabel?.text = viewModel.countries[indexPath.row].name
            
        case .state:
            if viewModel.states.isEmpty {
                cell.textLabel?.text = "State not available"
                chooseStateBtnOutlet.isEnabled = false
            } else if indexPath.row < viewModel.states.count {
                cell.textLabel?.text = viewModel.states[indexPath.row].name
            } else {
                cell.textLabel?.text = "State not available"
            }
           
        case .city:
            if indexPath.row < viewModel.cities.count {
                    cell.textLabel?.text = viewModel.cities[indexPath.row]
            } else {
                cell.textLabel?.text = "City not available"
            }
        }
        cell.backgroundColor = .systemGray5
        return cell
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
            selectedCity = viewModel.cities.isEmpty ? "No City" :viewModel.cities[indexPath.row]   
        }
        
        updateDropdownSelection()
        tableView.reloadData()
        // Hide the dropdown after selection
        toggleDropdown(for: tableView)
    }
}
