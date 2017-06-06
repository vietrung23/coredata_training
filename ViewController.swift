//
//  ViewController.swift
//  CoreDataTraining
//
//  Created by Nguyen Van TRUNG on 6/5/17.
//  Copyright © 2017 altplus. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - DataManager
    
    fileprivate var datamanager = DataManager(modelName: "Note")
    
    //MARK: - 
    
    
    
    fileprivate lazy var fetchedResultController: NSFetchedResultsController<Note> = {
        //Initilize Fetch Request
        let fetchRequest: NSFetchRequest = Note.fetchRequest()
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "updateAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initilize Fetched Result Controller
        guard let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                               managedObjectContext: self.datamanager.managedObjectContext,
                                                               sectionNameKeyPath: nil,
                                                               cacheName: nil)
            as? NSFetchedResultsController<Note> else {
                   fatalError("Error")
        }
        
        // Configure Fetched Result Controller
        fetchResultController.delegate = self
        
        return fetchResultController
    }()

    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
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
        //
    }
}

extension ViewController: UITableViewDataSource {
    
}

extension ViewController: UITableViewDelegate {
    
}

