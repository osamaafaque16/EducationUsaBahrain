//
//  EventController.swift
//  EducationUSA
//
//  Created by XEONCITY on 30/12/2017.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import LGRefreshView
import QuartzCore
class EventController: BaseController , UITextFieldDelegate{
    
    @IBOutlet weak var tableViewEvents: UITableView!
    
    @IBOutlet weak var noRecordView: UIStackView!
    var searchFlag:Bool = false
    var refreshView:LGRefreshView!
    var isRefreshing:Bool = false
    var events:[EventEvents] = [EventEvents]()
    var eventsAll:[EventEvents] = [EventEvents]()
    var totalPage = 0
    var currentPage = 1
    var shouldShowLoadingCell = false
    
    //MARK:- View LifeCycles
    override func viewDidLoad() {
        currentController = Controllers.Events
        super.viewDidLoad()

//        self.eventsAll.append(self.eventsAll[0])
//        self.eventsAll.append(self.eventsAll[0])
//        self.eventsAll.append(self.eventsAll[0])
//        self.eventsAll.append(self.eventsAll[0])
//        self.eventsAll.append(self.eventsAll[0])
//        self.eventsAll.append(self.eventsAll[0])
//        self.eventsAll.append(self.eventsAll[0])
//        self.eventsAll.append(self.eventsAll[0])
//        self.eventsAll.append(self.eventsAll[0])
//        self.eventsAll.append(self.eventsAll[0])
//        self.eventsAll.append(self.eventsAll[0])
//        self.eventsAll.append(self.eventsAll[0])
//        self.eventsAll.append(self.eventsAll[0])
        // Do any additional setup after loading the view.
        events = eventsAll
        noRecordView.isHidden = true
        tableViewEvents.rowHeight = UITableViewAutomaticDimension
        tableViewEvents.estimatedRowHeight = 100
        
        let cellRow = UINib(nibName: "LoadMoreCell", bundle: nil)
        self.tableViewEvents.register(cellRow, forCellReuseIdentifier: "LoadMoreCell")
        
        createRefreshView()
       // callEventService()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewEvents.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (viewSearchBar != nil ) {
            viewSearchBar.removeFromSuperview()
            viewSearchBar = nil
        }
    }
    override func viewDidAppear(_ animated: Bool) {
//        UIView.transition(with: tableViewEvents,
 //                         duration: 0.35,
   //                       options: .transitionCrossDissolve,
     //                     animations: { self.tableViewEvents.reloadData() })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.


    }
    
    func createRefreshView() {
        
        refreshView = LGRefreshView.init(scrollView: tableViewEvents, refreshHandler: { ( ref ) in
            
            self.isRefreshing = true
            self.currentPage = 1
            self.callEventService(searchText: self.txtSearch?.text ?? "")
            
        })
        refreshView.tintColor = Utility.UIColorFromRGB(rgbValue: 0x0A3866)
        refreshView.backgroundColor = UIColor.clear
    }
    
    override func searchPressed(){
        createSearchBarView()
        txtSearch?.delegate = self
        txtSearch?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtSearch?.becomeFirstResponder()
    }
    
    override func cancelSearchBar() {
        txtSearch?.text = ""
        currentPage = 1
        shouldShowLoadingCell = false
        callEventService(searchText: "")
        viewSearchBar.removeFromSuperview()
        viewSearchBar = nil
        
    }
    

    
    //MARK:- TextField Delegate and Actions
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        //print(textField)
        
