//
//  Cleaner_AppApp.swift
//  Cleaner App
//
//  Created by Vusal Nuriyev 2 on 11.09.24.
//

import SwiftUI

@main
struct Cleaner_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
