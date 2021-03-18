//
//  NotificationController.swift
//  EducationUSA
//
//  Created by XEONCITY on 28/12/2017.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import LGRefreshView
import FCAlertView
import EZAlertController

class NotificationController: BaseController , UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var tableViewNotification: UITableView!
    @IBOutlet weak var stackViewEmptyData: UIStackView!
    
    var refreshView:LGRefreshView!
    var isRefreshing:Bool = false
    
    var notificationData:[NotificationNotifications] = [NotificationNotifications]()
    
    let data = ["Do any additional setup after loading the view Dispose of any resources that can be recreated","Do any additional setup after","Dispose of any resources that can be recreated Dispose of any resources that can be recreated Dispose of any resources that can be recreated"]
    
    override func viewDidLoad() {
        
        currentController = Controllers.Notification
        super.viewDidLoad()
        stackViewEmptyData.isHidden = true
        // Do any additional setup after loading the view.
        tableViewNotification.rowHeight = UITableViewAutomaticDimension
        tableViewNotification.estimatedRowHeight = 50
        createRefreshView()
        callNotificationService()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createRefreshView() {
        
        refreshView = LGRefreshView.init(scrollView: tableViewNotification, refreshHandler: { ( ref ) in
            
            self.isRefreshing = true
            self.callNotificationService()
            
        })
        refreshView.tintColor = Utility.UIColorFromRGB(rgbValue: 0x0A3866)
        refreshView.backgroundColor = UIColor.clear
    }
    
    
    // MARK: - APIS
    func callNotificationService(){
        
        let parameter:[String:Any] = ["user_id":(Singleton.sharedInstance.userData?.id)!]
        
        if !isRefreshing {
            self.showNormalHud(NSLocalizedString("Loading...", comment: ""))
        }
        
        NotificationBase.getNotifications(urlPath: BASE_URL+NOTIFICATION, parameter: parameter, vc: self) { (data) in
            self.refreshView.endRefreshing()
            self.removeNormalHud()
            if data.code != 200 {
                self.view.makeToast(data.message, duration: 1.5, position: .center)
                return
            }
            
            self.notificationData = Array((data.result?.notifications)!)
            
            if self.notificationData.count > 0 {
                //self.tableViewNotification.isHidden = false
                self.stackViewEmptyData.isHidden = true
            }else{
                //self.tableViewNotification.isHidden = true
                self.stackViewEmptyData.isHidden = false
                
            }
            
            self.tableViewNotification.reloadData()
        }
    }
    
    func callDeleteNotification(id:String, index:Int) {
        
        if !Connectivity.isConnectedToInternet {
            self.view.makeToast(AppString.internetUnreachable, duration: 1.5, position: .center)
            return
        }
        self.showNormalHud("")

        
        let parameters:[String:Any] = [ "user_id" : (Singleton.sharedInstance.userData?.id)!,
                                        "notification_id" :  id]
        
        NotificationBase.deleteNotification(urlPath: BASE_URL+NOTI_DELETE, parameters: parameters, vc: self) { (data) in
            self.removeNormalHud()
            if data.code != 200 {
                self.view.makeToast(data.message, duration: 1.5, position: .center)
                return
            }
            
            self.notificationData.remove(at: index)
            
            if self.notificationData.count > 0 {
                //self.tableViewNotification.isHidden = false
                self.stackViewEmptyData.isHidden = true
            }else{
                //self.tableViewNotification.isHidden = true
                self.stackViewEmptyData.isHidden = false

            }
            
            self.tableViewNotification.reloadData()


        }

    }
    
    func callEventService(index:Int){
        
        if !Connectivity.isConnectedToInternet {
            self.view.makeToast(AppString.internetUnreachable, duration: 1.5, position: .center)
            return
        }
        
        guard (notificationData[index].refId != nil) else {
            DispatchQueue.main.async {
                EZAlertController.alert(NSLocalizedString("Alert!", comment: ""), message: NSLocalizedString("No data found", comment: ""), acceptMessage: NSLocalizedString("OK", comment: ""), acceptBlock: {
                    
                })
            }

            return
        }
        
        
        let parameter:[String:Any] = ["user_id":(Singleton.sharedInstance.userData?.id)!,"ref_id":self.notificationData[index].refId,"notification_id":String(self.notificationData[index].id),"action_type":self.notificationData[index].actionType!]
        
        self.showNormalHud(NSLocalizedString("Loading...", comment: ""))
        
        
        EventBase.getEvents(urlPath: BASE_URL+NOTI_DATA, parameter: parameter, vc: self) { (data) in
            
            self.removeNormalHud()
            
            if data.code != 200 {
                self.view.makeToast(data.message, duration: 1.5, position: .center)
                return
            }
            
            if let event = data.result?.event {
                let eventDetailVC = AppConstants.APP_STORYBOARD.HOME.instantiateViewController(withIdentifier: "EventDetailController") as! EventDetailController
                eventDetailVC.eventData = event//data.result?.event
                self.navigationController?.pushViewController(eventDetailVC, animated: true)
            }else{
                self.view.makeToast(NSLocalizedString("Event Not Found", comment: ""), duration: 1.5, position: .center)
            }

            
        }
    }


    // MARK: - TableView DataSource & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell") as! NotificationTableCell

        cell.lblTitle.text = notificationData[indexPath.row].text
        cell.lblDate.text = Utility.getDateFormat(date: notificationData[indexPath.row].createdAt!, In: "yyyy-dd-MM hh:mm:ss", Out: "dd MMM yyyy")
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let deleteAction = UITableViewRowAction(style: .default, title: NSLocalizedString("Delete", comment: "")) { action, index in
            print("more button tapped")
            
            self.callDeleteNotification(id: String(self.notificationData[indexPath.row].id), index: indexPath.row)
            
        }
        deleteAction.backgroundColor = Utility.UIColorFromRGB(rgbValue: 0xE96166)
        return [deleteAction]
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if notificationData[indexPath.row].actionType == "post_event" {
            callEventService(index: indexPath.row)
        }else{
            showAlert(title: nil, subTitle:notificationData[indexPath.row].text, doneBtnTitle:NSLocalizedString("OK", comment: "") , buttons: nil, type: "general")
        }
    }
    
}
