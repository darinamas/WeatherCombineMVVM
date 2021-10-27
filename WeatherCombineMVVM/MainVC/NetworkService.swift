//
//  NetworkService.swift
//  WeatherCombineMVVM
//
//  Created by Darinka on 27.10.2021.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    var anyCancelable = Set<AnyCancellable>()
    
    func getResults() -> Future<[String], Error> {
        
        let urlString = "https://random-word-api.herokuapp.com/word?number=1"
         let url = URL(string: urlString)!
        
        let decoder = JSONDecoder()
        
        return Future {[weak self] promise in
            guard let self = self else {return}
            URLSession.shared.dataTaskPublisher(for: url)
                .retry(1)
                .mapError {$0}
                .tryMap { element -> Data in
                    guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return element.data
                }
                .decode(type: [String].self, decoder: decoder)
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    
                } receiveValue: { jobs in
                    promise(.success(jobs))
                }
                .store(in: &self.anyCancelable)
        }
        
        
    }
}
