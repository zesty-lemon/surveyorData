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
    @State private var alertIsPresented = false
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
                            .font(.system(size: CGFloat(Constants.iconSize)))
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
//                    .alert(isPresented: $alertIsPresented,
//                           content: {
//                            Alert(title: Text("Delete Survey?"), message: Text("Are you sure you want to delete this survey and all its data? This cannot be undone"), dismissButton: .default(Text("Delete")))
//                           })
                }
                
                .listStyle(PlainListStyle())
                .navigationBarTitle("My Surveys",displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    showingDetail = true
                }, label: {
                    Image(systemName: "plus.circle")
                        //.imageScale(.large)
                        .font(.system(size: CGFloat(Constants.iconSize)))
                }))
                .sheet(isPresented: $showingDetail) {
                    surveyCreation()
                }
            }
        }
    }
    func callDelete(at offsets: IndexSet){
        
    }
    func deleteSurvey(at offsets: IndexSet) {
        //self.alertIsPresented = true
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
