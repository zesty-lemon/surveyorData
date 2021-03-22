//
//  surveyorDataApp.swift
//  surveyorData
//
//  Created by Giles Lemmon on 3/16/21.
//

import SwiftUI

@main
struct surveyorDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            surveyIndexView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
