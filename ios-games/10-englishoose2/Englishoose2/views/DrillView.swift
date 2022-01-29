//
//  DrillView.swift
//  englishoose2
//
//  Created by LumberMill, Inc. on 2022/01/03.
//

import SwiftUI

struct DrillView: View {
    @EnvironmentObject var modelData: ModelData
    var drill: Drill

    func shouldShowResult() -> Bool {
        return modelData.showResults && modelData.results.count == drill.options.count
    }
    
    var body: some View {
        if shouldShowResult() {
            ResultView(drill: drill).environmentObject(modelData).navigationBarBackButtonHidden(true)
                .navigationTitle(drill.title)
        } else {
            QuizView(drill: drill).environmentObject(modelData).navigationBarBackButtonHidden(true)
                .navigationTitle(drill.title)
        }
    }
}

struct DrillView_Previews: PreviewProvider {
    static var drills = ModelData().drills

    static var previews: some View {
        DrillView(drill: drills[0])
    }
}
