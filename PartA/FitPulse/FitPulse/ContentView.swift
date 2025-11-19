//
//  ContentView.swift
//  FitPulse
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            DashboardView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(FitnessViewModel())
}
