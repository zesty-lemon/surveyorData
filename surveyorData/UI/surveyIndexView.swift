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
    @FetchRequest(entity: Survey.entity(), sortDescriptors: []) var surveys: FetchedResults<Survey>
    @State var selectedSurvey: Survey!
    var body: some View {
        //navigationView Here to pass survey to surveyDataView
        
        NavigationView{
            VStack {
                Text("Index")
                    .navigationBarTitle("All Surveys")
                    .navigationBarItems(
                        trailing: NavigationLink(
                            destination: surveyCreation()
                        ) {
                            Image(systemName: "plus")
                        }
                    )
                List(surveys, id: \.id) { survey in
                    NavigationLink(destination:surveyDataView(survey: survey)){
                        HStack {
                            Text(survey.surveyTitle)
                        }
                    }
                }
            }
        }
        
    }
    
}

struct surveyIndexView_Previews: PreviewProvider {
    static var previews: some View {
        surveyIndexView()
    }
}
