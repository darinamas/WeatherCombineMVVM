//
//  ViewController.swift
//  WeatherCombineMVVM
//
//  Created by Darinka on 27.10.2021.
//

import UIKit
import Combine

class MainVC: UIViewController {
    var anyCancelable = Set<AnyCancellable>()
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonAction(_ sender: Any) {
        viewModel.fetch()
        viewModel.$data
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                let randomWord = data.randomElement()
                self?.wordLabel.text = randomWord
                self?.tempLabel.text = self!.viewModel.randomSmile()
            }
            .store(in: &anyCancelable)
    }
    

    
}
