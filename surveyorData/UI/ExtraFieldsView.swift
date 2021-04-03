//
//  extraFieldsView.swift
//  surveyorData
//
//  Created by Giles Lemmon on 3/22/21.
//

import SwiftUI

struct ExtraFieldsView: View , Identifiable{
    var id = UUID()
    @State var name:String = ""
    @State var type:String = ""
    //pass in arrays of fields so this view can add to them
    @Binding var entryDataTypes: [String]
    @Binding var entryHeaders: [String]
    
    var body: some View {
        HStack{
            TextField("Field Name:",text:$name)
            TextField("Field Type:",text:$type)
            Button("Save"){
                save()
            }
        }
    }
    func save(){
        entryDataTypes.append(type)
        entryHeaders.append(name)
    }
}

struct ExtraFieldsView_Previews: PreviewProvider {
    static var previews: some View {
       Text("No Preview, Build & Run")
    }
}
