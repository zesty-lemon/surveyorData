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
    
    var body: some View {
        
        HStack{
            Text("\(entryHeaders[index]): ")
            TextField(entryData[index], text: $entryData[index])
            
        }
    }
}

struct ModifyParametersView_Previews: PreviewProvider {
    static var previews: some View {
        Text("run")
    }
}
//
