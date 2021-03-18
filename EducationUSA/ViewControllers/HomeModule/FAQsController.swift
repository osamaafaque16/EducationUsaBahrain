//
//  FAQsController.swift
//  EducationUSA
//
//  Created by XEONCITY on 31/12/2017.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import ExpyTableView
import LGRefreshView

class FAQsController: BaseController, UITextFieldDelegate {

    @IBOutlet weak var noRecordView: UIStackView!
    var refreshView:LGRefreshView!
    var isRefreshing:Bool = false
    
    var faqData:[FAQFaq] = [FAQFaq]()
    var faqAllData:[FAQFaq] = [FAQFaq]()
    var currentPage = 1
    var shouldShowLoadingCell = false
    
    @IBOutlet weak var expendTableView: ExpyTableView!
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad() {
        currentController = Controllers.FAQS
        super.viewDidLoad()
  
        noRecordView.isHidden = true
        // Do any additional setup after loading the view.
        
        expendTableView.dataSource = self
        expendTableView.delegate = self
        
        expendTableView.rowHeight = UITableViewAutomaticDimension
        expendTableView.estimatedRowHeight = 44
        
        //Alter the animations as you want
        expendTableView.expandingAnimation = .fade
        expendTableView.collapsingAnimation = .fade
        
        let cellRow = UINib(nibName: "LoadMoreCell", bundle: nil)
        self.expendTableView.register(cellRow, forCellReuseIdentifier: "LoadMoreCell")
        
        createRefreshView()
        
        callFaqService(searchText: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (viewSearchBar != nil ) {
            viewSearchBar.removeFromSuperview()
            viewSearchBar = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createRefreshView() {
        
        refreshView = LGRefreshView.init(scrollView: expendTableView, refreshHandler: { ( ref ) in
            
            self.isRefreshing = true
            self.callFaqService(searchText: self.txtSearch?.text ?? "")
            
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
        shouldShowLoadingCell = false
        currentPage = 1
        callFaqService(searchText: (self.txtSearch?.text)!)
        viewSearchBar.removeFromSuperview()
        viewSearchBar = nil

    }

    
    //MARK:- TextField Delegate and Actions
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        //print(textField)
        
//        if(textField.text?.isEmpty)!{
//            //reload your data source if necessary
//            faqData = faqAllData
//            self.expendTableView.reloadData()
//            
//        }else{
//            faqData = (faqAllData.filter() {
//                if let title = ($0 as FAQFaq).name?.lowercased() as String! {
//                    return title.contains((textField.text?.lowercased())!)
//                }else {
//                    return false
//                }
//            })
//            
//            self.expendTableView.reloadData()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        txtSearch?.resignFirstResponder()
        currentPage = 1
        shouldShowLoadingCell = false
        callFaqService(searchText: (txtSearch?.text)!)
        return true
    }
    
    // MARK: - APIS
    func callFaqService(searchText:String){
        
        if !Connectivity.isConnectedToInternet {
            self.view.makeToast(AppString.internetUnreachable, duration: 1.5, position: .center)
            self.refreshView.endRefreshing()
            return
        }
        
        var parameter:[String:Any] = ["user_id":(Singleton.sharedInstance.userData?.id)!,"device_token":Singleton.sharedInstance.deviceToken,"offset":String(currentPage)]
        
        if(self.txtSearch?.text?.isEmpty != true && self.txtSearch?.text != nil){
            parameter["search"] = searchText
        }
        
        if !isRefreshing && !shouldShowLoadingCell {
            self.showNormalHud(NSLocalizedString("Loading...", comment: ""))
        }
        
        FAQBase.getFAQs(urlPath: BASE_URL+FAQ, parameter: parameter, vc: self) { (data) in
            self.refreshView.endRefreshing()
            self.removeNormalHud()
            self.isRefreshing = false
            if data.code != 200 {
                self.view.makeToast(data.message, duration: 1.5, position: .center)
                return
            }
            
            if self.shouldShowLoadingCell {
                self.faqData += Array((data.result?.faq)!)
                //self.faqAllData = Array((data.result?.faq)!)
            }else{
                self.faqData = Array((data.result?.faq)!)
                //self.faqAllData = Array((data.result?.faq)!)
            }
            
            self.shouldShowLoadingCell = self.currentPage < data.pages

            
            if self.faqData.count > 0 {
                self.expendTableView.isHidden = false
                self.noRecordView.isHidden = true
            }else{
                self.expendTableView.isHidden = true
                self.noRecordView.isHidden = false
            }
            
            self.expendTableView.reloadData()

        }
    }



}
// MARK: - Expending TableView Delegate
extension FAQsController: ExpyTableViewDataSource , ExpyTableViewDelegate {
    func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
        if section == faqData.count && shouldShowLoadingCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell") as! LoadMoreCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FAQSectionCell") as! FAQSectionCell
            
            cell.lblQuestion.text = faqData[section].name
            cell.lblQuesNo.text = String(section+1)+"."
            if faqData[section].descriptionValue == nil {
                cell.canAnimate = false
            }
            return cell
        }

    }
    
    func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
//        print(faqData[section].guidelineId)
//        let data = faqData[section]
//        if(data.guidelineId != 0) {
//            return false
//        }
        return true
    }
    
