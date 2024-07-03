//
//  AddProfileView + Extensions.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 28/06/24.
//

import UIKit

extension AddProfileViewController: UISearchBarDelegate {
    // Setup Search Bars
    func setupSearchBars() {
        countrySearchBar.delegate = self
        stateSearchBar.delegate = self
        citySearchBar.delegate = self
        
        // Setting the search bars as the table header views
        countryTableViewOutlet.tableHeaderView = countrySearchBar
        stateTableViewOutlet.tableHeaderView = stateSearchBar
        cityTableViewOutlet.tableHeaderView = citySearchBar
    }
    
    // Search Bar Text Did Change
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch currentDropdownType {
        case .country:
            viewModel.searchCountries(with: searchText)
        case .state:
            viewModel.searchStates(with: searchText)
        case .city:
            viewModel.searchCities(with: searchText)
        }
    }
    
    // Clear All Search ar
    func clearAllSearchBars() {
        countrySearchBar.text = ""
        stateSearchBar.text = ""
        citySearchBar.text = ""
    }
}

// MARK: - Extension for Helper Function
extension AddProfileViewController {
    
    // Setup bindings to update UI based on ViewModel changes
    func setupBindings() {
        viewModel.$filteredCountries.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.reloadTableView(for: .country)
        }.store(in: &viewModel.cancellables)
        
        viewModel.$filteredStates.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.reloadTableView(for: .state)
        }.store(in: &viewModel.cancellables)
        
        viewModel.$filteredCities.receive(on: DispatchQueue.main).sink { [weak self] _ in
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
    
    func updateDropdownSelection() {
        selectedCountryNameLbl.text = selectedCountry?.name ?? "Country"
        selectedStateNameLbl.text = selectedState?.name ?? " State"
        selectedCityNameLbl.text = selectedCity ?? "City"
    }
}

// MARK: - UIGestureRecognizerDelegate
extension AddProfileViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Ignore touches on the table views to avoid interfering with cell selection
        if let view = touch.view, view.isDescendant(of: countryTableViewOutlet) || view.isDescendant(of: stateTableViewOutlet) || view.isDescendant(of: cityTableViewOutlet) {
            return false
        }
        return true
    }
    
    func setupTapGestureRecognizer() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideDropdown(_:)))
        tapGestureRecognizer?.cancelsTouchesInView = false
        tapGestureRecognizer?.delegate = self  // Set the delegate
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
extension AddProfileViewController: UITableViewDelegate {
    
    func toggleDropdown(for tableView: UITableView) {
        tableView.reloadData()
        tableView.isHidden.toggle()
        if !tableView.isHidden {
            adjustTableViewHeight(tableView)
        } else {
            collapseTableView(tableView)
        }
        print("table => \(tableView.isHidden)")
    }
    
    func adjustTableViewHeight(_ tableView: UITableView) {
        tableView.translatesAutoresizingMaskIntoConstraints = true
        switch self.currentDropdownType {
        case .country:
            let maxHeight = CGFloat(viewModel.filteredCountries.count * 44)
            let adjustedHeight = min(maxHeight, 450)
            tableView.frame.size.height = adjustedHeight
        case .state:
            let maxHeight = CGFloat(viewModel.filteredStates.count * 44)
            let adjustedHeight = min(maxHeight, 350)
            tableView.frame.size.height = adjustedHeight
        case .city:
            let maxHeight = CGFloat(viewModel.filteredCities.count * 44) + 60
            let adjustedHeight = min(maxHeight, 250)
            print(adjustedHeight)
            tableView.frame.size.height = adjustedHeight
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func collapseTableView(_ tableView: UITableView) {
        UIView.animate(withDuration: 0.3, animations: {
            tableView.frame.size.height = 0
            self.view.layoutIfNeeded()
        }) { _ in
            tableView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch currentDropdownType {
        case .country:
            guard indexPath.row < viewModel.filteredCountries.count else { return }
            selectedCountry = viewModel.filteredCountries[indexPath.row]
            print(" selectedCountry => \(String(describing: selectedCountry))")
            selectedState = nil
            selectedCity = nil
            viewModel.clearCities()
            
            viewModel.fetchStates(for: selectedCountry!.name, button: chooseStateBtnOutlet)
        case .state:
            guard indexPath.row < viewModel.filteredStates.count else { return }
            selectedState = viewModel.filteredStates[indexPath.row]
            selectedCity = nil
            if let country = selectedCountry {
                viewModel.fetchCities(for: country.name, state: selectedState?.name ?? "", button: chooseCityBtnOutlet)
            }
        case .city:
            guard indexPath.row < viewModel.filteredCities.count else { return }
            selectedCity = viewModel.filteredCities[indexPath.row]
            viewModel.resetArrayData(for: .country)
        }
        updateSelectedLabels()
        tableView.reloadData()
        clearAllSearchBars()
        if !tableView.isHidden {
            toggleDropdown(for: tableView)
        }
    }
}

// MARK: - Table View Data Source
extension AddProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentDropdownType {
        case .country:
            return max(viewModel.filteredCountries.count, 1)
        case .state:
            return max(viewModel.filteredStates.count, 1)
        case .city:
            print("city count -> \(viewModel.filteredCities.count)")
            return max(viewModel.filteredCities.count, 1)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch currentDropdownType {
        case .country:
            if indexPath.row < viewModel.filteredCountries.count {
                cell.textLabel?.text = viewModel.filteredCountries[indexPath.row].name
            } else {
                cell.textLabel?.text = "Country not available"
            }
            
        case .state:
            if indexPath.row < viewModel.filteredStates.count {
                cell.textLabel?.text = viewModel.filteredStates[indexPath.row].name
            } else {
                cell.textLabel?.text =  "State not available"
            }
        case .city:
            if indexPath.row < viewModel.filteredCities.count {
                cell.textLabel?.text = viewModel.filteredCities[indexPath.row]
            } else {
                cell.textLabel?.text = "City not available"
            }
        }
        cell.backgroundColor = .systemGray5
        return cell
    }
}
