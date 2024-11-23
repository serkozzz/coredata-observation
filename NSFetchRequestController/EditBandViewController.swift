//
//  EditBandViewController.swift
//  NSFetchRequestController
//
//  Created by Sergey Kozlov on 23.11.2024.
//

import UIKit

class EditBandViewController: UIViewController {

    var band: BandDB!
    @IBOutlet weak var bandCart: BandCart!
    override func viewDidLoad() {
        super.viewDidLoad()
        bandCart.editable = true
        bandCart.configure(band: band)
    }
    
    
    
    @IBAction func saveButton(_ sender: Any) {
        guard let band else { return }
        
        band.country = bandCart.countryInput.text
        band.genre = bandCart.genreInput.text
        
        let year = Int(bandCart.yearInput.text!)
        band.creationYear = Int32(year!)
        
        CoreDataStack.shared.saveContext()
    }
    
}
