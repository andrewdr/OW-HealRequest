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
    
    var globalAudioFileArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAudioFiles()
//        getAudioCloudURL()
    

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

        return 1
        
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return globalAudioFileArray.count
        
    }


    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SoundBoardCellVC

        cell.layer.borderWidth = 1
        cell.layer.borderColor = CGColor(red:234/255, green: 178/255, blue: 22/255, alpha: 1 )
        cell.layer.cornerRadius = 10
        cell.audioTitle.translatesAutoresizingMaskIntoConstraints = false
        
        var tempArray: [String] = []
        
//      removes file extention from title
        for titles in globalAudioFileArray {
        
            let editedTitles = titles.dropLast(4)
        
            tempArray.append(String(editedTitles))
        
            }
        
        
        cell.audioTitle?.text = tempArray[indexPath.row]

        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        var soundClip: AVAudioPlayer?
        
//        let path = Bundle.main.path(forResource: globalAudioFileArray[indexPath.row], ofType: ".mp3") ?? "SIMP.mp3"
//
//        print("The path is \(path)")
//
//        let url = URL(fileURLWithPath: path)
//
//        do {
//            soundClip = try AVAudioPlayer(contentsOf: url)
//            soundClip?.play()
//
//        }catch{
//
//            print("Error: Audio File \(globalAudioFileArray[indexPath.row]) missing.")
//
//        }
        
        playAudio()
        
    }
    
    func playAudio(){
        
        var soundClip: AVAudioPlayer?
        
        if let directory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first{
            
            let path = NSURL(fileURLWithPath: directory).appendingPathComponent("Dump Trucks.mp3")
            
            print("The path is \(String(describing: path))")
            
            let url = path
            
            do {
                soundClip = try AVAudioPlayer(contentsOf: url!)
                soundClip?.play()
                
            }catch{
                
                print("Error: Audio File missing.")
                
            }
            
            
        }
        
        
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
    

    func dowloadAudioFileName(audioFiles: String){
        
        let downloadToFileName = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] .appendingPathComponent("\(audioFiles)")
        let storageOperation = Amplify.Storage.downloadFile(key: "\(audioFiles)", local: downloadToFileName)
        
        resultSink = storageOperation.resultPublisher.sink {
            
            if case let .failure(storageError) = $0 {
                
                print("Failed: \(storageError.errorDescription) \(storageError.recoverySuggestion)")
                
            }
            
        }
        
        receiveValue: {
            print("File Download complete")
        }
    }
    
    func listFiles(completionHandler: @escaping (Array<String>) -> ()){
        
        var audioFileArray: [String] = []
        
        resultSink = Amplify.Storage.list()
            .resultPublisher
            .sink {
                if case let .failure(storageError) = $0 {
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                }
            }
            
            receiveValue: { listResult in
                
                print("Completed")
                
                listResult.items.forEach { item in
                    
                    audioFileArray.append(item.key)
                }
                
                self.saveAudioToDataStore(audio: audioFileArray)
                

                
                completionHandler(audioFileArray)
                
        
                print("The audio files are: \(audioFileArray)")
                
            }

    }
    
    func getAudioFiles(){
        listFiles(){ (audioFileArray) in
        
        self.globalAudioFileArray = audioFileArray
            
            DispatchQueue.main.async {
                self.soundBoardView.reloadData()
            }
            
        }
    }
    
    func getAudioCloudURL(){
        
        resultSink = Amplify.Storage.getURL(key: "Cucked.mp3")
        
            .resultPublisher
        
            .sink {
                if case let .failure(storageError) = $0 {
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                }
            }
            
            receiveValue: { url in
                print("Audio URL is \(url)")
            }
    }
    
    func saveAudioToDataStore(audio:Array<String>){
        
        let audioData = AudioInfo(audioTitle: String(audio[0]), audioFileName: String(audio[0]))
        
        Amplify.DataStore.save(audioData){ result in
            switch(result) {
            case .success(let savedRequest):
                print("Saved item: \(savedRequest)")
            case .failure(let error):
                print("Could not save item to datastore: \(error)")

            }

        }
    }
    
    
}
