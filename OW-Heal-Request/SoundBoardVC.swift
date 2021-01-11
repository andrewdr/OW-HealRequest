//
//  SoundBoardVC.swift
//  OW-Heal-Request
//
//  Created by The Clout on 1/4/21.
//

import UIKit
import AVFoundation
import Amplify
import AmplifyPlugins
import Combine

private let reuseIdentifier = "Cell"

class SoundBoardVC: UICollectionViewController {
    
    @IBOutlet var soundBoardView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listFiles()
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        self.soundBoardView.dataSource = self
        self.soundBoardView.delegate = self
        
        if let flowLayout = self.soundBoardView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 110, height: 110)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SoundBoardCellVC
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.systemGray.cgColor
        
        cell.audioTitle.translatesAutoresizingMaskIntoConstraints = false
        
        cell.audioTitle?.text = "Title"
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    
    //    MARK: - S3 Storage
        
        var resultSink: AnyCancellable?
        var progressSink: AnyCancellable?
        
        func uploadData(){
            
            let dataString = "Example File Contents"
            let data = dataString.data(using: .utf8)!
            let storageOperation = Amplify.Storage.uploadData(key: "TestKey", data: data)
            
            progressSink = storageOperation
                .progressPublisher
                .sink{ progress in print("Progress: \(progress)")}
            
            resultSink = storageOperation
                .resultPublisher
                .sink {
                    if case let .failure(storageError) = $0 {
                        print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                    }
                }
                
                receiveValue: { data in
                    print("Completed: \(data)")
                    
                }
            
        }
        
        
        func downloadFiles(){
            
            let storageOperation = Amplify.Storage.downloadData(key: "TestKey")
            progressSink = storageOperation.progressPublisher.sink { progress in print("Progress: \(progress)")}
            resultSink = storageOperation.resultPublisher.sink{
                
                if case let .failure(storageError) = $0 {
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                }
                
            }
            
            receiveValue: { data in
                print("Completed: \(data)")
            }
            
        }
        
        
        func listFiles(){
            
            let storageOperation = Amplify.Storage.list()
            resultSink = storageOperation.resultPublisher.sink {
                    if case let .failure(storageError) = $0 {
                        print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                    }
                }
                receiveValue: { listResult in
                    print("Completed")
                    listResult.items.forEach { item in
                        print("Key: \(item.key)")
                    }
                }
        }
        
        
    }
