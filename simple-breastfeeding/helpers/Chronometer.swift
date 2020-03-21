//
//  Chronometer.swift
//  rememberbreast
//
//  Created by Rodrigo Villamil Pérez on 18/7/18.
//  Copyright © 2018 Rodrigo Villamil Pérez. All rights reserved.
//

import Foundation

class Chronometer {
    
    enum State {
        case started;
        case stopped;
        case resumed;
    }
    
    // MARK: - Private var
    private var internalTimer   : Timer?
    private var timeInterval    = 0.0
    
    // MARK: - Properties
    var seconds         = 0
    var startDateTime   : Date? // https://goo.gl/YJzXCG
    var stopDateTime    : Date?
    var state: State = .stopped
    
    // Optional callback function: https://goo.gl/bZZ3xR
    var onTick: ((_: Int)->())?
    
    // Default 1 sec
    init() {
        self.timeInterval    = 1.0
        self.state           = .stopped
    }
    
    // Default 1 sec
    init ( ticInterval:TimeInterval ) {
        self.timeInterval    = ticInterval
        self.state           = .stopped
    }
    
    func start( ){
        if self.internalTimer == nil {
            if (self.state == .resumed) {
                let timeInterval =  Date().timeIntervalSince(self.stopDateTime!)
                self.seconds = self.seconds + (Int(timeInterval))
            } else {
                self.seconds = 0
                self.startDateTime = Date()
            }
            self.internalTimer = Timer.scheduledTimer(
                timeInterval: self.timeInterval,
                target: self,
                selector:#selector(self.tick) ,
                userInfo: nil,
                repeats: true)
            self.state           = .started
        }
    }
    
    func resume(){
        if (self.state == .started) {
            stop()
            self.state           = .resumed
        }
    }
    
    func stop() {
        if self.internalTimer != nil {
            self.internalTimer?.invalidate()
            self.internalTimer = nil
            self.stopDateTime = Date()
            self.state           = .stopped
        }
    }
   
    @objc func tick() {
        seconds+=1
        onTick?(seconds)
    }
}
