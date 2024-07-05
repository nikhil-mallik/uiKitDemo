//
//  ProfileAddViewModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 27/06/24.
//

import UIKit
import Combine
import Alamofire

class ProfileAddViewModel {
    // MARK: - Singleton Instance
      static let shared = ProfileAddViewModel()
    private init() {} 
    // MARK: - Published Properties
    @Published var countries: [Country] = []
    @Published var filteredCountries: [Country] = []
    @Published var states: [Statess] = []
    @Published var filteredStates: [Statess] = []
    @Published var cities: [String] = []
    @Published var filteredCities: [String] = []
    
    // MARK: - Variables
    var defaultStates = Statess(name: "No State Available", stateCode: "XXXXX")
    var defaultCities = City(name: "No City Available")
    weak var viewController: ProfileListViewController?
    weak var vc: AddProfileViewController?
    var cancellables = Set<AnyCancellable>()
    var userData: [ProfileModel] = [] {
        didSet {
            viewController?.tableView.reloadData()
            let total = userData.count
            print("Total = \(total)")
        }
    }
    
    
    // MARK: - Fetch Countries
    func fetchCountries() {
        guard let url = URL(string: countryAPI) else { return }
        fetchData(with: url, expecting: CountriesResponse.self) { [weak self] (response) in
            self?.countries = response.data
            self?.filteredCountries = response.data
        }
    }
    
    // MARK: - Clear Cities
    func clearCities() {
        cities.removeAll()
        filteredCities.removeAll()
    }
    
    func deleteUserData(withId id: Int) {
        // Find the index of the item with the given id
        if let index = userData.firstIndex(where: { $0.id == id }) {
            // Remove the item from viewModel.userData
            userData.remove(at: index)
            print("Item with id \(id)  deleted from userData.")
        } else {
            print("Item with id \(id) not found in userData.")
        }
    }

    
    
    // MARK: - Fetch States
    func fetchStates(for country: String, button: UIButton? = nil) {
        guard let url = URL(string: stateAPI) else { return }
        let body = ["country": country]
        if let button = button { LoaderViewHelper.showLoader(on: button) }
        fetchData(with: url, method: .post, body: body, expecting: StatesResponse.self) { [weak self] (response) in
            self?.states = response.data.states
            self?.filteredStates = response.data.states
            self?.reloadTableView(for: .state)
            LoaderViewHelper.hideLoader()
            print("States fetched -> \(response.data.states.count)")
            if self?.states.count == 0 {
                self?.vc?.selectedStateNameLbl.text = "State not available"
                self?.vc?.selectedCityNameLbl.text = "City not available"
                self?.vc?.selectedState = self?.defaultStates
                self?.vc?.selectedCity = self?.defaultCities.name
            }
        }
    }
    
    // MARK: - Fetch Cities
    func fetchCities(for country: String, state: String, button: UIButton? = nil) {
        guard let url = URL(string: cityAPI) else { return }
        let body = ["country": country, "state": state]
        if let button = button { LoaderViewHelper.showLoader(on: button) }
        fetchData(with: url, method: .post, body: body, expecting: CitiesResponse.self) { [weak self] (response) in
            self?.cities = response.data
            self?.filteredCities = response.data
            self?.reloadTableView(for: .city)
            LoaderViewHelper.hideLoader()
            print("Cities fetched -> \(response.data.count)")
            if self?.cities.count == 0 {
                self?.vc?.selectedCityNameLbl.text = "City not available"
                self?.vc?.selectedCity = self?.defaultCities.name
            }
//            completion()
        }
    }
    
    // MARK: - Country Search Methods
    func searchCountries(with query: String) {
        if query.count >= 2 {
            filteredCountries = countries.filter { $0.name.lowercased().contains(query.lowercased()) }
        } else {
            filteredCountries.removeAll()
            filteredCountries = countries
        }
    }
    
    
    // MARK: - States Search Methods
    func searchStates(with query: String) {
        if query.count >= 2 {
            filteredStates = states.filter { $0.name.lowercased().contains(query.lowercased()) }
        } else {
            filteredStates.removeAll()
            filteredStates = states
        }
    }
    
    // MARK: - Cities Search Methods
    func searchCities(with query: String) {
        if query.count >= 2 {
            filteredCities = cities.filter { $0.lowercased().contains(query.lowercased()) }
        } else {
            filteredCities.removeAll()
            filteredCities = cities
        }
    }
    
    func resetArrayData(for type: AddProfileViewController.DropdownType) {
        switch type {
        case .country:
            searchStates(with: "")
            searchCities(with: "")
        case .state:
            searchCountries(with: "")
            searchCities(with: "")
        case .city:
            searchCountries(with: "")
            searchStates(with: "")
        }
    }
    
    // MARK: - Private Helper Methods
    private func fetchData<T: Decodable>(with url: URL, method: HTTPMethod = .get, body: [String: Any]? = nil, expecting: T.Type, completion: @escaping (T) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    AlertHelper.showAlert(withTitle: "Alert", message: "Error fetching data: \(error)", from: self.vc!)
                    print("Error fetching data: \(error)")
                }
            }, receiveValue: { response in
                completion(response)
            })
            .store(in: &cancellables)
    }
    
    private func reloadTableView(for type: AddProfileViewController.DropdownType) {
        DispatchQueue.main.async {
            self.vc?.reloadTableView(for: type)
            self.resetArrayData(for: type)
            self.vc?.clearAllSearchBars()
            self.vc?.checkButtonEnableDisable()
        }
    }
}
