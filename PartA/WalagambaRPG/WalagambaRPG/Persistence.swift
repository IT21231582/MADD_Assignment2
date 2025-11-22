import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create 10 mock records for SwiftUI previews
        for _ in 0..<10 {
            let record = KingdomRecord(context: viewContext)
            record.timestamp = Date()
            record.peopleHappiness = Int16(Int.random(in: 10...90))
            record.templeRespect = Int16(Int.random(in: 10...90))
            record.armyStrength = Int16(Int.random(in: 10...90))
            record.foodSupply = Int16(Int.random(in: 10...90))
            record.treasury = Int16(Int.random(in: 20...200))
            record.prosperity = Int16(Int.random(in: 10...100))
        }

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Preview CoreData error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // Must match your .xcdatamodeld file name
        container = NSPersistentContainer(name: "WalagambaRPG")

        if inMemory {
            // Use RAM instead of disk
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("CoreData load error \(error), \(error.userInfo)")
            }
        }

        // Auto-merge updates between contexts
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
