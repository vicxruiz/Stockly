//
//  HomeCollectionViewController.swift
//  Stockly
//
//  Created by Victor  on 6/17/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation
import UIKit
class HomeCollectionViewController: UICollectionViewController, SectorCollectionViewCellDelegate{
    
    var sectorController = SectorController()
    
    func toggleHasBeenChanged(for cell: HomeCollectionViewCell, for cell2: HomeCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            print("no index Path")
            return}
        guard let indexPath2 = collectionView.indexPath(for: cell2) else {
            print("no index Path")
            return}
        let sector1 = sectorController.sectors[indexPath.row]
        let sector2 = sectorController.sectors[indexPath2.row]
        sectorController.updateSectors(sector1: sector1, sector2: sector2)
        print("update Sector")
        collectionView.reloadItems(at: [indexPath])
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectorController.sectors.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectorCell", for: indexPath) as! HomeCollectionViewCell
        var sector = sectorController.sectors[indexPath.row]
        if sector.name == "Technology" {
            sector.isChosen = true
        }
        sectorCell.sector = sector
        sectorCell.delegate = self
        return sectorCell
    }
    
}
