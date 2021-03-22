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
    
    var body: some View {
        HStack{
            TextField("Field Name:",text:$name)
            TextField("Field Type:",text:$type)
        }

    }
}

struct ExtraFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        ExtraFieldsView()
    }
}
