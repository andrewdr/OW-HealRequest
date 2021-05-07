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
        
        var rowCount: Int = 0
        
        if pickerView == playerNamePicker {
            rowCount = playerNameData.count
        } else if pickerView == heroPicker {
            rowCount = heroData.count
        } else if pickerView == locationPicker {
            rowCount = locationData.count
        }
        
        return rowCount
        
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
    
    var playerNameData: [String] = [String]()
    var heroData: [String] = [String]()
    var locationData: [String] = [String]()
    
    
    var selectedPlayer: String?
    var selectedHero: String?
    var selectedLocation: String?
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
            
            if pickerView == playerNamePicker {
                selectedPlayer = playerNameData[row]
            } else if pickerView == heroPicker {
                selectedHero = heroData[row]
            }else if pickerView == locationPicker {
                selectedLocation = locationData[row]
            }
        
    }
    
    
    @IBOutlet weak var playerNamePicker: UIPickerView!
    @IBOutlet weak var heroPicker: UIPickerView!
    @IBOutlet weak var locationPicker: UIPickerView!


    @IBAction func healRequestBtn(_ sender: Any) {
        
        requestHeals()
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        subscribeHeals()
        
        
        
        self.playerNamePicker.delegate = self
        self.playerNamePicker.dataSource = self
        
        self.heroPicker.delegate = self
        self.heroPicker.dataSource = self
        
        self.locationPicker.delegate = self
        self.locationPicker.dataSource = self
        
        playerNameData = ["Pun", "The Clout", "Fragmire", "Benzey", "RAWR", "Apple Zachintosh"]
        heroData =  ["Ana", "Ashe", "Baptiste", "Bastion", "Brigitte", "D.Va", "Doomfist", "Echo", "Genji", "Hanzo", "Junkrat", "Lucio", "McCree", "Mei", "Mercy", "Moira", "Orisa", "Pharah", "Reaper", "Reinhardt", "Roadhog", "Sigma", "Soldier: 76", "Sombra", "Symmetra", "Torbjorn", "Tracer", "Widowmaker", "Winston", "Wrecking Ball", "Zarya", "Zenyatta"]
        locationData =     ["In front of you", "Behind you", "Waiting to Spawn", "Left Sticking", "Out of Position", "Putting the team on my back"]
        
        
    }
    
    func requestHeals(){
        
        let healRequest = HealRequest(playerName: selectedPlayer ?? "Pun", selectedHero: selectedHero ?? "Ana", location: selectedLocation ?? "Out of Position")
        
   
        Amplify.DataStore.save(healRequest){ result in
            switch(result) {
            case .success(let savedRequest):
                print("Saved item: \(savedRequest)")
            case .failure(let error):
                print("Could not save item to datastore: \(error)")

            }

        }
        
        healsSentAlert()
        
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
    
    func healsSentAlert(){
        
        let requestSentAlert = UIAlertController(title: "SUCCESS!", message: "Your heal request has been submitted, heals will be dispatched shortly.", preferredStyle: .alert)
        
        requestSentAlert.addAction(UIAlertAction(title: "Go Back To Winning", style: .cancel, handler:{ action in
            
            self.playerNamePicker.selectRow(0, inComponent: 0, animated: true)
            self.heroPicker.selectRow(0, inComponent: 0, animated: true)
            self.locationPicker.selectRow(0, inComponent: 0, animated: true)
        
        }))
        
        self.present(requestSentAlert, animated: true, completion: nil)
    }
    
}
