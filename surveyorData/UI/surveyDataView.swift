//
//  surveyDataView.swift
//  surveyorData
//
//  Created by Giles Lemmon on 3/16/21.
//

import SwiftUI
//entries within survey
struct surveyDataView: View {
    
    //    @Binding var surveyTitle: String
    //    @FetchRequest(entity: Survey.entity(), sortDescriptors: [], predicate: NSPredicate(format: "surveyTitle == %@", surveyTitle) )
    @Binding var survey: Survey
    
    //<> = "generics" - wrapped in something else
    //   var surveys: FetchedResults<Survey>
    //  var entries: NSSet
    var body: some View {
        
        //NavigationView{
            VStack {
//                if survey.entries().isEmpty {
//                    Text(Constants.noItems)
//                        .foregroundColor(.gray)
//                        .font(.title)
//                }
                Text("Survey Data")
                    .navigationBarTitle("All Data")
                    .navigationBarItems(
                        trailing: NavigationLink(
                            destination: entryInsertion(parentSurvey: survey)
                        ) {
                            Image(systemName: "plus")
                        }
                    )
                List(survey.entries(), id: \.id) { entry in
                    HStack {
                        Text(entry.entryData[1])
                    }
                }
            }
        }
   // }
}

struct surveyDataView_Previews: PreviewProvider {
    static var previews: some View {
        Text("No Preview Build & Run Instead")
    }
}
