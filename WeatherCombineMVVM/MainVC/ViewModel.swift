//
//  ViewModel.swift
//  WeatherCombineMVVM
//
//  Created by Darinka on 27.10.2021.
//

import Foundation
import Combine
import UIKit

class ViewModel {
    
    @Published var data = [""]  //publisher
    private var anyCancelable = Set<AnyCancellable>() //subscriber
    
    @Published var canChangeButton: Bool = false  //publisher
    
    var textForLabel: String = ""
    var textColor: UIColor?
//    private var switchSubscriber1: AnyCancellable? //subscriber1 fro grey button
//    private var switchSubscriber2: AnyCancellable? //subscriber2 fro red button
//    private var switchSubscriber3: AnyCancellable? //subscriber3 fro red button
    
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
    
    func setOutputs(button: String) {
        switch button {
        case "Grey": textForLabel = "Grey button tapped"
        case "Red": textForLabel = "Red button tapped"
        case "Green": textForLabel = "Green button tapped"
        default: textForLabel = "Coming soon"
        }
        
    }
    
    func setOutputsColor(button: String) {
        switch button {
        case "Grey": textColor = UIColor.gray
        case "Red": textColor = UIColor.red
        case "Green": textColor = UIColor.green
        default: textColor = UIColor.blue
        }
        
    }
//
//    func switcherChanged(button1: UIButton, button2: UIButton, button3: UIButton) {
//        // Save the cancellable subscription
//        switchSubscriber1 = $canChangeButton
//             .receive(on: DispatchQueue.main)
//             .assign(to: \.isEnabled, on: button1)
//        
//        switchSubscriber2 = $canChangeButton
//             .receive(on: DispatchQueue.main)
//             .assign(to: \.isEnabled, on: button2)
//        
//        switchSubscriber3 = $canChangeButton
//             .receive(on: DispatchQueue.main)
//             .assign(to: \.isEnabled, on: button3)
//        
//    }
    
    
    
    init() {    }
}
