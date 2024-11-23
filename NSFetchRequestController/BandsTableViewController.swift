//
//  BandsTableViewController.swift
//  NSFetchRequestController
//
//  Created by Sergey Kozlov on 22.11.2024.
//

import UIKit
import CoreData

class BandsTableViewController: UITableViewController {
    
    lazy var fetchedResultsController: NSFetchedResultsController<BandDB> = {
        //1
        let fetchRequest: NSFetchRequest<BandDB> = BandDB.fetchRequest()
        
        //       let sort = NSSortDescriptor(key: #keyPath(BandDB.name), ascending: true)
        //       fetchRequest.sortDescriptors = [sort]
        
        let genreSort = NSSortDescriptor(key: #keyPath(BandDB.genre), ascending: true)
        let countrySort = NSSortDescriptor(key: #keyPath(BandDB.country), ascending: false)
        let yearSort = NSSortDescriptor(key: #keyPath(BandDB.creationYear), ascending: true)
        
        fetchRequest.sortDescriptors = [genreSort, countrySort, yearSort]
        
        //2
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataStack.shared.managedContext,
            sectionNameKeyPath: #keyPath(BandDB.genre),
            cacheName: "bands")
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
        tableView.register(CustomCell.self, forCellReuseIdentifier: "myCell")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name ?? ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CustomCell
        
        // Configure the cell...
        configure(cell: cell, at: indexPath)
        return cell
    }
    
    private func configure(cell: CustomCell, at indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        var cfg = cell.defaultContentConfiguration()
        cfg.text = item.name
        cfg.secondaryText = item.genre
        cell.contentConfiguration = cfg
    }
    @IBAction func addBandtap(_ sender: Any) {
        addBands()
    }
}


extension BandsTableViewController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!) as! CustomCell
            configure(cell: cell, at: indexPath!)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //        tableView.reloadData()
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default: break
        }
        
    }
    
    
}

// MARK: - IBActions
extension BandsTableViewController {
    
    func addBands() {
        let alert = UIAlertController(title: "Secret Team", message: "Add a new team", preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Band Name"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "genre"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            guard let nameTextField = alert.textFields?.first, let genreField = alert.textFields?.last else {
                return
            }
            
            let band = BandDB(context: CoreDataStack.shared.managedContext)
            
            band.name = nameTextField.text
            band.genre = genreField.text
            band.country = "Russia"
            band.creationYear = 1989
            CoreDataStack.shared.saveContext()
        }
        
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        present(alert, animated: true)
        
    }
    
}



class CustomCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
