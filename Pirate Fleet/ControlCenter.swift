//
//  ControlCenter.swift
//  Pirate Fleet
//
//  Created by Jarrod Parkes on 9/2/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

struct GridLocation {
    let x: Int
    let y: Int
}

struct Ship {
    let length: Int
    let location: GridLocation
    let isVertical: Bool
    let isWooden: Bool
    
    var cells: [GridLocation] {
        get {
            let start = self.location
            let end: GridLocation = ShipEndLocation(self)
            var occupiedCells = [GridLocation]()
            for x in start.x...end.x {
                for y in start.y...end.y {
                    occupiedCells.append(GridLocation(x: x, y: y))
                }
            }
            return occupiedCells
        }
    }
    
    var hitTracker: HitTracker
    var sunk: Bool {
        get {
            var shipSunk = false
            for (_, trueFalse) in hitTracker.cellsHit {
                if trueFalse == false {
                    shipSunk = false
                    return shipSunk
                } else {
                    shipSunk = true
                }
            }
            return shipSunk
        }
    }
    init(length: Int, location: GridLocation, isVertical: Bool, hitTracker: HitTracker) {
        self.length = length
        self.location = location
        self.isVertical  = isVertical
        self.hitTracker = hitTracker
        self.isWooden = false
    }
    
    init(length: Int, location: GridLocation, isVertical: Bool, isWooden: Bool, hitTracker: HitTracker) {
        self.length = length
        self.location = location
        self.isVertical = isVertical
        self.isWooden = isWooden
        self.hitTracker = hitTracker
    }
}

protocol PenaltyCell {
    var location: GridLocation {get}
    var guaranteesHit: Bool {get set}
    var penaltyText: String {get}
}

struct Mine: PenaltyCell {
    let location: GridLocation
    var guaranteesHit: Bool
    var penaltyText: String
    
    init(location: GridLocation, penaltyText: String) {
        self.location = location
        self.penaltyText = penaltyText
        self.guaranteesHit = false
    }
    init(location: GridLocation, penaltyText: String, guaranteesHit: Bool) {
        self.location = location
        self.penaltyText = penaltyText
        self.guaranteesHit = true
    }
    
}

struct SeaMonster: PenaltyCell {
    let location: GridLocation
    var guaranteesHit: Bool
    var penaltyText: String
    
    init(location: GridLocation, penaltyText: String, guaranteesHit: Bool) {
        self.location = location
        self.penaltyText = penaltyText
        self.guaranteesHit = true
    }
}

class ControlCenter {
    
    func placeItemsOnGrid(human: Human) {
        
        let smallShip = Ship(length: 2, location: GridLocation(x: 3, y: 4), isVertical: true, hitTracker: HitTracker())
        human.addShipToGrid(smallShip)

        let mediumShip1 = Ship(length: 3, location: GridLocation(x: 0, y: 0), isVertical: false, hitTracker: HitTracker())
        human.addShipToGrid(mediumShip1)
        
        let mediumShip2 = Ship(length: 3, location: GridLocation(x: 3, y: 1), isVertical: false, hitTracker: HitTracker())
        human.addShipToGrid(mediumShip2)
        
        let largeShip = Ship(length: 4, location: GridLocation(x: 6, y: 3), isVertical: true, hitTracker: HitTracker())
        human.addShipToGrid(largeShip)
        
        let xLargeShip = Ship(length: 5, location: GridLocation(x: 7, y: 2), isVertical: true, isWooden: true, hitTracker: HitTracker())
        human.addShipToGrid(xLargeShip)
        
        let mine1 = Mine(location: GridLocation(x: 3, y: 0), penaltyText: "Mine!!!", guaranteesHit: true)
        human.addMineToGrid(mine1)
        
        let mine2 = Mine(location: GridLocation(x: 4, y: 4), penaltyText: "Mine!!!")
        human.addMineToGrid(mine2)
        
        let seamonster1 = SeaMonster(location: GridLocation(x: 5, y: 6), penaltyText: "Sea Monster!!!", guaranteesHit: false)
        human.addSeamonsterToGrid(seamonster1)
        
        let seamonster2 = SeaMonster(location: GridLocation(x: 2, y: 2), penaltyText: "Sea Monster!!!", guaranteesHit: true)
        human.addSeamonsterToGrid(seamonster2)
    }
    
    func calculateFinalScore(gameStats: GameStats) -> Int {
        
        var finalScore: Int
        
        let sinkBonus = (5 - gameStats.enemyShipsRemaining) * gameStats.sinkBonus
        let shipBonus = (5 - gameStats.humanShipsSunk) * gameStats.shipBonus
        let guessPenalty = (gameStats.numberOfHitsOnEnemy + gameStats.numberOfMissesByHuman) * gameStats.guessPenalty
        
        finalScore = sinkBonus + shipBonus - guessPenalty
        
        return finalScore
    }
}