//
//  surveyCreation.swift
//  surveyorData
//
//  Created by Giles Lemmon on 3/16/21.
//

import SwiftUI
//insert a survey

struct surveyCreation: View {
    @State private var surveyTitle = ""
    @State private var usesGPS = true
    @State private var usesPhoto = true
    @State private var extraFields: [ExtraFieldsView] = []
    @State private var entryDataTypes = ["String","Int","Int"]
    @State private var entryHeaders = ["Species","Age","Weight"]
    var body: some View {
        
        VStack {
            //@State private var headersToAdd: [String]
            Form {
                Section {
                    //why do I have to use $ signs
                    
                    Text("Data in Survey")
                        .font(.title)
                    TextField("Survey Name:",text:$surveyTitle)
                    Toggle("Include Photo", isOn: $usesPhoto)
                    Toggle("Include GPS Location", isOn: $usesGPS)
                    Button("Add Field"){
                        //do nothing
                    }
                }
            }
            
            Button(action: {
                createSurvey()
                }) {
                    Text("Create Survey")
            }
            .padding()
            .overlay(
                RoundedRectangle(
                    cornerRadius: 20)
                    .stroke())
            .padding()
            //here I need some way of adding text to my list, and then displaying the list as I add it.  Then this is passed to
        }
    }
    //at the top of the page, maybe some toggles for "include location", "include GPS", "include photo"
    //maybe constants can store the list of allowable fields, and then when you pick the plus symbol you get a screen of all possible things to pick from.  For now maybe toggles next to each one?
    
    func createSurvey() -> Void{
        //viewContext = where core data lives, container for it
        let viewContext = PersistenceController.shared.container.viewContext
        //make the item to be inserted
        let survey = Survey(context: viewContext)
        survey.surveyTitle = surveyTitle
        survey.entryHeaders = ["Species","Age","Weight"]
        survey.entryDataTypes = ["String","Int","Int"]
        survey.containsLocation = usesGPS
        survey.containsPhoto = usesPhoto
        do {
            //save to database
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    func hardcodedCreateSurvey(){
        //viewContext = where core data lives, container for it
        let viewContext = PersistenceController.shared.container.viewContext
        //make the item to be inserted
        let survey = Survey(context: viewContext)
        survey.surveyTitle = "TestiBoi"
        survey.entryHeaders = entryHeaders
        survey.entryDataTypes = entryDataTypes
        survey.containsLocation = true
        survey.containsPhoto = true
        do {
            //save to database
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
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

