//
//  englishoose2App.swift
//  englishoose2
//
//  Created by LumberMill, Inc. on 2021/12/31.
//

import SwiftUI

@main
struct Englishoose2App: App {
    @StateObject private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(modelData)
        }
    }
}
