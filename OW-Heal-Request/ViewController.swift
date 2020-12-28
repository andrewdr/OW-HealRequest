//
//  ViewController.swift
//  OW-Heal-Request
//
//  Created by The Clout on 12/28/20.
//

import UIKit
import Amplify
import AmplifyPlugins
import Combine

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == playerNamePicker {
            return playerNameData.count
        } else if pickerView == heroPicker {
            return heroData.count
        } else if pickerView == locationPicker {
            return locationData.count
        }
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == playerNamePicker {
            return playerNameData[row]
        } else if pickerView == heroPicker {
            return heroData[row]
        } else if pickerView == locationPicker {
            return locationData[row]
        }
        
        return ""
    
    }
    
    
    @IBOutlet weak var playerNamePicker: UIPickerView!
    @IBOutlet weak var heroPicker: UIPickerView!
    @IBOutlet weak var locationPicker: UIPickerView!
    
    var playerNameData: [String] = [String]()
    var heroData: [String] = [String]()
    var locationData: [String] = [String]()
    
    
    
    

    @IBAction func healRequestBtn(_ sender: Any) {
        
//        performOnAppear()
        

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeHeals()
        
        self.playerNamePicker.delegate = self
        self.playerNamePicker.dataSource = self
        
        self.heroPicker.delegate = self
        self.heroPicker.dataSource = self
        
        self.locationPicker.delegate = self
        self.locationPicker.dataSource = self
        
        
        playerNameData = ["Pun", "The Clout", "Fragmire", "Benzey", "RAWR", "Apple Zachintosh"]
        heroData = ["Ana", "Ashe", "Baptiste", "Bastion", "Brigitte", "D.Va", "Doomfist", "Echo", "Genji", "Hanzo", "Junkrat", "Lucio", "McCree", "Mei", "Mercy", "Moira", "Orisa", "Pharah", "Reaper", "Reinhardt", "Roadhog", "Sigma", "Soldier: 76", "Sombra", "Symmetra", "Torbjorn", "Tracer", "Widowmaker", "Winston", "Wrecking Ball", "Zarya", "Zenyatta"]
        locationData = ["In front of you", "Behind you", "Waiting to Spawn", "Left Sticking", "Out of Position", "Putting the team on my back"]
        
    }
    
    func performOnAppear(){
        
        let healRequest = HealRequest(playerName: "Pun", selectedHero: "Genji", location: "Out of Position")
   
        Amplify.DataStore.save(healRequest){ result in
            switch(result) {
            case .success(let savedRequest):
                print("Saved item: \(savedRequest)")
            case .failure(let error):
                print("Could not save item to datastore: \(error)")
            
            }
            
        }
    }
    
    
    var HealRequestSubscription: AnyCancellable?
    
    func subscribeHeals() {
        self.HealRequestSubscription
           = Amplify.DataStore.publisher(for: HealRequest.self)
               .sink(receiveCompletion: { completion in
                   print("Subscription has been completed: \(completion)")
               }, receiveValue: { mutationEvent in
                   print("Subscription got this value: \(mutationEvent)")

                   do {
                     let healRequest = try mutationEvent.decodeModel(as: HealRequest.self)

                     switch mutationEvent.mutationType {
                     case "create":
                       print("Created: \(healRequest)")
                     case "update":
                       print("Updated: \(healRequest)")
                     case "delete":
                       print("Deleted: \(healRequest)")
                     default:
                       break
                     }

                   } catch {
                     print("Model could not be decoded: \(error)")
                   }
               })
    }
    


}

