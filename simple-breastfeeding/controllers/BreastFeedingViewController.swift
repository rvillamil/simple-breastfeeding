//
//  FirstViewController.swift
//  rememberbreast
//
//  Created by Rodrigo Villamil Pérez on 18/7/18.
//  Copyright © 2018 Rodrigo Villamil Pérez. All rights reserved.
//

import UIKit
import UserNotifications
import os.log

class BreastFeedingViewController: UIViewController {

    // MARK: - Internal vars
    var chronometerBreastRight      = Chronometer()
    var chronometerBreastLeft       = Chronometer()
    var breastFeedingStaticsStore   = BreastFeedingStaticsStore()
 
    // MARK: - Internal Constants
    let measurementQualityThreshold    = 10 //Seconds
    let notificationTimeInterval       = 900.0 // Seconds
    
    // MARK: - IBOutlets
    @IBOutlet weak var lblYourBabyToday: UILabel!
    @IBOutlet weak var lblNumberBreastFeeding: UILabel!
    @IBOutlet weak var lblBreastSide: UILabel!
    
    @IBOutlet weak var lblTimerRightBreast: UILabel!
    @IBOutlet weak var lblElapsedTimeLeftBreast: UILabel!
    @IBOutlet weak var lblTimerLeftBreast: UILabel!
    @IBOutlet weak var lblElapsedTimeRightBreast: UILabel!
    
    @IBOutlet weak var buttonLeftBreast: UIButton!
    @IBOutlet weak var buttonRightBreast: UIButton!

