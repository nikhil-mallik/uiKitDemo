//
//  CountryViewModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 20/06/24.
//

import UIKit
import Foundation
import Combine

let baseUrl = "https://countriesnow.space/api/v0.1/countries/"
let countryAPI = "\(baseUrl)iso"
let stateAPI = "\(baseUrl)states"
let cityAPI = "\(baseUrl)state/cities"

class CountryViewModel: ObservableObject {
    
    @Published var countries: [Country] = []
    @Published var states: [Statess] = []
    @Published var cities: [String] = []
    weak var vc: CountryViewController?
    var cancellables = Set<AnyCancellable>()
    
    func fetchCountries() {
        guard let url = URL(string: countryAPI) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: CountriesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching countries: \(error)")
                }
            }, receiveValue: { [weak self] response in
                self?.countries = response.data
                print("countries -> \(response.data.count)")
            })
            .store(in: &cancellables)
    }
    
    func fetchStates(for country: String) {
        guard let url = URL(string: stateAPI) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["country": country], options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: StatesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching states: \(error)")
                }
            }, receiveValue: { [weak self] response in
                self?.states = response.data.states
                DispatchQueue.main.async {
                    self?.objectWillChange.send()
                    self!.vc!.stateTableViewOutlet.reloadData()
                }
                print("states -> \(response.data.states.count)")
            })
            .store(in: &cancellables)
    }
    
    func fetchCities(for country: String, state: String) {
        guard let url = URL(string: cityAPI) else { return }
        print("country -> \(country), state -> \(state)")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["country": country, "state": state], options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: CitiesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching cities: \(error)")
                }
            }, receiveValue: { [weak self] response in
                self?.cities = response.data
                // Force reload table view
                DispatchQueue.main.async {
                    self!.objectWillChange.send()
                    self!.vc!.cityTableViewOutlet.reloadData()
                }
                print("City -> \(response.data.count)")
            })
            .store(in: &cancellables)
    }
}
