//
//  surveyIndexView.swift
//  surveyorData
//
//  Created by Giles Lemmon on 3/16/21.
//

import SwiftUI
import CoreData

// see table of all different surveys
//managedContext is where data is being stored


struct surveyIndexView: View {
    @Environment(\.managedObjectContext) var moc
    @State var showingDetail = false
    @FetchRequest(entity: Survey.entity(), sortDescriptors: [], predicate:NSPredicate(format:"type == %@","Survey")) var surveys: FetchedResults<Survey>
    var body: some View {
        
        NavigationView{
            if surveys.count == 0 {
                VStack{
                Text("No Surveys").font(.largeTitle)
                Text("Make a new survey with the plus button")
                    .navigationBarTitle("All Surveys",displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: {
                        showingDetail = true
                    }, label: {
                        Image(systemName: "plus.circle")
                            //.imageScale(.large)
                            .font(.system(size: 30))
                    }))
                    .sheet(isPresented: $showingDetail) {
                        surveyCreation()
                    }
                }
            }
            else{
                List{
                    ForEach(surveys, id: \.id) { eachSurvey in
                        NavigationLink(destination:surveyDataView(parentSurvey: eachSurvey, entries: eachSurvey.entries())
                        ){
                            HStack {
                                Text(eachSurvey.surveyTitle)
                            }
                        }
                    }
                    .onDelete(perform: deleteSurvey(at:))
                }
                .listStyle(PlainListStyle())
                .navigationBarTitle("All Surveys",displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    showingDetail = true
                }, label: {
                    Image(systemName: "plus.circle")
                        //.imageScale(.large)
                        .font(.system(size: 30))
                }))
                .sheet(isPresented: $showingDetail) {
                    surveyCreation()
                }
            }
        }
    }
    func deleteSurvey(at offsets: IndexSet) {
        for eachSurvey in offsets {
            let toDelete = surveys[eachSurvey]
            moc.delete(toDelete)
        }
        try? moc.save()
    }
}

struct surveyIndexView_Previews: PreviewProvider {
    static var previews: some View {
        surveyIndexView()
    }
}
