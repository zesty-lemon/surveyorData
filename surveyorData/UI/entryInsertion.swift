//
//  entryInsertion.swift
//  surveyorData
//
//  Created by Giles Lemmon on 3/16/21.
//

import SwiftUI
struct entryInsertion: View {
    //@ObservedObject var parentSurvey = Survey()
    @Binding var parentSurvey: Survey
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            Text(parentSurvey.debugDescription)
            Text("Creating Hardcoded Entry")
        }
        Button("Create Entry") {
            createEntry()
        }
        
    }
    func createEntry(){
        //viewContext = where core data lives, container for it
        //this has to change
        
        //this has to change now, I am making nill entries.
        //https://developer.apple.com/forums/thread/74186
        //need to fetch? result and then add to it
        //I am creating a blank one somehow
        //let viewContext = PersistenceController.shared.container.viewContext
        //make the item to be inserted
        
        let newEntry = Entry(context: viewContext)
        newEntry.timeStamp = Date()
        newEntry.entryData = ["Kitten","Football","Meow"]
        newEntry.lat = 41.7658
        newEntry.long = 72.6734
        newEntry.survey = parentSurvey //set reference to it's parent survey

        //parentSurvey.addToEntry(newEntry)
        do {
            //save to database
            
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("ERROR: ",error)
        }

    }
}

struct entryInsertion_Previews: PreviewProvider {
    static var previews: some View {
        Text ("No Preview Build Instead")
    }
}
