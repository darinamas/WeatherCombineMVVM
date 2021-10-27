//
//  ViewModel.swift
//  WeatherCombineMVVM
//
//  Created by Darinka on 27.10.2021.
//

import Foundation
import Combine

class ViewModel {
    
    @Published var data = [""]
    private var anyCancelable = Set<AnyCancellable>()
    
    func fetch() {
        NetworkManager.shared.getResults()
            .receive(on: DispatchQueue.main)
            .map{$0}
            .sink { completion in
    
                switch completion {
                
                case .finished:
                    print("Done")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: {[weak self] jobs in
                guard let self = self else {return}
                self.data = jobs
                
            }
            .store(in: &anyCancelable)
    }
    
    func randomSmile() -> String {
        let array = ["🥰", "🎃", "🥶", "🤣"]
        return array.randomElement() ?? "🦀"
        
    }
    init() {    }
}
