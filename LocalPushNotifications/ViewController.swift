//
//  ViewController.swift
//  LocalPushNotifications
//
//  Created by Macbook Pro on 23/6/22.
//  Copyright © 2022 Fahad Hasan Zahidi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var notificationTitle: UITextField!
    @IBOutlet weak var notificationBody: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let notificationCenter = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notificationCenter.requestAuthorization(options: [.alert,.sound, .badge]) {
            (permission, error) in
            if(!permission) {
                print("permission denied")
            }
        }
    }

    @IBAction func schedule(_ sender: Any) {
        notificationCenter.getNotificationSettings{
            (settings) in
            DispatchQueue.main.async {
                let title = self.notificationTitle.text!
                let description = self.notificationBody.text!
                let date = self.datePicker.date
                if(settings.authorizationStatus == .authorized) {
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = description
                    
                    let dateCom = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateCom, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    self.notificationCenter.add(request) { (error) in
                        if(error != nil) {
                            print("Error " + error.debugDescription)
                            return
                        }
                    }
                    
                    let alertController = UIAlertController(title: "Scheduled appointment", message: "At" + self.formattedDate(date: date), preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                        
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
                else {
                    let alertController = UIAlertController(title: "Enable Notifications", message: "To show you notifications", preferredStyle: .alert)
                    let goToSetting = UIAlertAction(title: "Settings", style: .default) { (_) in
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString)
                            else {
                                return
                        }
                        if(UIApplication.shared.canOpenURL(settingsURL)){
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                    alertController.addAction(goToSetting)
                    alertController.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (_) in
                        
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func formattedDate(date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y HH:mm"
        return formatter.string(from: date)
    }
    
}

