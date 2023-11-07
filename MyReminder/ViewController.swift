//
//  ViewController.swift
//  MyReminder
//
//  Created by Nilgul Cakir on 1.11.2023.
//

import UserNotifications
import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        let date = models[indexPath.row].date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, dd, YYYY"
        
        cell.detailTextLabel?.text = formatter.string(from: date)
        return cell
    }
    

    @IBOutlet var table : UITableView?
    
    var models = [MyReminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table?.delegate = self
        table!.dataSource = self
        
    }
    
    @IBAction func didTapAdd(){
        //show add vc
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else{
            return
        }
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = MyReminder(title: title, date: date, identifier: "id\(title)")
                self.models.append(new)
                self.table?.reloadData()
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = .default
                
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                
                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { (error) in
                    if  error != nil {
                        print("something went wrong")
                    }
                }
            }
            
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapTest(){
        
        //fire test notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if success {
                scheduleTest()
            }else if  error != nil {
                print("errorr occurred")
            }
            func scheduleTest(){
                let content = UNMutableNotificationContent()
                content.title = "Hello World"
                content.body = "My Long Body,My Long Body,My Long Body,My Long Body,My Long Body,My Long Body"
                content.sound = .default
                
                
                let targetDate = Date().addingTimeInterval(10)
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                
                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { (error) in
                    if  error != nil {
                        print("something went wrong")
                    }
                }
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
    }
}
struct MyReminder {
    let title: String
    let date: Date
    let identifier: String
}

