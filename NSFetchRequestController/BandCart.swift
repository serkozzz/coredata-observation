//
//  BandCart.swift
//  NSFetchRequestController
//
//  Created by Sergey Kozlov on 23.11.2024.
//

import UIKit
import Combine

class BandCart: UIView {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var genreInput: UITextField!
    @IBOutlet weak var countryInput: UITextField!
    @IBOutlet weak var yearInput: UITextField!
    
    var editable: Bool = false {
        didSet {
            genreInput.isUserInteractionEnabled = editable
            countryInput.isUserInteractionEnabled = editable
            yearInput.isUserInteractionEnabled = editable
        }
    }
    
    var band: BandDB!
    private var cancellables = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        
        let nib = Bundle.main.loadNibNamed(String(describing: BandCart.self), owner: self, options: nil)
        if let contentView = nib?.first as? UIView {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(contentView)
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                contentView.topAnchor.constraint(equalTo: self.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
    }
    
    func configure(band: BandDB) {
        
        self.band = band
//        
//        band.publisher(for: \.country)
//                   .sink { [weak self] newCountry in
//                       guard let self = self else { return }
//                       self.updateFromBand()
//                   }
//                   .store(in: &cancellables)

        
        band.objectWillChange
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.updateFromBand()
            }
            .store(in: &cancellables)
        
        updateFromBand()
    }
    
    private func updateFromBand() {
        name.text = band.name
        genreInput.text = band.genre
        countryInput.text = band.country
        yearInput.text = String(band.creationYear)
    }
}