    @IBOutlet weak var tbItemChronometer: UITabBarItem!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initChronometer()
        self.l18n()
        self.initNotificationCenter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.updateView()
    }
    
    // MARK: - My functions
    // http://www.thomashanning.com/push-notifications-local-notifications-tutorial/#Sending_local_notifications
    
    func initChronometer(){
        self.chronometerBreastRight.onTick = {
            tic in self.lblTimerRightBreast.text
                = SimpleDateFormatter.secondsToHHmmss(tic)
        }
        self.chronometerBreastLeft.onTick = {
            tic in self.lblTimerLeftBreast.text
                = SimpleDateFormatter.secondsToHHmmss(tic)
        }
    }
    
    func initNotificationCenter () {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    @objc func applicationWillEnterForeground () {
        os_log("###### applicationWillEnterForeground #####")
        if (chronometerBreastRight.state == .resumed ) {
            self.chronometerBreastRight.start()
            os_log("applicationWillEnterForeground - chronometerBreastRight.start")
        }
        if (chronometerBreastLeft.state == .resumed ) {
            self.chronometerBreastLeft.start()
            os_log("applicationWillEnterForeground - chronometerBreastLeft.start")
        }
        // https://stackoverflow.com/questions/31951142/how-to-cancel-a-localnotification-with-the-press-of-a-button-in-swift
        os_log("applicationWillEnterForeground - removeAllPendingNotificationRequests")
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        os_log("applicationWillEnterForeground - removeAllDeliveredNotifications")
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        os_log("applicationWillEnterForeground - updateView")
        self.updateView()
        os_log("applicationWillEnterForeground - OK")
    }
    
    @objc func applicationDidEnterBackground () {
        os_log("###### applicationDidEnterBackground #####")
        os_log("applicationDidEnterBackground - chronometerBreastRight.resume")
        self.chronometerBreastRight.resume() // Maybe the state be stopped
        os_log("applicationDidEnterBackground - chronometerBreastLeft.resume")
        self.chronometerBreastLeft.resume()
        if (chronometerBreastRight.state == .resumed ) || (chronometerBreastLeft.state == .resumed ) {
            os_log("applicationDidEnterBackground - requestLocalPushNotification")
            self.requestLocalPushNotification()
        }
         os_log("applicationDidEnterBackground - OK")
    }
    
    func l18n () {
        self.tbItemChronometer.title = NSLocalizedString("tbItemChronometer.title", comment: "")
    }
    
    func updateView(){
        let today = Date()
        // Today is ..
        self.lblYourBabyToday.text = NSLocalizedString("lblYourBabyToday.text", comment: "") + SimpleDateFormatter.dateToStringMMMddyyy (today)
        //
        // Number of breastFeeding for today
        //
        self.lblNumberBreastFeeding.text
            = "\(NSLocalizedString("lblNumberBreastFeeding.text", comment: "")) \(breastFeedingStaticsStore.findTotalBreastFeedings(forDate: today))"
        //
        // Latest breastfeeding: Right or Left breast and elapsed time
        //
        var breastSideText = NSLocalizedString("breastSideText_select_the_breast", comment: "")
        if let lastestBreastFeeding = breastFeedingStaticsStore.findLatestBreastFeeding() {
            breastSideText = NSLocalizedString("breastSideText_left", comment: "")
            if (lastestBreastFeeding.chestRight) {
                breastSideText = NSLocalizedString("breastSideText_right", comment: "")
            }
        
            let componentsElapsedTime = Calendar.current.dateComponents(
                [.hour, .minute],
                from: lastestBreastFeeding.endDateTime!,
                to: today)
            breastSideText
                += (" ,\(NSLocalizedString("since", comment: ""))\(componentsElapsedTime.hour ?? 0) \(NSLocalizedString("hours", comment: "")) \(componentsElapsedTime.minute ?? 0) \(NSLocalizedString("minutes", comment: ""))")
        }
        self.lblBreastSide.text = breastSideText
        
        //
        // Elapsed time from now for left breast
        //
        self.lblElapsedTimeLeftBreast.text = (NSLocalizedString("lblElapsedTimeLeftBreast.text", comment: ""))
        if let latestBreastFeedingLeft = breastFeedingStaticsStore.findLatestBreastFeeding(forChestRight: false) {
       
            let componentsElapsedTimeLeftBreast = Calendar.current.dateComponents(
                [.hour, .minute],
                from: latestBreastFeedingLeft.endDateTime!,
                to: today)
            self.lblElapsedTimeLeftBreast.text
                =  ("\(NSLocalizedString("last", comment: "")) \(componentsElapsedTimeLeftBreast.hour ?? 0) h \(componentsElapsedTimeLeftBreast.minute ?? 0) m")
        }
        //
        // Elapsed time from now for right breast
        //
        self.lblElapsedTimeRightBreast.text = (NSLocalizedString("lblElapsedTimeRightBreast.text", comment: ""))
        if let latestBreastFeedingRight = breastFeedingStaticsStore.findLatestBreastFeeding(forChestRight: true) {
        
            let componentsElapsedTimeRightBreast = Calendar.current.dateComponents(
                [.hour, .minute],
                from: latestBreastFeedingRight.endDateTime!,
                to: today)
            self.lblElapsedTimeRightBreast.text
                = ("\(NSLocalizedString("last", comment: "")) \(componentsElapsedTimeRightBreast.hour ?? 0) h \(componentsElapsedTimeRightBreast.minute ?? 0) m")
        }
        
        // Contador de notificaciones locales
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func showDialogMaybeWrongMeasure (chronometer: Chronometer,
                                      chestRight: Bool) {
        
        let alert = UIAlertController(
            title: (NSLocalizedString("dlg.wrongmeasure.title", comment: "")),
            message:"\(NSLocalizedString("dlg.wrongmeasure.message_prefix", comment: "")) \(self.measurementQualityThreshold) \(NSLocalizedString("dlg.wrongmeasure.message_sufix", comment: ""))",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: (NSLocalizedString("yes", comment: "")),
                                      style: .default,
                                      handler:
            {
                _ in self.breastFeedingStaticsStore.insert(
                        beginDateTime:chronometer.startDateTime! ,
                        endDateTime: chronometer.stopDateTime!,
                        chestRight: chestRight,
                        duration: chronometer.seconds)
                self.updateView()
        }))
            
        alert.addAction(UIAlertAction(title: "No",
                                      style: .cancel,
                                      handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func performButtonClicked ( uiButton: UIButton,
                                chronometer: Chronometer,
                                chestRight: Bool,
                                lblTimerBreast: UILabel) {
        if !uiButton.isSelected {
            chronometer.start()
            lblTimerBreast.textColor = UIColor.rbTextChronometerRunning
        }else {
            chronometer.stop()
            lblTimerBreast.textColor = UIColor.rbTextChronometerStopped
            if (chronometer.seconds <= self.measurementQualityThreshold) {
                showDialogMaybeWrongMeasure( chronometer: chronometer,
                                             chestRight: chestRight)
                
            } else {
                breastFeedingStaticsStore.insert(
                    beginDateTime:chronometer.startDateTime! ,
                    endDateTime: chronometer.stopDateTime!,
                    chestRight: chestRight,
                    duration: chronometer.seconds)
            }
            lblTimerBreast.text = SimpleDateFormatter.secondsToHHmmss(0)
        }
        uiButton.isSelected = !uiButton.isSelected
        updateView()
    }
    
    func requestLocalPushNotification(){
        let localNotificationContent    = UNMutableNotificationContent()
        
        localNotificationContent.title = NSLocalizedString(
            "requestLocalPushNotification.title", comment: "")
        localNotificationContent.body = NSLocalizedString(
            "requestLocalPushNotification.body", comment: "")
        localNotificationContent.sound = UNNotificationSound.default
        localNotificationContent.badge = 1
        
        // Cada 900 segundos y se repite
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: self.notificationTimeInterval,
            repeats: true)
        
        let request = UNNotificationRequest(identifier: "anyChronometerStarted",
                                            content: localNotificationContent,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request,
                                               withCompletionHandler: nil)
    }
    
    // MARK: - IBActions
    @IBAction func rightBreastButtonClicked(_ sender: UIButton) {
    
        performButtonClicked (uiButton: sender,
                              chronometer: chronometerBreastRight,
                              chestRight: true,
                              lblTimerBreast:lblTimerRightBreast)
    }
    
    @IBAction func leftBreastButtonClicked(_ sender: UIButton) {
        
        performButtonClicked (uiButton: sender,
                              chronometer: chronometerBreastLeft,
                              chestRight: false,
                              lblTimerBreast:lblTimerLeftBreast)
    }
}

