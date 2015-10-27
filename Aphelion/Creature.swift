//
//  Creature.swift
//  Aphelion
//
//  Created by Christopher Scalcucci on 10/25/15.
//  Copyright © 2015 Aphelion. All rights reserved.
//

import Foundation

protocol CreatureProtocol {

    var atk: Int { get set }
    var def: Int { get set }

    var name: String { get set }
}

class Creature : CreatureProtocol {

    var atk = 0
    var def = 0

    var name = "Placeholder"

    var living: Bool = true {
        didSet {

        }
    }

    var health: (max: Int, current: Int) {
        didSet {
            if self.health.current <= 0 {
                self.health.current = 0
                self.living = false
            }
        }
    }

    private init() {

        self.health = (100, 100)
        self.living = true
    }

    //Custom getter/setter for touples
//    var health: (max: Int, current: Int) {
//        get {
//            return (self.health.max, self.health.current)
//        } set {
//            if newValue.current < 0 { self.health.current = 0 }
//            self.health.max = newValue.max
//        }
//    }

}

class Player : Creature {

    let atkBase = 100
    let defBase = 25
    let healthBase = 100

    var experience: (max: Int, current: Int) = (100, 0) {
        didSet {
            if self.experience.current >= self.experience.max {
                self.level++
            }
        }
    }


    var level : Int = 0  {
        didSet{
            self.health.max = healthBase + ((level - 1) * 20)
            self.experience.current = self.experience.current - ((self.level - 1) * 100)
            self.experience.max = (self.level * 100)
            self.atk = atkBase + ((level - 1) * 20)
            self.def = defBase + ((level - 1) * 5)
        }
    }

    override var living : Bool {
        didSet {
            if self.living == false {
                NSNotificationCenter.defaultCenter().postNotificationName("GameOver", object: nil)
            }
        }
    }

    init(name: String) {
        super.init()

        self.name = name
        self.living = true
        self.setLevel(1)
    }

    func setLevel(level: Int) {
        self.level = level
    }

    func reset() {
        self.health.current = self.health.max
    }

}

class Mob : Creature {

    let atkBase = 50
    let defBase = 25
    let healthBase = 100

    var level : Int!

    override var living : Bool {
        didSet {
            if self.living == false {
                NSNotificationCenter.defaultCenter().postNotificationName("GameWon", object: nil)
            }
        }
    }

    init(name: String, level: Int) {
        super.init()

        self.name = name
        self.living = true
        
        self.health.max = healthBase + ((level - 1) * 20)
        self.atk = atkBase + ((level - 1) * 20)
        self.def = defBase + ((level - 1) * 5)

        setLevel(1)
    }

    func setLevel(level: Int) {
        self.level = level
    }
}
