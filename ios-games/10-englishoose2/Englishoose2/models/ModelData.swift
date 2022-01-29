//
//  ModelData.swift
//  englishoose2
//
//  Created by LumberMill, Inc. on 2021/12/31.
//

import Foundation
import AVFoundation

final class ModelData: ObservableObject {
    @Published var drills: [Drill] = loadDrills()
    @Published var results: [Bool] = []
    @Published var showResults: Bool = false
    @Published var currentIndex: Int = 0

    func reset(){
        showResults = false
        currentIndex = 0
        results = []
    }
    
    static func loadDrills() -> [Drill] {
        guard let url = Bundle.main.url(forResource: "drills", withExtension: "json") else {
            print("url not found")
            return []
        }
        guard let data = try? Data(contentsOf: url) else {
            print("data not found")
            return []
        }
        do {
            guard let root = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray else {
                print("Could not parse data from "+url.description)
                return []
            }
            var drills:[Drill] = []
            for _drill in root {
                let drill = Drill(dic: _drill as! NSDictionary)
                print(drill)
                drills.append(drill)
            }
            return drills
        } catch let error as NSError {
            print(error.localizedDescription)
            return []
        }
    }
    
    static func loadSoundAsPlayer(name: String) -> AVAudioPlayer {
        guard let sound_url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            fatalError(name+" not found.")
        }
        do{
            let audioPlayer = try AVAudioPlayer(contentsOf: sound_url)
            // audioPlayer.delegate = delegate
            audioPlayer.prepareToPlay()
            return audioPlayer
        }catch{
            fatalError("Failed to load sound.");
        }
    }

}
