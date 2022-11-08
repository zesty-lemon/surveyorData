//
//  surveyCreation.swift
//  surveyorData
//
//  Created by Giles Lemmon on 3/16/21.
//

import SwiftUI
import Combine
import Foundation
import MapKit

//insert a survey
//field stores an ID and the fieldname
class Field: ObservableObject,Identifiable{
    var id = UUID()
    @Published var fieldName: String
    init(startingText: String){
        self.fieldName = startingText
    }
}
//user entered fields are stored in an array inside an observable object
//this allows UI to mutate values inside the fields views
//as well as insert/delete operations
class Fields: ObservableObject{
    @Published var addedFields: [Field]
    init(){
        self.addedFields = []
    }
}
//struct for each new field added
struct FieldRow: View {
    @ObservedObject var singleField: Field
    var body: some View {
        TextField("Field Name (Units)", text: $singleField.fieldName)
    }
}
struct surveyCreation: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var surveyTitle = ""
    @State private var usesGPS = false
    @State private var usesPhoto = false
    @ObservedObject var myFields: Fields = Fields.init()

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
                            ForEach(myFields.addedFields){ everyfield in
                                FieldRow(singleField: everyfield)
                            }
                            .onDelete(perform: removeField)
                        }
                        
                        //add an "on delete" method here
                        Button(action: {
                            self.myFields.addedFields.append(Field(startingText: ""))
                        }) {
                            Text("Add Field")
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
    //todo add moveat
    //maybe I could store a "fieldposition" var in the survey object.  On move adjusts that
    //and the filter sorts on that aspect. 
    func removeField(at offsets: IndexSet) {
        print("removing")
        myFields.addedFields.remove(atOffsets: offsets)
    }
    
    func createSurvey() -> Void{
        
        let NewSurvey = Survey(context: viewContext)
        NewSurvey.surveyTitle = surveyTitle
        NewSurvey.dateCreated = Date()
        var tempFieldValues = [String]()
        //if there are more than 1 or more fields to add
        if (myFields.addedFields.count>0){
            for i in 0..<myFields.addedFields.count{
                //only add fields if they are not blank
                if(myFields.addedFields[i].fieldName != ""){
                    tempFieldValues.append(myFields.addedFields[i].fieldName)
                }
            }
        }
        //write survey init methods to stop weird errors
        NewSurvey.entryHeaders.append(contentsOf: tempFieldValues)
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

