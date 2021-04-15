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
    @Binding var entryDataTypes: [String]
    
    var body: some View {
        
        if entryDataTypes[index] == "Number"{
            TextField(entryHeaders[index], text: $entryData[index])
                .keyboardType(.decimalPad)
        }
        else {
            TextField(entryHeaders[index], text: $entryData[index])
                .multilineTextAlignment(.leading)
        }
    }
}

struct EntryParameterView_Previews: PreviewProvider {
    static var previews: some View {
        Text("run")
    }
}
//