    func canExpand(section: Int, inTableView tableView: ExpyTableView) -> Bool {
//        print(faqData[section].guidelineId)
//        let data = faqData[section]
//        if(data.guidelineId != 0) {
//            return false
//        }
        return true
    }
    
   /* func expandableCell(forSection section: Int, inTableView tableView: ExpyTableView) -> UITableViewCell {
        
        if section == faqData.count && shouldShowLoadingCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell") as! LoadMoreCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FAQSectionCell") as! FAQSectionCell
            
            cell.lblQuestion.text = faqData[section].name
            cell.lblQuesNo.text = String(section+1)+"."
            return cell
        }

    }
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        return shouldShowLoadingCell ? faqData.count + 1 : faqData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if faqData[section].descriptionValue == nil{
            return 1
        }
        else{
            return 2

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // If you define a cell as expandable and return it from expandingCell data source method,
        // then you will not get callback for IndexPath(row: 0, section: indexPath.section) here in cellForRowAtIndexPath
        //But if you define the same cell as -sometimes not expandable- you will get callbacks for not expandable cells here and you must return a cell for IndexPath(row: 0, section: indexPath.section) in here besides in expandingCell. You can return the same cell from expandingCell method and here.
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQExpendCell") as! FAQExpendCell
       // let check = faqData[indexPath.section].descriptionValue!
      //  let str = check.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
       // cell.lblAns.text = faqData[indexPath.section].descriptionValue
//        var htmText = faqData[indexPath.section].descriptionValue
//        cell.textViewDescription.attributedText = htmText?.htmlToAttributedString
//        print(faqData[indexPath.section].guidelineId)
        let data = faqData[indexPath.section]
        cell.setData(data: data)
        return cell


        
    }
    

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == faqData.count && shouldShowLoadingCell {
            currentPage += 1
            callFaqService(searchText: "")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //If you don't deselect the row here, seperator of the above cell of the selected cell disappears.
        //Check here for detail: https://stackoverflow.com/questions/18924589/uitableviewcell-separator-disappearing-in-ios7
        
        tableView.deselectRow(at: indexPath, animated: false)
        print(faqData[indexPath.section].descriptionValue)
        
        if faqData[indexPath.section].descriptionValue == nil {
            let eduGuideDetailVC = AppConstants.APP_STORYBOARD.HOME.instantiateViewController(withIdentifier: "EducationGuideDetailController") as! EducationGuideDetailController
            eduGuideDetailVC.eduGuidelineId = faqData[indexPath.section].guidelineId
            self.navigationController?.pushViewController(eduGuideDetailVC, animated:true)
        }
        //This solution obviously has side effects, you can implement your own solution from the given link.
        //This is not a bug of ExpyTableView hence, I think, you should solve it with the proper way for your implementation.
        //If you have a generic solution for this, please submit a pull request or open an issue.
        
        print("DID SELECT row: \(indexPath.row), section: \(indexPath.section)")
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UI
//    }
}

//extension FAQsController: UITextViewDelegate{
//    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//        let urlString = URL.absoluteString
//        if urlString.contains("terms"){
//            super.pushToTermsOfServices()
//        }
//        if urlString.contains("policy"){
//            super.pushToPrivacyPolicy()
//        }
//        return false
//    }
//}




