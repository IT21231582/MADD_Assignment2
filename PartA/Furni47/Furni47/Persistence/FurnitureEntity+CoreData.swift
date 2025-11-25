import Foundation
import CoreData

@objc(FurnitureEntity)
public class FurnitureEntity: NSManagedObject {}

extension FurnitureEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FurnitureEntity> {
        return NSFetchRequest<FurnitureEntity>(entityName: "FurnitureEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var modelName: String?
    @NSManaged public var timestamp: Date?
}
