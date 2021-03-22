//
//  startScreen.swift
//  surveyorData
//
//  Created by Giles Lemmon on 3/17/21.
//

import SwiftUI

struct startScreen: View {
    var body: some View {
        NavigationView {
            Text ("Useless filler")
            .navigationBarTitle("Surveys")
            .navigationBarItems(
                trailing: NavigationLink(
                    destination: surveyIndexView()
                ) {
                    Image(systemName: "plus")
                }
            )
        }
    }
}

struct startScreen_Previews: PreviewProvider {
    static var previews: some View {
        startScreen()
    }
}

