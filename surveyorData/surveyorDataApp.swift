//
//  surveyorDataApp.swift
//  surveyorData
//
//  Created by Giles Lemmon on 3/16/21.
//
//
import SwiftUI

@main

struct surveyorDataApp: App {
    @Environment(\.scenePhase) var scenePhase //optional, maybe remove later
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            surveyIndexView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        //optional, maybe remove later
//        .onChange(of: scenePhase) { _ in
//            persistenceController.save()
//        }
    }
}
