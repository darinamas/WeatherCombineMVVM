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

    @IBOutlet weak var switcher: UISwitch!
    
    @IBOutlet weak var greyButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var labelForButton: UILabel!
    
    private var switchSubscribers = Set<AnyCancellable>() //subscriber
    
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  viewModel.switcherChanged(button1: greyButton, button2: redButton, button3: greenButton)
        
        // Create a publisher
        let publisher = NotificationCenter.Publisher(center: .default, name: .titleNotification, object: nil)
                                        .map { (notification) -> String? in
             return (notification.object as? titleStruct)?.title ?? ""
        }
        
        let publisher2 = NotificationCenter.Publisher(center: .default, name: .titleNotification, object: nil)
                                        .map { (notification) -> UIColor? in
                                    return (notification.object as? titleStruct)?.color
        }
        
        // Create a subscriber
        let subscriber = Subscribers.Assign(object: labelForButton, keyPath: \.text)
        publisher.subscribe(subscriber)
        
        // Create a subscriber
        let subscriber2 = Subscribers.Assign(object: labelForButton, keyPath: \.backgroundColor)
        publisher2.subscribe(subscriber2)
        
        //create subscribers
        switchSubscribers = [
            viewModel.$canChangeButton
                .receive(on: DispatchQueue.main)
                .assign(to: \.isEnabled, on: redButton),
            viewModel.$canChangeButton
                .receive(on: DispatchQueue.main)
                .assign(to: \.isEnabled, on: greenButton),
            viewModel.$canChangeButton
                .receive(on: DispatchQueue.main)
                .assign(to: \.isEnabled, on: greyButton)
        ]
       
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
    
    //Switcher
    @IBAction func switchAction(_ sender: UISwitch) {
        viewModel.canChangeButton = sender.isOn
    }
    
    @IBAction func redButtonTapped(_ sender: Any) {
        viewModel.setOutputs(button: "Red")
        viewModel.setOutputsColor(button: "Red")
        postNotification()
    }
    
    @IBAction func greyButtonTapped(_ sender: Any) {
        viewModel.setOutputs(button: "Grey")
        viewModel.setOutputsColor(button: "Grey")
        postNotification()
    }
    
    
    @IBAction func greenButtonTapped(_ sender: Any) {
        viewModel.setOutputs(button: "Green")
        viewModel.setOutputsColor(button: "Green")
        postNotification()
    }
    
    func postNotification() {
         // We can fire the notification when the user taps the button.
         // Post the notification
        let title = viewModel.textForLabel ?? "Coming soon"
        let color = viewModel.textColor
        let newTitle = titleStruct(title: title, color: color!)
        NotificationCenter.default.post(name: .titleNotification, object: newTitle)
    }
}

extension Notification.Name {
    static let titleNotification = Notification.Name("newTitle")
}
struct titleStruct {
    let title: String
    let color: UIColor
}
