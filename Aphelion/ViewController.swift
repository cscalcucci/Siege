//
//  ViewController.swift
//  Aphelion
//
//  Created by Christopher Scalcucci on 9/11/15.
//  Copyright © 2015 Aphelion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Player
    @IBOutlet weak var playerAvatar: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerLevel: UILabel!
    @IBOutlet weak var playerCurrentHP: UILabel!
    @IBOutlet weak var playerHealthBar: UIProgressView!
    @IBOutlet weak var playerExpBar: UIProgressView!
    
    //Mob
    @IBOutlet weak var mobAvatar: UIImageView!
    @IBOutlet weak var mobName: UILabel!
    @IBOutlet weak var mobLevel: UILabel!
    @IBOutlet weak var mobCurrentHP: UILabel!
    @IBOutlet weak var mobHealthBar: UIProgressView!

    @IBOutlet weak var activityField: UITextView!
    @IBOutlet weak var attackBtn: UIButton!

    var player : Player!
    var mob : Mob!

    var turnCount : Float = 0

    var gameOver : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.player = Player(name:"Chris")
        self.mob = Mob(name:"Fuccboi", level:1)

        activityField.text = "\(player.name) has encountered a wild \(mob.name)! \n"

        NSNotificationCenter.defaultCenter().addObserverForName("GameOver", object: nil, queue: NSOperationQueue.mainQueue()) { notification in

            self.activityField.text = self.activityField.text + "\(self.player.name) was killed by \(self.mob.name)! \n"
            self.attackBtn.backgroundColor = UIColor.blueColor()
            self.attackBtn.setTitle("Restart", forState: .Normal)
            self.attackBtn.tag = 1
        }

        NSNotificationCenter.defaultCenter().addObserverForName("GameWon", object: nil, queue: NSOperationQueue.mainQueue()) { notification in

            self.activityField.text = self.activityField.text + "\(self.player.name) defeated \(self.mob.name)! \n"
            self.attackBtn.backgroundColor = UIColor.greenColor()
            self.attackBtn.setTitle("Continue", forState: .Normal)
            self.attackBtn.tag = 2
            self.calculateEXP()

        }

    }

    override func viewDidLayoutSubviews() {

        playerHealthBar.transform = CGAffineTransformMakeScale(1.0, 3.0)
        playerExpBar.transform = CGAffineTransformMakeScale(1.0, 3.0)
        mobHealthBar.transform = CGAffineTransformMakeScale(1.0, 3.0)

        updateValues()

        mobHealthBar.setProgress(0.0, animated: true)
        playerExpBar.setProgress(0.0, animated: true)

    }

    @IBAction func attackPressed(sender: UIButton) {
        switch sender.tag {
            case 0: //Attack
                switch turnCount % 2 {
                    case 0: attack(player, defender: mob); break
                    default: attack(mob, defender: player) ; break
                }
                break
            case 1: //Reset
                resetGame()
                break
            case 2: //Continue
                continueGame()
                break
            default: break
        }

    }

    func attack(attacker: Creature, defender: Creature) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

            let attackValue = Int.random(0...(attacker.atk - defender.def))

            dispatch_async(dispatch_get_main_queue()) {
                self.activityField.text = self.activityField.text + "\(attacker.name) attacked \(defender.name) for \(attackValue) damage! \n"
            }

            defender.health.current -= attackValue

            self.turnCount++

            self.updateValues()
        }

    }

    func calculateEXP() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

            let mobEXP = 50 * self.mob.level
            let lowerEXP = Float(mobEXP) * 0.75
            let upperEXP = Float(mobEXP) * 1.25

            let gainedEXP : Int = Int.random(Int(lowerEXP)...Int(upperEXP))

            self.player.experience.current += gainedEXP

            dispatch_async(dispatch_get_main_queue()) {
                self.activityField.text = self.activityField.text + "\(self.player.name) gained \(gainedEXP) EXP! \n"
                self.playerExpBar.setProgress(Float(self.player.experience.current), animated: true)
            }
        }
    }

    func delay(delay:Double, closure:()-> Void) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    func resetGame() {
        dispatch_async(dispatch_get_main_queue()) {

            print("========== RESETTING GAME ==========")
            self.player = Player(name: "Chris")
            self.mob = Mob(name: "Fuccboi", level: 1)

            self.activityField.text = "\(self.player.name) has encountered a wild \(self.mob.name)! \n"

            self.attackBtn.backgroundColor = UIColor.redColor()
            self.attackBtn.setTitle("Attack", forState: .Normal)
            self.attackBtn.tag = 0

            self.updateValues()
        }
    }

    func continueGame() {
        dispatch_async(dispatch_get_main_queue()) {

            print("========== CONTINUING GAME ==========")

            self.mob = Mob(name: "Fuccboi\(self.player.level)", level: self.player.level)

            self.player.reset()

            self.activityField.text = "\(self.player.name) has encountered a wild \(self.mob.name)! \n"

            self.playerName.text = "Name: \(self.player.name)"
            self.playerLevel.text = "Level: \(self.player.level)"

            self.attackBtn.backgroundColor = UIColor.redColor()
            self.attackBtn.setTitle("Attack", forState: .Normal)
            self.attackBtn.tag = 0

            self.updateValues()
        }
    }

    func updateValues() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

            let playerHealth = Float(self.player.health.current) / Float(self.player.health.max)
            let mobHealth = 1 - (Float(self.mob.health.current) / Float(self.mob.health.max))

            dispatch_async(dispatch_get_main_queue()) {

                self.mobName.text = "Name: \(self.mob.name)"
                self.mobLevel.text = "Level: \(self.mob.level)"


                self.playerName.text = "Name: \(self.player.name)"
                self.playerLevel.text = "Level: \(self.player.level)"

                self.playerHealthBar.setProgress(playerHealth, animated: true)
                self.mobHealthBar.setProgress(mobHealth, animated: true)

                self.playerCurrentHP.text  = "\(self.player.health.current) / \(self.player.health.max)"
                self.mobCurrentHP.text  = "\(self.mob.health.current) / \(self.mob.health.max)"

                self.colorHP()
            }
        }
    }

    func colorHP() {

        switch mob.health.current {
            case 0...Int((Float(mob.health.max) * 0.25)):
                mobHealthBar.trackTintColor = UIColor.redColor(); break
            case Int((Float(mob.health.max) * 0.26))...Int((Float(mob.health.max) * 0.66)):
                mobHealthBar.trackTintColor = UIColor.yellowColor(); break
            default :
                mobHealthBar.trackTintColor = UIColor.greenColor(); break
        }

        switch player.health.current {
            case 0...Int((Float(player.health.max) * 0.25)):
                playerHealthBar.progressTintColor = UIColor.redColor(); break
            case Int((Float(player.health.max) * 0.26))...Int((Float(player.health.max) * 0.66)):
                playerHealthBar.progressTintColor = UIColor.yellowColor(); break
            default :
                playerHealthBar.progressTintColor = UIColor.greenColor(); break
        }
    }

}


extension Int
{
    static func random(range: Range<Int> ) -> Int
    {
        var offset = 0

        if range.startIndex < 0   // allow negative ranges
        {
            offset = abs(range.startIndex)
        }

        let mini = UInt32(range.startIndex + offset)
        let maxi = UInt32(range.endIndex   + offset)

        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}

