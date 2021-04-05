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
                    Text("Data in Survey")
                        .font(.title)
                    TextField("Survey Name:",text:$surveyTitle)
                    Toggle("Include Photo", isOn: $usesPhoto)
                    Toggle("Include GPS Location", isOn: $usesGPS)
                    List(extraFields, id: \.id) { field in
                        field
                    }
                    Button("Add Field"){
                        entryDataTypes.append("")
                        entryHeaders.append("")
                        extraFields.append(ExtraFieldsView(index: entryHeaders.count-1,entryDataTypes: $entryDataTypes, entryHeaders: $entryHeaders))
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
            }
        }
    }
    
    func createSurvey() -> Void{
        let NewSurvey = Survey(context: viewContext)
        NewSurvey.surveyTitle = surveyTitle
        print("headers")
        print(entryHeaders)
        print("dataTypes:")
        print(entryDataTypes)
        NewSurvey.entryHeaders = entryHeaders
        NewSurvey.entryDataTypes = entryDataTypes
        NewSurvey.containsLocation = usesGPS
        NewSurvey.containsPhoto = usesPhoto
        NewSurvey.type = "Survey"
        
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

