//
//  entryInsertion.swift
//  surveyorData
//
//  Created by Giles Lemmon on 3/16/21.
//

import SwiftUI
//insert an entry
//I need to pass entry a survey
//make a new Entry, and then set the "survey" paramater inside entry to this current survey
struct entryInsertion: View {
    var parentSurvey: Survey
    var body: some View {
        Text("Creating Hardcoded Entry")
        Button("Create Entry") {
            createEntry()
        }
    }
    func createEntry(){
        //viewContext = where core data lives, container for it
        let viewContext = PersistenceController.shared.container.viewContext
        //make the item to be inserted
        let newEntry = Entry(context: viewContext)
        newEntry.timeStamp = Date()
        newEntry.entryData = ["1","1","1"]
        newEntry.lat = 41.7658
        newEntry.long = 72.6734
        newEntry.survey = parentSurvey //set reference to it's parent survey
        parentSurvey.addToEntry(newEntry)
    }
}

struct entryInsertion_Previews: PreviewProvider {
    static var previews: some View {
        Text ("No Preview Build Instead")
    }
}
