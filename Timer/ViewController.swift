//
//  ViewController.swift
//  Timer
//
//  Created by William Qian on 1/4/19.
//  Copyright © 2019 William Qian. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

var time = 60.0
var run = false
class ViewController: UIViewController{
    

    @IBOutlet weak var pauseLabel: UIButton!
    @IBOutlet weak var startLabel: UIButton!
    @IBOutlet weak var timeLeft: UILabel!
    @IBOutlet weak var wheel: UIDatePicker!
    
    
    var x = 0
    //var t = RepeatingTimer(timeInterval: 1)
    //var backgroundTask = BackgroundTask()
    var timer = Timer()
    
    var resume = false
    
    override func viewDidLoad() {
        //backgroundTask.startBackgroundTask() 
        super.viewDidLoad()
        
        timeLeft.isHidden = true
        pauseLabel.isHidden = true
        print("here")
        //t.eventHandler = {
       //     self.x += 1
        //    print("\(self.x)")
            //print("Timer Fired")
       // }
        //t.resume()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func displayTime(time:TimeInterval){
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        timeLeft.text = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        print(String(format:"%02i:%02i:%02i", hours, minutes, seconds))
    }
    
    @objc func updateTimer(){
        if(time > 0){
            time -= 1
            displayTime(time:TimeInterval(time))
            //print("\(time)")
            //print("\(x)")
        }
        else{
            timerDone()
        }
    }
    func stopTimer(){
        timer.invalidate()
        time = 0.0
        run = false
        displayTime(time:TimeInterval(time))
    }
    func pauseTimer(){
        timer.invalidate()
        displayTime(time:TimeInterval(time))
    }
    func timerDone(){
        //need to make an alertr system
        AudioServicesPlaySystemSound(SystemSoundID(1151))
        print("qse")
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    private func configureNotif(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let endAction = UNNotificationAction(identifier: "END_ACTION",
                                             title: "Stop",
                                             options: UNNotificationActionOptions(rawValue: 0))
        let notifCategory =
            UNNotificationCategory(identifier: "NOTIFICATION_CATEGORY",
                                   actions: [endAction],
                                   intentIdentifiers: [],
                                   options: [])
        
        center.setNotificationCategories([notifCategory])
        let date = Date()
        let calendar = Calendar.current
        let currHour = calendar.component(.hour, from: date)
        let currMin = calendar.component(.minute, from: date)
        let currSec = calendar.component(.second, from: date)
        let content = UNMutableNotificationContent()
        content.title = "Timer"
        content.body = "Timer Done"
        content.sound = UNNotificationSound(named:"End.caf")//(SystemSoundID(1151))//UNNotificationSound.default()
        content.categoryIdentifier = "NOTIFICATION_CATEGORY"
        var timeOfNotif = DateComponents()
        let timeHours = Int(time) / 3600
        let timeMinutes = Int(time) / 60 % 60
        let timeSeconds = Int(time) % 60
        timeOfNotif.hour = (currHour + timeHours) % 24
        timeOfNotif.minute = (currMin + timeMinutes) % 60
        timeOfNotif.second = (currSec + timeSeconds) % 60
        print("curr "+String(format:"%02i:%02i:%02i", currHour, currMin, currSec)+"notif "+String(format:"%02i:%02i:%02i", ((currHour + timeHours) % 24 ), ((currMin + timeMinutes) % 60 ), ((currSec + timeSeconds) % 60 ))+"timer "+"\(time)")
        let trigger = UNCalendarNotificationTrigger(dateMatching: timeOfNotif, repeats: false)
        let request = UNNotificationRequest(identifier: "Timer", content: content, trigger: trigger)
        
        center.add(request){(error : Error?) in
            content.body="Repeat"
            let trigger2 = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
            let request2 = UNNotificationRequest(identifier: "TimerRepeat", content: content, trigger: trigger2)
            center.add(request2){(error : Error?) in
                
                }
        }
    }
    
    @IBAction func start(_ sender: UIButton) {
        if(timeLeft.isHidden == false){
            run = true
            startTimer()
        }
        else{
            time = wheel.countDownDuration - (Double(Int(wheel.countDownDuration)%60))
            displayTime(time:TimeInterval(time))
            wheel.isHidden = true
            timeLeft.isHidden = false
            if (run == false){
                run = true
                startTimer()
            }
        }
        pauseLabel.isHidden = false
        startLabel.isHidden = true
        //notification system
        configureNotif()
    }
    func cancelNotif(){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:["Timer","TimerRepeat"])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers:["Timer","TimerRepeat"])
        
    }
    @IBAction func pause(_ sender: UIButton) {
        run = false
        pauseTimer()
        pauseLabel.isHidden = true
        startLabel.isHidden = false
        cancelNotif()
    }
    
    @IBAction func stop(_ sender: UIButton) {
        stopTimer()
        wheel.isHidden = false
        timeLeft.isHidden = true
        pauseLabel.isHidden = true
        startLabel.isHidden = false
        run = false
        cancelNotif()
    }
}
extension ViewController: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        stopTimer()
        wheel.isHidden = false
        timeLeft.isHidden = true
        pauseLabel.isHidden = true
        startLabel.isHidden = false
        run = false
        
        completionHandler()
    }
}

