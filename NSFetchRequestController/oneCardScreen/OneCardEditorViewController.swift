//
//  EditBandViewController.swift
//  NSFetchRequestController
//
//  Created by Sergey Kozlov on 23.11.2024.
//

import UIKit

class OneCardEditorViewController: UIViewController {

    var band: BandDB!
    @IBOutlet weak var bandCard: BandCardView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bandCard.editable = true
        bandCard.configure(band: band)
    }
    
    
    
    @IBAction func saveButton(_ sender: Any) {
        guard let band else { return }
        
        band.country = bandCard.countryInput.text
        band.genre = bandCard.genreInput.text
        
        let year = Int(bandCard.yearInput.text!)
        band.creationYear = Int32(year!)
        
        CoreDataStack.shared.saveContext()
    }
    
}
