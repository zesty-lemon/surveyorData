//
//  EntryParameterView.swift
//  surveyorData
//
//  Created by Giles Lemmon on 4/7/21.
//

import SwiftUI

struct EntryParameterView: View, Identifiable {
    var id = UUID()
    let index: Int
    @Binding var entryData: [String]
    @Binding var entryHeaders: [String]

    
    var body: some View {
        TextField(entryHeaders[index], text: $entryData[index])
    }
}

struct EntryParameterView_Previews: PreviewProvider {
    static var previews: some View {
        Text("run")
    }
}
