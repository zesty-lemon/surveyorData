//
//  surveyDataView.swift
//  surveyorData
//  Created by Giles Lemmon on 3/16/21.
//

import SwiftUI
//entries within survey
struct surveyDataView: View {
    @State var parentSurvey: Survey
    @Environment(\.managedObjectContext) var moc
    @State var showingDetail = false
    @State var entries: [Entry]
    @State var needsRefresh: Bool = false{
        didSet{
            if needsRefresh {
                refresh()
                needsRefresh = false
            }
        }
    }
    var body: some View {
        //NavigationView{
        VStack {
            //Text(parentSurvey.debugDescription)
            List(parentSurvey.entries(), id: \.id) { entry in
                NavigationLink(destination:EntryDataView(entry: entry)
                ){
                    HStack {
                        Text("Test")
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
                entryInsertion(parentSurvey: $parentSurvey, needsRefresh: $needsRefresh)
            }
        }
    }
    
    func refresh(){
        entries = parentSurvey.entries()
    }
}

struct surveyDataView_Previews: PreviewProvider {
    static var previews: some View {
        Text("No Preview Build & Run Instead")
    }
}
