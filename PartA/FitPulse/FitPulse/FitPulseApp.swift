//
//  FitPulseApp.swift
//  FitPulse
//

import SwiftUI

@main
struct FitPulseApp: App {

    @StateObject private var vm = FitnessViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DashboardView()
            }
            .environmentObject(vm)
        }
    }
}
