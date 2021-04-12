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
    @State private var entryAdditionFields:
        [EntryParameterView] = []
    @State var entryLat: Double = 0
    @State var entryLong: Double = 0
    //https://www.simpleswiftguide.com/how-to-present-sheet-modally-in-swiftui/
    
    var body: some View {

        NavigationView{
                VStack {
                    
                    Form{
                        if parentSurvey.containsLocation == true{
                            LocationSaveView(lat: $entryLat, long: $entryLong)
                        }
                        List(entryAdditionFields, id: \.id){ field in
                            field
                        }
                    }
                }
                .navigationBarTitle(Text("Add a sample"), displayMode: .inline)
                .navigationBarItems(leading:
                                        Button(action: {
                                            presentationMode.wrappedValue.dismiss()
                                        }) {
                                            Text("Cancel").bold()
                                        }, trailing:
                                            Button(action: {
                                                createEntry()
                                                needsRefresh = true
                                                presentationMode.wrappedValue.dismiss()
                                            }) {
                                                Text("Save").bold()
                                            })
                
        }
        .onAppear{
            setupEntry()
        }
    }
    func setupEntry(){
        for i in 0..<parentSurvey.entryHeaders.count {
            dataToAdd.append("")
            entryHeaders.append(parentSurvey.entryHeaders[i])
            entryAdditionFields.append(EntryParameterView(index: dataToAdd.count-1,entryData: $dataToAdd, entryHeaders: $entryHeaders, entryDataTypes: $parentSurvey.entryDataTypes))
        }
    }
    func createEntry(){
        let viewContext = PersistenceController.shared.container.viewContext
        let newEntry = Entry(context: viewContext)
        newEntry.timeStamp = Date()
        newEntry.entryData = dataToAdd
        newEntry.survey = parentSurvey //set reference to it's parent survey
        if parentSurvey.containsLocation == true{
            newEntry.lat = entryLat
            newEntry.long = entryLong
        }
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
