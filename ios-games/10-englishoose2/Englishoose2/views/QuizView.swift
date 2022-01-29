//
//  DrillView.swift
//  englishoose2
//
//  Created by LumberMill, Inc. on 2021/12/31.
//

import SwiftUI
import AVFoundation

struct QuizView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var modelData: ModelData
    @State var currentIndex: Int = 0
    @State var answered = false
    var drill: Drill
    let sound_correct = ModelData.loadSoundAsPlayer(name: "se_maoudamashii_chime13")
    let sound_wrong = ModelData.loadSoundAsPlayer(name: "se_maoudamashii_onepoint33")

    var body: some View {
        VStack{
            ZStack{
                drill.image(index: currentIndex).resizable().aspectRatio(1.0, contentMode: .fit)
                if answered {
                    let r = modelData.results.last ?? false ? "true" : "false"
                    Image(r).resizable().aspectRatio(1.0, contentMode: .fit)
                        .onTapGesture(perform: next)
                }
            }
            .frame(maxWidth: .infinity)
            .background(colorScheme == .dark ? Color.init(red: 0.2, green: 0.2, blue: 0.2) : Color.white)
            List {
                if answered {
                    if reachedLast() {
                        Button("Show result ->", action: {
                            modelData.showResults = true
                            reset()
                        })
                    } else {
                        Button("Next question ->", action: next)
                    }
                } else {
                    let opts = drill.shuffled_options(index: currentIndex)
                    let a = drill.answer(index: currentIndex)
                    ForEach(0..<4) { i in
                        if opts[i] == a {
                            Button(opts[i], action: {
                                if answered { return }
                                sound_correct.play()
                                modelData.results.append(true)
                                answered = true
                            })
                        } else {
                            Button(opts[i], action: {
                                if answered { return }
                                sound_wrong.play()
                                modelData.results.append(false)
                                answered = true
                            })

                        }
                    }
                }
            }
        }
    }
    
    func reachedLast() -> Bool {
        return currentIndex == drill.options.count - 1
    }
    
    func next() {
        if reachedLast() { return }
        currentIndex += 1
        answered = false
    }
    
    func reset(){
        currentIndex = 0
        answered = false
    }
}

struct QuizView_Previews: PreviewProvider {
    static var drills = ModelData().drills

    static var previews: some View {
        QuizView(drill: drills[2]).preferredColorScheme(.dark).environmentObject(ModelData())
    }
}
