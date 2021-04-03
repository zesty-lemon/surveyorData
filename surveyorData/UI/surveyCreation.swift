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
    @State private var entryDataTypes = [String]()
    @State private var entryHeaders = [String]()
    
    var body: some View {
        
        VStack {
            Form {
                Section {
                    //why do I have to use $ signs
                    
                    Text("Data in Survey")
                        .font(.title)
                    TextField("Survey Name:",text:$surveyTitle)
                    Toggle("Include Photo", isOn: $usesPhoto)
                    Toggle("Include GPS Location", isOn: $usesGPS)
                    List(extraFields, id: \.id) { field in
                        field
                    }
                    Button("Add Field"){
                        //adds new extra fields view
                        extraFields.append(ExtraFieldsView(entryDataTypes: $entryDataTypes, entryHeaders: $entryHeaders))
                        print(debugPrint(extraFields))
                    }
                }
            }
            HStack{
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .padding(10)
                }
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 20)
                        .stroke())
                .padding(10)
                Button(action: {
                    createSurvey()
                }) {
                    Text("  Save  ")
                        .padding(10)
                }
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 20)
                        .stroke())
                .padding(10)
                //here I need some way of adding text to my list, and then displaying the list as I add it.  Then this is passed to
            }
        }
    }
    
    func createSurvey() -> Void{
        //viewContext = where core data lives, container for it
        //let viewContext = PersistenceController.shared.container.viewContext
        //make the item to be inserted
        let NewSurvey = Survey(context: viewContext)
        NewSurvey.surveyTitle = surveyTitle
        
        debugPrint(entryHeaders)
        NewSurvey.entryHeaders = entryHeaders
        NewSurvey.entryDataTypes = entryDataTypes
        NewSurvey.containsLocation = usesGPS
        NewSurvey.containsPhoto = usesPhoto
        debugPrint(NewSurvey.entryHeaders)
        do {
            //save to database
            //before I save, maybe here I run the code to make the headers the ones from the file?
            try viewContext.save()
            print("Survey Saved")
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

