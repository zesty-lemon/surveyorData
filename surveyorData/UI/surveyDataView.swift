//
//  surveyDataView.swift
//  surveyorData
//  Created by Giles Lemmon on 3/16/21.
//

import SwiftUI
//entries within survey
struct surveyDataView: View {
    @State var parentSurvey: Survey
    @State var showingDetail = false
    @State var entries: [Entry]
    @State var needsRefresh: Bool = true {
        didSet{
            print("It's set")
            if needsRefresh {
                print("needs refresh")
                refresh()
                needsRefresh = false
            }
        }
    }
    var body: some View {
        VStack {
            //Text(parentSurvey.debugDescription)
            List(entries, id: \.id) { entry in
                NavigationLink(destination:EntryDataView(entry: entry)
                ){
                    HStack {
                        Text("Entry")
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle(parentSurvey.surveyTitle)
            .navigationBarItems(trailing: Button(action: {
                showingDetail = true
            }, label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
            }))
            .sheet(isPresented: $showingDetail) {
                entryInsertion(parentSurvey: $parentSurvey, needsRefresh: $needsRefresh,parentEntryList: $entries)
            }
        }
    }
    
    func refresh(){
        //entries = parentSurvey.entries()
        needsRefresh = false
        print("Refreshed")
    }
}

struct surveyDataView_Previews: PreviewProvider {
    static var previews: some View {
        Text("No Preview Build & Run Instead")
    }
}
