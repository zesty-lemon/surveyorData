//
//  surveyDataView.swift
//  surveyorData
//
//  Created by Giles Lemmon on 3/16/21.
//

import SwiftUI
//entries within survey
struct surveyDataView: View {
    @State var parentSurvey: Survey
    @Environment(\.managedObjectContext) var moc
    @State var showingDetail = false
    
    //reqrite survey data view to show entries corresponding to a survey as a navigation view of entries, where clicking on an entry sends you to a view of that entry
    var body: some View {
        //NavigationView{
        VStack {
            Text(parentSurvey.debugDescription)
            //change this to pull from the parentSurvey built in method for doing this.  This should also fix view dynamically updating problem
            List(parentSurvey.entries(), id: \.id) { entry in
                NavigationLink(destination:EntryDataView(entry: entry)
                ){
                    HStack {
                        Text("Test")
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Survey Data")
            .navigationBarItems(trailing: Button(action: {
                showingDetail = true
            }, label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
            }))
            .sheet(isPresented: $showingDetail) {
                entryInsertion(parentSurvey: $parentSurvey)
            }
            
        //  }
        //                List(parentSurvey.entries(), id: \.id) { entry in
        //                    HStack {
        //                        Text(entry.entryData[1])
        //                    }
        //                }
        //                .listStyle(PlainListStyle())
        //                .navigationTitle("Survey Data")
        //                .navigationBarItems(trailing: Button(action: {
        //                    showingDetail = true
        //                }, label: {
        //                    Image(systemName: "plus.circle")
        //                        .imageScale(.large)
        //                }))
        //                .sheet(isPresented: $showingDetail) {
        //                    entryInsertion(parentSurvey: $parentSurvey)
        //                }
        //    }
    }
    }
}

struct surveyDataView_Previews: PreviewProvider {
    static var previews: some View {
        Text("No Preview Build & Run Instead")
    }
}
