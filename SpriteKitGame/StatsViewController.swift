//
//  StatsViewController.swift
//  SpriteKitGame
//
//  Created by Ty Victorson on 10/2/16.
//  Copyright © 2016 Alex Drewno, Ty Victorson. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {

    @IBOutlet weak var KDLabel: UILabel!
    @IBOutlet weak var totalKillsLabel: UILabel!
    @IBOutlet weak var totalDeathsLabel: UILabel!
    @IBOutlet weak var gamesWonLabel: UILabel!
    @IBOutlet weak var gamesLostLabel: UILabel!
    var kd = 0.0
    var totalKills = 0
    var totalDeaths = 0
    var gamesWon = 0
    var gamesLost = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (totalKills == 0 && totalDeaths == 0) {
            kd = 0
        } else if (totalDeaths == 0){
            kd = Double(totalKills)
        }
        else {
            kd = Double(totalKills / totalDeaths)
        }
        KDLabel.text = "K/D: \(kd)"
        totalKillsLabel.text = "Total Kills: \(totalKills)"
        totalDeathsLabel.text = "Total Deaths: \(totalDeaths)"
        gamesWonLabel.text = "Games Won: \(gamesWon)"
        gamesLostLabel.text = "Games Lost: \(gamesLost)"
    }

}
