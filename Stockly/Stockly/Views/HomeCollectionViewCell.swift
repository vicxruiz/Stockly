//
//  HomeCollectionViewCell.swift
//  Stockly
//
//  Created by Victor  on 6/17/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation
import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var sectorButton: UIButton!
    weak var delegate: SectorCollectionViewCellDelegate?
    var sector: Sector? {
        didSet {
            updateViews()
        }
    }
    var isChosenCell: HomeCollectionViewCell?
    
    func updateViews() {
        guard let sector = sector else {
            return}
        print("sector")
        sectorButton.setTitle(sector.name, for: .normal)
        if sector.isChosen {
            sectorButton.setTitleColor(Service.stocklyDesignTheme, for: .normal)
                isChosenCell = self
        }
    }
    
    @IBAction func sectorButtonPressed(_ sender: Any) {
        guard let cell = isChosenCell else {
            print("no chosen cell")
            return
        }
        delegate?.toggleHasBeenChanged(for: self, for: cell)
    }
}
