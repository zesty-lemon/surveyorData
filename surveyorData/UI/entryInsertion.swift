//
//  entryInsertion.swift
//  surveyorData
//  Created by Giles Lemmon on 3/16/21.
//
import SwiftUI
import CoreData

struct entryInsertion: View {
    //@ObservedObject var parentSurvey = Survey()
    @Binding var parentSurvey: Survey
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Binding var needsRefresh: Bool
    @State private var dataToAdd = [String]()
    var body: some View {
        VStack {
            //Text(parentSurvey.debugDescription)
            //Text("Creating Hardcoded Entry")
//            ForEach(parentSurvey.entryHeaders){ entryField in
//                TextField("Field \(idx)", text: dataToAdd.append())
//            }
            if parentSurvey.containsPhoto == false{
                Text("No Photo")
            }
            //send to correct insertion view based on type stored in entryTypes
            //.keyboardType(.numberPad)
            //maybe have a view for each row in entryHeaders
            Form {
                ForEach(parentSurvey.entryHeaders, id: \.self){ entryField in
                    Text(entryField)
                }
            }
        }
        //save and cancel buttons
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
                createEntry()
                needsRefresh = true
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
    func createEntry(){
        
        let newEntry = Entry(context: viewContext)
        newEntry.timeStamp = Date()
        newEntry.entryData = ["Kitten","Football","Meow"]
        newEntry.lat = 41.7658
        newEntry.long = 72.6734
        newEntry.survey = parentSurvey //set reference to it's parent survey
        parentSurvey.addToEntry(newEntry)
        
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