//        if(textField.text?.isEmpty)!{
//            //reload your data source if necessary
//            events = eventsAll
//            self.tableViewEvents.reloadData()
//            
//            
//        }else{
//            events = (eventsAll.filter() {
//                if let title = ($0 as EventEvents).descriptionValue?.lowercased() as String! {
//                    return title.contains((textField.text?.lowercased())!)
//                }else {
//                    return false
//                }
//            })
//            
//            self.tableViewEvents.reloadData()
//            
//            
//        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        
        let maxLength = 30
        
        return newLength <= maxLength
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        txtSearch?.resignFirstResponder()
        currentPage = 1
        shouldShowLoadingCell = false
        callEventService(searchText: (txtSearch?.text!)!)
        return true
    }
    
    // MARK: - APIS
    func callEventService(searchText:String){
        
        if !Connectivity.isConnectedToInternet {
            self.view.makeToast(AppString.internetUnreachable, duration: 1.5, position: .center)
            self.refreshView.endRefreshing()
            return
        }
        
        var parameter:[String:Any] = ["user_id":(Singleton.sharedInstance.userData?.id)!,"offset":String(currentPage)]
        
        if(self.txtSearch?.text?.isEmpty != true && self.txtSearch?.text != nil){
            parameter["search"] = searchText
        }
        
        
        
        if !isRefreshing && !shouldShowLoadingCell {
            self.showNormalHud(NSLocalizedString("Loading...", comment: ""))
        }
        
        EventBase.getEvents(urlPath: BASE_URL+EVENT, parameter: parameter, vc: self) { (data) in
            
            self.removeNormalHud()
            self.refreshView.endRefreshing()
            self.isRefreshing = false
            if data.code != 200 {
                self.view.makeToast(data.message, duration: 1.5, position: .center)
                return
            }
            
            
            if self.shouldShowLoadingCell {
                self.events += Array((data.result?.events)!)
                //self.eventsAll = Array((data.result?.events)!)   //for local search
            }else{
                self.events = Array((data.result?.events)!)
                //self.eventsAll = Array((data.result?.events)!)    //for local search
            }

            
            self.shouldShowLoadingCell = self.currentPage < data.pages
            
            if self.events.count > 0 {
                self.noRecordView.isHidden = true
                self.tableViewEvents.isHidden = false
            }else{
                self.noRecordView.isHidden = false
                self.tableViewEvents.isHidden = true
            }
            
            
            self.tableViewEvents.reloadData()
            

        }
    }
    
    func callFollowService(cell:EventTableViewCell) {
        
        let indexPath = tableViewEvents.indexPath(for: cell)
        
        if !Connectivity.isConnectedToInternet {
            self.view.makeToast(AppString.internetUnreachable, duration: 1.5, position: .center)
            return
        }
        self.showNormalHud("")
       // let isFollow = cell.btnFavorite.isSelected == true ? "0":"1"
        let isFollow = "0"
        let parameters:[String:Any] = [ "user_id" : (Singleton.sharedInstance.userData?.id)!,
                                        "device_token" : Singleton.sharedInstance.deviceToken,
                                        "event_id" : String((events[(indexPath?.row)!].id)),
                                        "response" :  isFollow]
        
        EventBase.followRequest(urlPath: BASE_URL+EVENT_FOLLOW, parameters: parameters, vc: self) { (data) in
            self.removeNormalHud()
            if data.code != 200 {
                self.view.makeToast(data.message, duration: 1.5, position: .center)
                return
            }
            
           // cell.btnFavorite.isSelected = !cell.btnFavorite.isSelected
            self.events[(indexPath?.row)!].isFollow = isFollow
        }
    }


}

// MARK: - TableView Datasource & Delegate
extension EventController: UITableViewDelegate,UITableViewDataSource,EventCellDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return shouldShowLoadingCell ? events.count + 1 : events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == events.count && shouldShowLoadingCell {
            let cell = tableViewEvents.dequeueReusableCell(withIdentifier: "LoadMoreCell") as! LoadMoreCell
            return cell
        }else{
            let cell = tableViewEvents.dequeueReusableCell(withIdentifier: "EventTableViewCell") as! EventTableViewCell
            cell.delegate = self
            if indexPath.row % 2 == 0 {
                //cell.mainView.transform = CGAffineTransform(scaleX: 1, y: 1)
                //cell.mainView.layer.transform = CGAffineTransform(scaleX: 1, y: 1)
                cell.mainStackView.addArrangedSubview(cell.mainStackView.subviews[1])
                //cell.redView.roundCorners(corners: [.topRight, .bottomRight ], radius: 5.0)
               // cell.layoutSubviews()
                cell.redView.layer.cornerRadius = 10.0
                cell.redView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            }
            else {
                cell.mainStackView.addArrangedSubview(cell.mainStackView.subviews[0])
                //cell.mainView.transform = CGAffineTransform(scaleX: -1, y: 1)
                //cell.redView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 5.0)
                //cell.layoutSubviews()
                cell.redView.layer.cornerRadius = 10.0
                cell.redView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            }
            cell.setData(data:events[indexPath.row])
            return cell
        }
        

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == events.count && shouldShowLoadingCell {
            currentPage += 1
            callEventService(searchText: "")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let eventDetailVC = AppConstants.APP_STORYBOARD.HOME.instantiateViewController(withIdentifier: "EventDetailController") as! EventDetailController
        eventDetailVC.eventData = events[indexPath.row]
        print(events)
       // eventDetailVC.pdfUrl = events[indexPath.row].eventURL
        self.navigationController?.pushViewController(eventDetailVC, animated: true)
/*
        let event = events[indexPath.row]
        print(event.eventURL)
        
        if let eventURL = event.eventURL {
            if let url = URL(string: eventURL) {
                // UIApplication.shared.openURL(url)
                // return
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        */
        /*eventDetailVC.updateEventData = { event in
         
            let index = self.events.index(where: {$0.id == event.id})!
            
            self.events[index] = event
        }*/
    }
    
    
    func btnFollowClicked(_ cell: EventTableViewCell) {
        if Singleton.sharedInstance.isGuest == true {
            self.showAlert(title: NSLocalizedString("Alert!", comment: ""), subTitle: NSLocalizedString("Guest can't follow event, Kindly Login", comment: ""), doneBtnTitle: nil, buttons: [NSLocalizedString("Login", comment: ""),NSLocalizedString("Cancel", comment: "")], type: "guest")
        }else{
            callFollowService(cell: cell)
        }
        
    }
}
