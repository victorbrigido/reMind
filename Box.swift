//
//  Box+CoreDataClass.swift
//  reMind
//
//  Created by Pedro Sousa on 25/09/23.
//
//

import Foundation
import CoreData

@objc(Box)
public final class Box: NSManagedObject, Identifiable {
    
}


extension Box {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Box> {
        return NSFetchRequest<Box>(entityName: "Box")
    }


    @NSManaged public var identifier: UUID?
    @NSManaged public var name: String?
    @NSManaged public var rawTheme: Int16
    @NSManaged public var terms: NSSet?

}

// MARK: Generated accessors for terms
extension Box {

    @objc(addTermsObject:)
    @NSManaged public func addToTerms(_ value: Term)

    @objc(removeTermsObject:)
    @NSManaged public func removeFromTerms(_ value: Term)

    @objc(addTerms:)
    @NSManaged public func addToTerms(_ values: NSSet)

    @objc(removeTerms:)
    @NSManaged public func removeFromTerms(_ values: NSSet)
    
    

}


extension Box: CoreDataModel {
    var theme: reTheme {
        return reTheme(rawValue: Int(self.rawTheme)) ?? reTheme.lavender
    }

    var numberOfTerms: Int { self.terms?.count ?? 0 }
    
    
}


enum reTheme: Int {
    case aquamarine = 2
    case mauve = 0
    case lavender = 1

    var name: String {
        switch self {
        case .aquamarine:
            return "aquamarine"
        case .mauve:
            return "mauve"
        case .lavender:
            return "lavender"
        }
    }
}


extension Box {
    static func createBox(name: String,
                          theme: Int,
                          context: NSManagedObjectContext)
    
    {
        let newBox = Box(context: context)
        newBox.name = name
        newBox.identifier = UUID()
        newBox.rawTheme = Int16(theme)
        
        do {
            try context.save()
            print("New Box created and saved: \(newBox)")
        } catch {
            print("Error creating or saving box: \(error.localizedDescription)")
        }
    }
    
    func deleteBox() {
        guard let context = managedObjectContext else { return }
        context.delete(self)
        do {
            try context.save()
            print("Box deleted: \(self)")
        } catch {
            print("Error deleting box: \(error.localizedDescription)")
        }
    }
    
    
}

extension Box {
    func filteredTerms(searchText: String) -> [Term] {
        guard let boxTerms = terms as? Set<Term> else {
            return []
        }

        let sortedTerms = Array(boxTerms).sorted { lhs, rhs in
            (lhs.value ?? "") < (rhs.value ?? "")
        }

        if searchText.isEmpty {
            return sortedTerms
        } else {
            return sortedTerms.filter { ($0.value ?? "").contains(searchText) }
        }
    }
}


extension Box {
    func fetchTerms() -> [Term] {
        guard let loadedBox = managedObjectContext?.object(with: objectID) as? Box else {
            return []
        }

        let boxTerms = loadedBox.terms as? Set<Term>
        return boxTerms?.sorted { lhs, rhs in
            (lhs.value ?? "") < (rhs.value ?? "")
        } ?? []
    }
}

extension Box {
    func editBox(name: String,
                 theme: Int,
                 context: NSManagedObjectContext)
    {
        // Cerfifica de que a instância da box está sendo carregada no contexto
        guard let loadedBox = context.object(with: self.objectID) as? Box else {
            print("Error loading the Box from the context.")
            return
        }

        // Modifica os atributos da box carregada
        loadedBox.name = name
        loadedBox.rawTheme = Int16(theme)

        do {
            try context.save()
            print("Box edited and saved: \(loadedBox)")
        } catch {
            print("Error editing or saving box: \(error.localizedDescription)")
        }
    }


    
}








