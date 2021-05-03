//
//  surveyCreation.swift
//  surveyorData
//
//  Created by Giles Lemmon on 3/16/21.
//

import SwiftUI
//insert a survey

struct surveyCreation: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var surveyTitle = ""
    @State private var usesGPS = false
    @State private var usesPhoto = false
    @State private var extraFields: [ExtraFieldsView] = []
    @State private var entryHeaders = [String]()

    //just do it like normal, call ondelete and strip null values from the end neer mind need to consider index
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        Text("Data in this Survey")
                            .font(.title)
                        TextField("Survey Name:",text:$surveyTitle)
                        Toggle("Include Photo", isOn: $usesPhoto)
                        Toggle("Include GPS Location", isOn: $usesGPS)
                        List{
                            ForEach(extraFields, id: \.id) { field in
                                field
                            }
                            .onDelete(perform: self.removeField)
                        }
                        
                        //add an "on delete" method here
                        Button("Add Field"){
                            entryHeaders.append("")
                            extraFields.append(ExtraFieldsView(index: entryHeaders.count-1, entryHeaders: $entryHeaders))
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Create New Survey"), displayMode: .inline)
            //these have been deprecated but still work? replacements are very fussy
            .navigationBarItems(leading:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Text("Cancel").bold()
                                    }, trailing:
                                        Button(action: {
                                            createSurvey()
                                            presentationMode.wrappedValue.dismiss()
                                        }) {
                                            Text("Save").bold()
                                        })
        }
    }
    func removeField(at indexSet: IndexSet) {
        //this is a weird way of getting around the fact that
        //state variables in a child view are immutable for some reason
        let index = indexSet[indexSet.startIndex]
        //if deleting not the last or first element
        print("extrafields count: \(extraFields.count)")
        //if deleting last object
        if index < extraFields.count-1 && extraFields.count != 0{
            for i in index+1..<extraFields.count{
                print("resetting \(i)")
                extraFields[i].index = extraFields[i].index-1
            }
        }
        print("Before removal: \(entryHeaders)")
        if index != entryHeaders.count-1 {
            self.extraFields.remove(atOffsets: indexSet)
            self.entryHeaders.remove(at: index)
        }
        //last element crashes because the fucking cunt drunk 4 year old child who wrote this can go get fucked there's no reason why this doesn't work
        print("Printing Indexes")
        for j in 0..<extraFields.count{
            print("\(extraFields[j].index)")
        }
        print("removing at index: \(index)")
        print("after removal: \(entryHeaders)")
        //reset indexes of all elements down the list
        //to account for deletion of the entryHeaders element
    }
    func lastDelete(){
        self.entryHeaders.removeLast()
    }

    func createSurvey() -> Void{
        let NewSurvey = Survey(context: viewContext)
        NewSurvey.surveyTitle = surveyTitle
        NewSurvey.dateCreated = Date()
        NewSurvey.entryHeaders = entryHeaders
        NewSurvey.containsLocation = usesGPS
        NewSurvey.containsPhoto = usesPhoto
        NewSurvey.type = "Survey"
        
        debugPrint(NewSurvey.entryHeaders)
        do {
            //save to database
            //before I save, maybe here I run the code to make the headers the ones from the file?
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
            
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}
struct surveyCreation_Previews: PreviewProvider {
    static var previews: some View {
        surveyCreation()
    }
}

