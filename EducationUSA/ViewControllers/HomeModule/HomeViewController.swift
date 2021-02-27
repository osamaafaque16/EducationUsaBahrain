//
//  HomeViewController.swift
//  EducationUSA
//
//  Created by XEONCITY on 23/12/2017.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import LGRefreshView

class HomeViewController: BaseController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutlets
    @IBOutlet weak var tableViewHome: UITableView!
    
    
    var refreshView:LGRefreshView!
    var isRefreshing:Bool = false
    var events:[EventEvents] = [EventEvents]()
    var currentPage = 1
    var shouldShowLoadingCell = false
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        currentController = Controllers.Home
        super.viewDidLoad()
        
        

        if Singleton.sharedInstance.isUserLoggedInApp() && Singleton.sharedInstance.isGuest != true {
           // CommonServices.shared.registerPushNotification(UDID: (UIDevice.current.identifierForVendor?.uuidString)!, fcmToken: Singleton.sharedInstance.deviceToken)
        }
        
        // Do any additional setup after loading the view.
        tableViewHome.rowHeight = UITableViewAutomaticDimension
        tableViewHome.estimatedRowHeight = 100
        
        let screenSize = UIScreen.main.bounds.size//height*0.5158
        //tableViewHome.tableHeaderView?.frame = CGRect(x: 0.0, y: 0.0, width: screenSize.width, height: screenSize.height*0.7737)
        tableViewHome.tableHeaderView?.frame = CGRect(x: 0.0, y: 0.0, width: screenSize.width, height: screenSize.width*1.22)
        let cellRow = UINib(nibName: "LoadMoreCell", bundle: nil)
        self.tableViewHome.register(cellRow, forCellReuseIdentifier: "LoadMoreCell")
        
        createRefreshView()
        callEventService()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createRefreshView() {
        
        refreshView = LGRefreshView.init(scrollView: tableViewHome, refreshHandler: { ( ref ) in
            
            self.isRefreshing = true
             self.currentPage = 1
            self.callEventService()
            
        })
        refreshView.tintColor = Utility.UIColorFromRGB(rgbValue: 0x0A3866)
        refreshView.backgroundColor = UIColor.clear
    }
    
    // MARK: - IBActions
    
    @IBAction func guidelineBookClicked(_ sender: Any) {
        let storyBoard = AppConstants.APP_STORYBOARD.HOME
        
        let eduGuideVC = storyBoard.instantiateViewController(withIdentifier: "EducationGuideController") as! EducationGuideController
        self.navigationController?.pushViewController(eduGuideVC, animated:true)
    }
    
    @IBAction func eventClicked(_ sender: Any) {
        let storyBoard = AppConstants.APP_STORYBOARD.HOME
        
        let eventVC = storyBoard.instantiateViewController(withIdentifier: "EventController") as! EventController
        eventVC.eventsAll = self.events
        
        eventVC.shouldShowLoadingCell = self.shouldShowLoadingCell
        self.navigationController?.pushViewController(eventVC, animated:true)
    }
    
    
    @IBAction func faqClicked(_ sender: Any) {
        let storyBoard = AppConstants.APP_STORYBOARD.HOME
        
        let eventVC = storyBoard.instantiateViewController(withIdentifier: "FAQsController") as! FAQsController
        self.navigationController?.pushViewController(eventVC, animated:true)
    }
    
    @IBAction func ConsultClicked(_ sender: Any) {
        let contactVC = AppConstants.APP_STORYBOARD.SETTING.instantiateViewController(withIdentifier: "ContactUsController") as! ContactUsController
        self.navigationController?.pushViewController(contactVC
            , animated:true)
    }
    
    @IBAction func fullBrightClicked(_ sender: Any) {
        let storyBoard = AppConstants.APP_STORYBOARD.HOME
        
        let eventVC = storyBoard.instantiateViewController(withIdentifier: "FullBirghtController") as! FullBirghtController
        //eventVC.eventsAll = self.events
        
        //eventVC.shouldShowLoadingCell = self.shouldShowLoadingCell
        self.navigationController?.pushViewController(eventVC, animated:true)
    }
    @IBAction func studentVisaClicked(_ sender: Any) {
        let storyBoard = AppConstants.APP_STORYBOARD.HOME
        
        let eventVC = storyBoard.instantiateViewController(withIdentifier: "StudentVisaController") as! StudentVisaController
        self.navigationController?.pushViewController(eventVC, animated:true)
    }
    // MARK: - TableView Delegate & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shouldShowLoadingCell ? events.count + 1 : events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == events.count && shouldShowLoadingCell {
            let cell = tableViewHome.dequeueReusableCell(withIdentifier: "LoadMoreCell") as! LoadMoreCell
            return cell
        }else{
            let cell = tableViewHome.dequeueReusableCell(withIdentifier: "cell") as! HomeTableViewCell
            
            cell.setData(data: events[indexPath.row])
            return cell
        }

    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == events.count && shouldShowLoadingCell {
            currentPage += 1
            callEventService()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailVC = AppConstants.APP_STORYBOARD.HOME.instantiateViewController(withIdentifier: "EventDetailController") as! EventDetailController
        eventDetailVC.eventData = events[indexPath.row]
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
        //self.navigationController?.pushViewController(eventDetailVC, animated: true)
        
      /*  eventDetailVC.updateEventData = { event in
            let index = self.events.index(where: {$0.id == event.id})!
            
            self.events[index] = event
        }*/
    }

    
    // MARK: - APIS
    func callEventService(){
        
        if !Connectivity.isConnectedToInternet {
            self.view.makeToast(AppString.internetUnreachable, duration: 1.5, position: .center)
            self.refreshView.endRefreshing()
            return
        }
        
        let parameter:[String:Any] = ["user_id":(Singleton.sharedInstance.userData?.id)!,"offset":String(currentPage)]
        
        if !isRefreshing && !shouldShowLoadingCell {
            self.showNormalHud(NSLocalizedString("Loading...", comment: ""))
        }
        
        EventBase.getEvents(urlPath: BASE_URL+EVENT, parameter: parameter, vc: self) { (data) in
            
            
            self.removeNormalHud()
            self.refreshView.endRefreshing()
            if data.code != 200 {
                self.view.makeToast(data.message, duration: 1.5, position: .center)
                return
            }
            
            
            if self.shouldShowLoadingCell {
                self.events += Array((data.result?.events)!)
            }else{
                self.events = Array((data.result?.events)!)
            }
            
            self.shouldShowLoadingCell = self.currentPage < data.pages
            
            self.tableViewHome.reloadData()
            
        }
    }
    


}
