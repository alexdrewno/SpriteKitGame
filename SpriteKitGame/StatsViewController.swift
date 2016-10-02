//
//  StatsViewController.swift
//  SpriteKitGame
//
//  Created by Ty Victorson on 10/2/16.
//  Copyright © 2016 Alex Drewno. All rights reserved.
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
        KDLabel.text = "K/D: \(totalKills/totalDeaths)"
        totalKillsLabel.text = "Total Kills: \(totalKills)"
        totalDeathsLabel.text = "Total Deaths: \(totalDeaths)"
        gamesWonLabel.text = "Games Won: \(gamesWon)"
        gamesLostLabel.text = "Games Lost: \(gamesLost)"
    }

}
