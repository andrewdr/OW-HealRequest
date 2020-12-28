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

class ViewController: UIViewController {

    @IBAction func healRequestBtn(_ sender: Any) {
        
//        performOnAppear()
        

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeHeals()
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

