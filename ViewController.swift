//
//  ViewController.swift
//  CoreDataTraining
//
//  Created by Nguyen Van TRUNG on 6/5/17.
//  Copyright © 2017 altplus. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - DataManager
    
    fileprivate var dataManager = DataManager(modelName: "Notes")
    
    //MARK: - 
    
    
    
    fileprivate lazy var fetchedResultController: NSFetchedResultsController<Note> = {
        //Initilize Fetch Request
        let fetchRequest: NSFetchRequest = Note.fetchRequest()
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initilize Fetched Result Controller
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                               managedObjectContext: self.dataManager.managedObjectContext,
                                                               sectionNameKeyPath: nil,
                                                               cacheName: nil)
        
        // Configure Fetched Result Controller
        fetchResultController.delegate = self
        
        return fetchResultController
    }()

    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Save Note")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "showDetail":
            
            break
        default:
            print("Unknown Segue")
        }
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = newIndexPath, let cell = tableView.cellForRow(at: indexPath) {
                self.configureCell(cell, at: indexPath)
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break
        }
    }
}


extension ViewController: UITableViewDataSource {
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sectionsCount = fetchedResultController.sections?.count else {
            return 0
        }
        
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultController.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "noteCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        guard let noteCell = cell else {
            fatalError("Error cell")
        }
        
        self.configureCell(noteCell, at: indexPath)
        return noteCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionName = fetchedResultController.sections?[section].name else {
            return ""
        }
        
        return sectionName
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Fetch Note
            let note = fetchedResultController.object(at: indexPath)
            
            // Delete Note
            fetchedResultController.managedObjectContext.delete(note)
            
            do {
                try fetchedResultController.managedObjectContext.save()
            } catch {
                print("Unable to save")
            }
        }
    }
    
    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let note = fetchedResultController.object(at: indexPath)
        
        cell.textLabel?.text = note.value(forKey: "title") as? String
        cell.accessoryType = .disclosureIndicator
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

