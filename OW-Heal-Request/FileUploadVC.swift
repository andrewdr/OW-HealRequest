//
//  FileUploadVCViewController.swift
//  OW-Heal-Request
//
//  Created by The Clout on 5/8/21.
//

import UIKit
import Amplify
import AmplifyPlugins
import Combine

@available(iOS 10.0, *)

var documentInteractionCtonroller: UIDocumentInteractionController!

class FileUploadVCViewController: UIViewController {
    
    var fileURL: URL?
    
    
    @IBOutlet weak var fileName: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addFile(_ sender: Any) {
        
        
        documentInteractionCtonroller = UIDocumentInteractionController()
        documentInteractionCtonroller.url = fileURL
        documentInteractionCtonroller.uti = fileURL?.uti
        documentInteractionCtonroller.presentOptionsMenu(from: CGRect.zero, in: view, animated: true)
        


        
        
//        let dataString = "John Cena.mp3"
//        let data = dataString.data(using: .utf8)!
//        let storageOperation = Amplify.Storage.uploadData(key: "John Cena.mp3", data: data)
//        let progressSink = storageOperation.progressPublisher.sink { progress in print("Progress: \(progress)") }
//        let resultSink = storageOperation.resultPublisher.sink {
//            if case let .failure(storageError) = $0 {
//                print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
//            }
//        }
//        receiveValue: { data in
//            print("Completed: \(data)")
//        }
        
        
        
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension URL {
    
    var uti: String {
        return (try? self.resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier ?? "John Cena.mp3"
    }
    
}
