//
//  ResultView.swift
//  englishoose2
//
//  Created by LumberMill, Inc. on 2022/01/02.
//

import SwiftUI

struct ResultView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var modelData: ModelData
    @Environment(\.dismiss) var dismiss

    let nRow = 3
    let nCol = 4
    var drill: Drill

    var body: some View {
        VStack{
            Text(message()).padding().font(.headline).transition(.slide)
            ForEach(0..<nRow) { i in
                HStack {
                    ForEach(0..<nCol) { j in
                        let idx = i*nCol+j
                        ZStack{
                        drill.image(index: idx).resizable().aspectRatio(1.0, contentMode: .fit)
                            if idx < modelData.results.count {
                                let r = modelData.results[idx] ? "true" : "false"
                                Image(r).resizable().aspectRatio(1.0, contentMode: .fit)
                            }
                        }
                        .background(colorScheme == .dark ? Color.init(red: 0.2, green: 0.2, blue: 0.2) : Color.white)

                    }
                }
            }
            HStack{
                Button("Again",action: {
                    modelData.reset()
                }).padding()
                Button("Back to menu",action: {
                    dismiss()
                    modelData.reset()
                }).padding()
            }.padding()
        }
    }
    
    func message() -> String {
        var n = 0
        for r in modelData.results {
            if r { n += 1 }
        }
        // results.allSatisfy({ $0 }) {}
        if n == 12 { return "Perfect!!" }
        else if n > 2 { return "Good!" }
        else { return "Try again!" }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var drills = ModelData().drills

    static var previews: some View {
        ResultView(drill: drills[0])
    }
}
