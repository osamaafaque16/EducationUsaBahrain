//
//  ContactUsController.swift
//  EducationUSA
//
//  Created by Shujaat Ali Khan on 1/21/18.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit

class ContactUsController: BaseController {
    @IBOutlet weak var contactUsTableView: UITableView!
    
    var contactData:ContactUsContact?
    
    var socialMediaCount:Int = 0

    override func viewDidLoad() {
        currentController = Controllers.ContactUs
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contactUsTableView.rowHeight = UITableViewAutomaticDimension
        contactUsTableView.estimatedRowHeight = 100
        
        callContactUsService()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func pushToChatController() {
        if Singleton.sharedInstance.isGuest == true {
            self.showAlert(title: NSLocalizedString("Alert!", comment: ""), subTitle: NSLocalizedString("Guest can't start chat, Kindly Login", comment: ""), doneBtnTitle: nil, buttons: [NSLocalizedString("Login", comment: ""),NSLocalizedString("Cancel", comment: "")], type: "guest")
        }else{
            
            let contactVC = AppConstants.APP_STORYBOARD.CHAT.instantiateViewController(withIdentifier: "AgentChatViewController") as! AgentChatViewController
            
            self.lblTitle.text = ""
            self.navigationController?.pushViewController(contactVC
                , animated:true)
        }

    }
    
    
    //MARK:- APIS
    func callContactUsService() {
        
        if !Connectivity.isConnectedToInternet {
            self.view.makeToast(AppString.internetUnreachable, duration: 1.5, position: .center)
            return
        }
        

        let parameter:[String:Any] = ["user_id":(Singleton.sharedInstance.userData?.id)!]
        
        
        self.showNormalHud(NSLocalizedString("Loading...", comment: ""))
        
        
        ContactUsBase.getContactDetail(urlPath: BASE_URL+CONTACTUS, parameter: parameter, vc: self) { (data) in
            
            self.removeNormalHud()
            
            if data.code != 200 {
                self.view.makeToast(data.message, duration: 1.5, position: .center)
                return
            }
            self.contactUsTableView.dataSource = self
            self.contactUsTableView.delegate = self
            self.contactData = data.result?.contact
            self.contactUsTableView.reloadData()
        }
    }



}

extension ContactUsController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = (contactData?.web.count)!+(contactData?.address.count)!+(contactData?.facebook.count)!+(contactData?.instagram.count)!+(contactData?.twitter.count)!

        return count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsChatCell") as! ContactUsChatCell
            cell.lblAboutUs.text = contactData?.aboutUs
            
            cell.btnChatCallBack = { [weak self] in
                self?.pushToChatController()
            }
            
            return cell
            
        case 1..<(contactData?.address.count)!+1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsInfoCell") as! ContactUsInfoCell
            cell.contactController = self
            cell.setData(data: (contactData?.address[indexPath.row-1])!)

            return cell
            
        case (contactData?.address.count)!+1..<(contactData?.address.count)!+(contactData?.web.count)!+1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsWebCell") as! ContactUsWebCell
            let index = indexPath.row-((contactData?.address.count)!+1)
            cell.setData(data:(contactData?.web[index])!)
            return cell
            
        case (contactData?.address.count)!+(contactData?.web.count)!+1..<(contactData?.address.count)!+(contactData?.web.count)!+(contactData?.facebook.count)!+1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsSocialCell") as! ContactUsSocialCell
            let index = indexPath.row-((contactData?.address.count)!+(contactData?.web.count)!+1)
            cell.setData(contactData?.facebook[index] as Any, "fb", Index: index)
            
//            if index == ((contactData?.facebook.count)!-1) {
//                cell.bottomSpacing.constant = 8
//            }

            return cell
            
        case (contactData?.address.count)!+(contactData?.web.count)!+(contactData?.facebook.count)!+1..<(contactData?.address.count)!+(contactData?.web.count)!+(contactData?.facebook.count)!+(contactData?.instagram.count)!+1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsSocialCell") as! ContactUsSocialCell
            let index = indexPath.row-((contactData?.address.count)!+(contactData?.web.count)!+(contactData?.facebook.count)!+1)
            cell.setData(contactData?.instagram[index] as Any, "insta", Index: index)
//            if index == ((contactData?.instagram.count)!-1) {
//                cell.bottomSpacing.constant = 10
//            }

            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsSocialCell") as! ContactUsSocialCell
            let index = indexPath.row-((contactData?.address.count)!+(contactData?.web.count)!+(contactData?.facebook.count)!+(contactData?.instagram.count)!+1)
            
            cell.setData(contactData?.twitter[index] as Any, "twit", Index: index)
//            if index == ((contactData?.twitter.count)!-1) {
//                cell.bottomSpacing.constant = 10
//            }

            return cell
        }
        
        
        
        
        
    }
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        switch indexPath.row {
//        case 0:
//            let contactVC = AppConstants.APP_STORYBOARD.CHAT.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
//            contactVC.chanel = Singleton.sharedInstance.agentChatChannel()
//            lblTitle.text = ""
//            self.navigationController?.pushViewController(contactVC
//                , animated:true)
//
//            break
//        default:
//            break
//        }
//
//    }
}
