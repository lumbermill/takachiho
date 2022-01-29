//
//  ContentView.swift
//  englishoose2
//
//  Created by LumberMill, Inc. on 2021/12/31.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var modelData: ModelData

    var body: some View {
        NavigationView {
            List {
                ForEach(modelData.drills) { drill in
                    NavigationLink(destination: DrillView(drill: drill)) {
                        DrillRow(drill: drill)
                    }
                }
            }.navigationTitle("Englishoose")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(ModelData())
    }
}
