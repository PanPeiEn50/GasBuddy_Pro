//
//  GasBuddyProApp.swift
//  GasBuddyPro
//
//  Created by David on 11/20/23.
//

import SwiftUI

@main
struct GasBuddyProApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView(webVM: jsonWebVM())
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
