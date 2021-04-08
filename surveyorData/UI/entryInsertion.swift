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
    //@Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @Binding var needsRefresh: Bool
    @Binding var parentEntryList: [Entry]
    @State private var dataToAdd = [String]()
    @State private var entryHeaders: [String] = []
    @State private var entryAdditionFields: [EntryParameterView] = []
    
    
    var body: some View {
        VStack {
            //Text(parentSurvey.debugDescription)
            //Text("Creating Hardcoded Entry")
            if parentSurvey.containsPhoto == false{
                Text("No Photo")
            }
            //send to correct insertion view based on type stored in entryTypes
            //.keyboardType(.decimalPad)
            //maybe have a view for each row in entryHeaders
            Form{
                List(entryAdditionFields, id: \.id){ field in
                    field
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
                print("save point")
                createEntry()
                print("After save .needsRefresh = \(needsRefresh)")
                needsRefresh = true
                print("NeedsRefresh Should be true, it's \(needsRefresh)")
                presentationMode.wrappedValue.dismiss()
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
        .onAppear{
            setupEntry()
        }
    }

    func setupEntry(){
        for i in 0..<parentSurvey.entryHeaders.count {
            dataToAdd.append("")
            entryHeaders.append(parentSurvey.entryHeaders[i])
            entryAdditionFields.append(EntryParameterView(index: dataToAdd.count-1,entryData: $dataToAdd, entryHeaders: $entryHeaders))
        }
    }
    func createEntry(){
        let viewContext = PersistenceController.shared.container.viewContext
        let newEntry = Entry(context: viewContext)
        newEntry.timeStamp = Date()
        newEntry.entryData = dataToAdd
        newEntry.lat = 41.7658
        newEntry.long = 72.6734
        newEntry.survey = parentSurvey //set reference to it's parent survey
        parentSurvey.addToEntry(newEntry)
        parentEntryList.append(newEntry)
        do {
            //save to database
            try viewContext.save()
            
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
