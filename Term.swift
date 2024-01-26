//
//  Term+CoreDataProperties.swift
//  reMind
//
//  Created by Pedro Sousa on 25/09/23.
//
//

import Foundation
import CoreData

@objc(Term)
public final class Term: NSManagedObject {
     
}

extension Term {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Term> {
        return NSFetchRequest<Term>(entityName: "Term")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var identifier: UUID?
    @NSManaged public var lastReview: Date?
    @NSManaged public var meaning: String?
    @NSManaged public var rawSRS: Int16 
    @NSManaged public var rawTheme: Int16
    @NSManaged public var value: String?
    @NSManaged public var boxID: Box?

}

extension Term: CoreDataModel {
    var srs: SpacedRepetitionSystem {
        return SpacedRepetitionSystem(rawValue: Int(rawSRS)) ?? SpacedRepetitionSystem.first
    }

    var theme: reTheme {
        return reTheme(rawValue: Int(self.rawTheme)) ?? reTheme.lavender
    }
    
    
    
}

enum SpacedRepetitionSystem: Int {
    case none = 0
    case first = 1
    case second = 2
    case third = 3
    case fourth = 5
    case fifth = 8
    case sixth = 13
    case seventh = 21
}

extension Term {
    func saveTerm(value: String,
                  meaning: String,
                  box: Box,
                  context: NSManagedObjectContext
    ) {
       
            let newTerm = Term(context: context)
            
            newTerm.identifier = UUID()
            newTerm.value = value
            newTerm.meaning = meaning
            newTerm.rawSRS = 0
            newTerm.rawTheme = 0
            newTerm.creationDate = Date()
            newTerm.lastReview = Date()
            newTerm.boxID = box
            
            box.addToTerms(newTerm) // Adiciona o novo termo à caixa
            
            do {
                try context.save() // Salva o contexto para persistir as mudanças
                print("Term saved successfully: \(value)")
                print("New Term - Value: \(newTerm.value ?? "Unknown"), Meaning: \(newTerm.meaning ?? "Unknown"), identifier: \(newTerm)")
            } catch {
                print("Error saving term: \(error.localizedDescription)")
            }
        }
    }


extension Term {
    func deleteTerm(context: NSManagedObjectContext) {
        context.delete(self)
        do {
            try context.save()
            print("Term deleted successfully")
        } catch {
            print("Error deleting term: \(error.localizedDescription)")
        }
    }
}


extension Term {
    func editTerm(value: String,
                  meaning: String,
                  termID: UUID,  //identificador do termo a ser editado
                  context: NSManagedObjectContext)
    {
        // Certifica de que o identificador do termo atual corresponde ao identificador fornecido
        guard self.identifier == termID else {
            print("Error: Attempting to edit the wrong term.")
            return
        }

        self.value = value
        self.meaning = meaning

        do {
            try context.save()
            print("Term edited successfully: \(value)")
            print("Edited Term - Value: \(self.value ?? "Unknown"), Meaning: \(self.meaning ?? "Unknown"), identifier: \(self)")
        } catch {
            print("Error editing term: \(error.localizedDescription)")
        }
    }
}

