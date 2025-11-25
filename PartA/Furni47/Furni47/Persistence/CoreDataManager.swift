import Foundation
import CoreData

// MARK: - Core Data Manager
/// Singleton class to manage Core Data operations
class CoreDataManager {
    static let shared = CoreDataManager()

    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Furni47")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Save Context
    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    // MARK: - Save Furniture Item
    /// Saves a furniture item to Core Data
    func saveFurniture(item: FurnitureItem) {
        let context = viewContext
        let entity = FurnitureEntity(context: context)
        entity.id = item.id
        entity.name = item.name
        entity.modelName = item.modelName
        entity.timestamp = item.timestamp
        saveContext()
    }

    // MARK: - Fetch All Furniture
    /// Fetches all saved furniture items from Core Data
    func fetchAllFurniture() -> [FurnitureItem] {
        let request: NSFetchRequest<FurnitureEntity> = FurnitureEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FurnitureEntity.timestamp, ascending: false)]

        do {
            let entities = try viewContext.fetch(request)
            return entities.map { FurnitureItem(from: $0) }
        } catch {
            print("Error fetching furniture: \(error)")
            return []
        }
    }

    // MARK: - Delete Furniture
    /// Deletes a furniture item from Core Data
    func deleteFurniture(withId id: UUID) {
        let request: NSFetchRequest<FurnitureEntity> = FurnitureEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let results = try viewContext.fetch(request)
            for object in results {
                viewContext.delete(object)
            }
            saveContext()
        } catch {
            print("Error deleting furniture: \(error)")
        }
    }

    // MARK: - Check if Item Exists
    /// Checks if a furniture item is already saved
    func isFurnitureSaved(withId id: UUID) -> Bool {
        let request: NSFetchRequest<FurnitureEntity> = FurnitureEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let count = try viewContext.count(for: request)
            return count > 0
        } catch {
            print("Error checking furniture: \(error)")
            return false
        }
    }
}
