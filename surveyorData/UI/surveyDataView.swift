//
//  surveyDataView.swift
//  surveyorData
//  Created by Giles Lemmon on 3/16/21.
//

import SwiftUI
//entries within survey
struct surveyDataView: View {
    @Environment(\.managedObjectContext) var moc //maybe replace with viewContext?
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
            if entries.count == 0 {
                VStack{
                    Text("No Samples").font(.largeTitle)
                    Text("Add a sample using the Plus button")
                    .navigationTitle(parentSurvey.surveyTitle)
                    .navigationBarItems(trailing: Button(action: {
                        showingDetail = true
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: CGFloat(Constants.iconSize)))
                    }))
                    .sheet(isPresented: $showingDetail) {
                        entryInsertion(parentSurvey: $parentSurvey, needsRefresh: $needsRefresh,parentEntryList: $entries)
                    }
                }
            }
            else {
                List{
                    ForEach(entries, id: \.id) { entry in
                        NavigationLink(destination:EntryDataView(entry: entry)
                        ){
                            HStack {
                                Text("Sample: \(entry.timeStamp)")
                            }
                        }
                    }
                    .onDelete(perform: deleteEntry(at:))
                }
                .listStyle(PlainListStyle())
                .navigationTitle(parentSurvey.surveyTitle)
                .navigationBarItems(trailing: Button(action: {
                    showingDetail = true
                }, label: {
                    Image(systemName: "plus.circle")
                        .font(.system(size: CGFloat(Constants.iconSize)))
                }))
                .sheet(isPresented: $showingDetail) {
                    entryInsertion(parentSurvey: $parentSurvey, needsRefresh: $needsRefresh,parentEntryList: $entries)
                }
            }
        }
    }
    func refresh(){
        //entries = parentSurvey.entries()
        needsRefresh = false
        print("Refreshed")
    }
    func deleteEntry(at offsets: IndexSet) {
        for index in offsets {
            let user = entries[index]
            moc.delete(user)
            entries.remove(at: index)
        }
        try? moc.save()
    }
}

struct surveyDataView_Previews: PreviewProvider {
    static var previews: some View {
        Text("No Preview Build & Run Instead")
    }
}
