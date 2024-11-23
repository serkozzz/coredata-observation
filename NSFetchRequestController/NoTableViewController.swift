//
//  ViewController.swift
//  NSFetchRequestController
//
//  Created by Sergey Kozlov on 22.11.2024.
//

import UIKit
import CoreData

class NoTableViewController: UIViewController {

    
    @IBOutlet weak var bandCartView: BandCart!
    var bandToSHow: BandDB!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bandCartView.editable = false
        let fetch = NSFetchRequest<BandDB>(entityName: String(describing: BandDB.self))
        do {
            bandToSHow = try CoreDataStack.shared.managedContext.fetch(fetch).first!
            bandCartView.configure(band: bandToSHow)
        }
        catch {
            print("couldn't fetch")
        }
        
        
    }

    @IBAction func button(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editBandVC = (storyboard.instantiateViewController(withIdentifier: "EditBandViewController") as! EditBandViewController)
        editBandVC.band = bandToSHow
        
        self.present(editBandVC, animated: true)
        
//        bandToSHow.country = bandToSHow.country!  + " Russia"
//        CoreDataStack.shared.saveContext()
    }
    
}

