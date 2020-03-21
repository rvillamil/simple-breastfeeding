//
//  BreastFeedingStaticsStorePopulator.swift
//  rememberbreast
//
//  Created by Rodrigo Villamil Pérez on 23/7/18.
//  Copyright © 2018 Rodrigo Villamil Pérez. All rights reserved.
//

import Foundation

class BreastFeedingStaticsStorePopulator {

    var breastFeedingStaticsStore: BreastFeedingStaticsStore?
    
    init(_ store: BreastFeedingStaticsStore) {
        self.breastFeedingStaticsStore = store
    }
    
    func populate () {
        self.breastFeedingStaticsStore?.deleteAll()
        
        // Derecha
        self.populate(month: 7, day: 2, chestRight: true)
        self.populate(month: 7, day: 3, chestRight: true)
        // Izquierda
        self.populate(month: 7, day: 24, chestRight: false)
        self.populate(month: 7, day: 22, chestRight: false)
    }
    
    func populate(month: Int, day:Int, chestRight:Bool) {
        // ----------
        var components      = DateComponents()
        components.day      = day
        components.month    = month
        components.year     = 2018
        components.hour     = 19
        components.minute   = 30
        var beginDateTime   =  Calendar.current.date(from: components)
        components.minute   = 29
        var endDateTime     =  Calendar.current.date(from:components)
        self.breastFeedingStaticsStore?.insert(beginDateTime: beginDateTime!,
                    endDateTime: endDateTime!,
                    chestRight: chestRight,
                    duration: 500)
        
        // ----------
        components.hour     = 20
        components.minute   = 35
        beginDateTime   =  Calendar.current.date(from: components)
        components.minute   = 40
        endDateTime     =  Calendar.current.date(from:components)
        
        self.breastFeedingStaticsStore?.insert(beginDateTime: beginDateTime!,
                    endDateTime: endDateTime!,
                    chestRight: chestRight,
                    duration: 500)
        
        // ----------
        components.hour     = 21
        components.minute   = 05
        beginDateTime   =  Calendar.current.date(from: components)
        components.minute   = 55
        endDateTime     =  Calendar.current.date(from:components)
        
        self.breastFeedingStaticsStore?.insert(beginDateTime: beginDateTime!,
                                               endDateTime: endDateTime!,
                                               chestRight: chestRight,
                                               duration: 500)
        
        // ----------
        components.hour     = 22
        components.minute   = 45
        beginDateTime   =  Calendar.current.date(from: components)
        components.minute   = 53
        endDateTime     =  Calendar.current.date(from:components)
        
        self.breastFeedingStaticsStore?.insert(beginDateTime: beginDateTime!,
                                               endDateTime: endDateTime!,
                                               chestRight: chestRight,
                                               duration: 500)
        // ----------
        components.hour     = 23
        components.minute   = 12
        beginDateTime   =  Calendar.current.date(from: components)
        components.minute   = 53
        endDateTime     =  Calendar.current.date(from:components)
        
        self.breastFeedingStaticsStore?.insert(beginDateTime: beginDateTime!,
                                               endDateTime: endDateTime!,
                                               chestRight: chestRight,
                                               duration: 500)
        
        // ----------
        components.hour     = 23
        components.minute   = 55
        beginDateTime   =  Calendar.current.date(from: components)
        components.minute   = 58
        endDateTime     =  Calendar.current.date(from:components)
        
        self.breastFeedingStaticsStore?.insert(beginDateTime: beginDateTime!,
                                               endDateTime: endDateTime!,
                                               chestRight: chestRight,
                                               duration: 500)
        
    }
}
