//
//  extraFieldsView.swift
//  surveyorData
//
//  Created by Giles Lemmon on 3/22/21.
//

import SwiftUI

struct ExtraFieldsView: View , Identifiable{
    var id = UUID()
    let index: Int
    //pass in arrays of fields so this view can add to them
    @Binding var entryDataTypes: [String]
    @Binding var entryHeaders: [String]
    @State private var selectedType = "Type"
    
    var body: some View {
        HStack{
            //TextField("Field Name:",text:$entryDataTypes[index])
            TextField("Field Name:",text:$entryHeaders[index])
            // I may change this field to "Units" instead
            // for now, have the selection be the label itself
            Picker("\(selectedType)", selection: $selectedType) {
                ForEach(Constants.allowableTypes, id: \.self) {
                    Text($0)
                }
            }
            .onReceive([self.selectedType].publisher.first()) { value in
                        self.setType(toAdd: selectedType)
             }
            .pickerStyle(MenuPickerStyle())
            
        }
    }
    
    func setType(toAdd: String){
        entryDataTypes[index] = toAdd
    }
}

struct ExtraFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("No Preview, Build & Run")
    }
}
