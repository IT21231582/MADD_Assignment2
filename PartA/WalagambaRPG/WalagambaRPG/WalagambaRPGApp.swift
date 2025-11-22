import SwiftUI
import CoreData

@main
struct WalagambaRPGApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            KingdomDashboardView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
