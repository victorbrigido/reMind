//
//  BoxViewModel.swift
//  reMind
//
//  Created by Pedro Sousa on 17/07/23.
//

import Foundation
import CoreData

class BoxViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    @Published var boxes: [Box] = []
    @Published var numberOfTerms: Int = 0

    private var fetchedResultsController: NSFetchedResultsController<Box>!

    override init() {
        super.init()
        setupFetchedResultsController()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetchedObjects = controller.fetchedObjects as? [Box] {
            self.boxes = fetchedObjects
        }
    }

    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Box> = Box.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataStack.shared.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
            if let fetchedObjects = fetchedResultsController.fetchedObjects {
                self.boxes = fetchedObjects
            }
        } catch {
            // Handle fetch error
            print("Error fetching: \(error)")
        }
    }

    func getNumberOfPendingTerms(of box: Box) -> String {
        let term = box.terms as? Set<Term> ?? []
        let today = Date()
        let filteredTerms = term.filter { term in
            let srs = Int(term.rawSRS)
            guard let lastReview = term.lastReview,
                  let nextReview = Calendar.current.date(byAdding: .day, value: srs, to: lastReview)
            else { return false }

            return nextReview <= today
        }

        return filteredTerms.count == 0 ? "" : "\(filteredTerms.count)"
    }

}






