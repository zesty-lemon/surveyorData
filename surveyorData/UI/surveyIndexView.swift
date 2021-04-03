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
    @FetchRequest(entity: Survey.entity(), sortDescriptors: []) var surveys: FetchedResults<Survey>
    //@State var selectedSurvey: Survey!
    var body: some View {
        //navigationView Here to pass survey to surveyDataView
        NavigationView{
            List(surveys, id: \.id) { eachSurvey in
                NavigationLink(destination:surveyDataView(parentSurvey: eachSurvey)
                ){
                    HStack {
                        Text(eachSurvey.surveyTitle)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("All Surveys",displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                showingDetail = true
            }, label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
            }))
            .sheet(isPresented: $showingDetail) {
                surveyCreation()
            }
            
        }
        
    }
    
}

struct surveyIndexView_Previews: PreviewProvider {
    static var previews: some View {
        surveyIndexView()
    }
}
