// IOS_App2App.swift

import SwiftUI

@main
struct IOS_App2App: App {
    @StateObject private var locationManager = LocationManager() // Inicjalizacja LocationManager

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager) // Przekazanie jako EnvironmentObject
        }
    }
}
