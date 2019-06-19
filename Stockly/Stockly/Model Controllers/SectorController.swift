//
//  SectorController.swift
//  Stockly
//
//  Created by Victor  on 6/17/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation

class SectorController {
    var stockCollection = ["Technology", "Health Care", "Most Active", "Energy", "Real Estate", "Utilities"]
    var sectors: [Sector] = []
    
    init() {
        addSector()
    }
    
    func addSector() {
        for element in stockCollection {
            sectors.append(Sector(name: element))
        }
    }
    
    func updateSectors(sector1: Sector, sector2: Sector) {
        guard let index1 = sectors.index(of: sector1) else {
            print("no index of sector1")
            return
        }
        guard let index2 = sectors.index(of: sector2) else {
            print("no index of sector2")
            return
        }
        var updatedSector1 = sectors[index1]
        updatedSector1.isChosen = true
        sectors[index1] = updatedSector1
        
        var updatedSector2 = sectors[index2]
        updatedSector2.isChosen = false
        sectors[index2] = updatedSector2
    }
}
