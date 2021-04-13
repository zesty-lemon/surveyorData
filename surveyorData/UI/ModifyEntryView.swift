//
//  ModifyEntryView.swift
//  surveyorData
//
//  Created by Giles Lemmon on 4/12/21.
//

import SwiftUI

struct ModifyEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Binding var entryToModify: Entry
    @State private var dataToAdd: [String] = []
    @State private var entryHeaders: [String] = []
    @State private var entryAdditionFields: [ModifyParametersView] = []
    //now add onappear to instantiate these values
    
    
    //I need to do this the way I did it last time - setup an array of views (yuck) and pass each one the array of data to add as well as its index.  
    var body: some View {
        NavigationView{
                Form{
                    List(entryAdditionFields, id: \.id){ field in
                        field
                    }
//                    ForEach(0..<entryToModify.entryData.count) { i in
//                        //HStack{
//                        //Text("\(entryHeaders[i]): ")
//                        Text("\(dataToAdd[i])")
////                            if entryToModify.survey.entryDataTypes[i] == "Number"{
////                                TextField(entryToModify.entryData[i], text: $dataToAdd[i])
////                                    .keyboardType(.decimalPad)
////                            }
////                            else{
////                                TextField(entryToModify.entryData[i], text: $dataToAdd[i])
////                            }
//                        //}
//                    }
            }
            .navigationBarTitle(Text("Edit Sample Data"), displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Text("Cancel").bold()
                                    }, trailing:
                                        Button(action: {
                                            modifyEntry()
                                            presentationMode.wrappedValue.dismiss()
                                        }) {
                                            Text("Save").bold()
                                        })
        }
        .onAppear{
            print("actally got here")
            setup()
        }
    }
    
    func setup(){
        print("In Setup")
        print("EntryData looks like \(entryToModify.entryData)")
        dataToAdd = entryToModify.entryData
        entryHeaders = entryToModify.survey.entryHeaders
        print("DataToAdd looks like : \(dataToAdd)")
        
        for i in 0..<dataToAdd.count {
            print("Modifying \(i)")
//            dataToAdd.append(entryToModify.entryData[i])
//            entryHeaders.append(entryToModify.survey.entryHeaders[i])
//            dataToAdd.append("")
            entryAdditionFields.append(ModifyParametersView(index: i,entryData: $dataToAdd, entryHeaders: $entryHeaders, entryDataTypes: $entryToModify.survey.entryDataTypes))
        }
        print("entryData: \(dataToAdd)")
        print("entryHeaders: \(entryHeaders)")
        print("DataToAdd now has a length of : \(dataToAdd.count)")
    }
    func modifyEntry(){
        print("Inserting data: \(dataToAdd)")
        entryToModify.entryData = dataToAdd
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
            
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct ModifyEntryView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Build & Run")
    }
}
