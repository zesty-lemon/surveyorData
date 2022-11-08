//
//  extraFieldsView.swift
//  surveyorData
//
//  Created by Giles Lemmon on 3/22/21.
//

import SwiftUI

struct ExtraFieldsView: View , Identifiable{
    
    var id = UUID()
    var index: Int
    var fieldType: String
    @Binding var entryHeaders: [String]

    var body: some View {
        HStack{
            TextField("Field Name (Units)",text: $entryHeaders[index])
        }
        
        
    }
//    public func returnField() -> String{
//        return singleHeader
//    }
}

struct ExtraFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("No Preview, Build & Run")
    }
}
