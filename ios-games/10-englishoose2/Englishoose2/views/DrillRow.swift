//
//  DrillRow.swift
//  englishoose2
//
//  Created by LumberMill, Inc. on 2021/12/31.
//

import SwiftUI

struct DrillRow: View {
    var drill: Drill
    
    var body: some View {
        HStack{
            drill.image(index: 0).resizable().frame(width: 50, height: 50)
            Text(drill.title)
            Spacer()
        }
    }
}

struct DrillRow_Previews: PreviewProvider {
    static var drills = ModelData().drills
    
    static var previews: some View {
        Group{
            DrillRow(drill: drills[0])
            DrillRow(drill: drills[1])
        }.previewLayout(.fixed(width: 300, height: 70))
    }
}
