//
//  LandmarksApp.swift
//  Landmarks
//
//  Created by Yosei Ito on 2021/01/19.
//

import SwiftUI

@main
struct LandmarksApp: App {
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
