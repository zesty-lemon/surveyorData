//
//  ModifyParametersView.swift
//  surveyorData
//
//  Created by Giles Lemmon on 4/13/21.
//


import SwiftUI

struct ModifyParametersView: View, Identifiable {
    var id = UUID()
    let index: Int
    @Binding var entryData: [String]
    @Binding var entryHeaders: [String]
    @Binding var entryDataTypes: [String]
    
    var body: some View {
        if entryDataTypes[index] == "Number"{
            HStack{
            Text("\(entryHeaders[index]): ")
              //  https://stackoverflow.com/questions/56471973/how-do-i-create-a-multiline-textfield-in-swiftui
                //maybe change this to a multiline text view for text only
            TextField(entryData[index], text: $entryData[index])
                .keyboardType(.decimalPad)
            }
        }
        else {
            HStack{
            Text("\(entryHeaders[index]): ")
            TextField(entryData[index], text: $entryData[index])
            }
        }
    }
}

struct ModifyParametersView_Previews: PreviewProvider {
    static var previews: some View {
        Text("run")
    }
}
//