//
//  EducationGuideController.swift
//  EducationUSA
//
//  Created by XEONCITY on 27/12/2017.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import Hero
import LGRefreshView

class EducationGuideController: BaseController , UITextFieldDelegate{
    
    var images = ["eduGuid1","eduGuid2","eduGuid3","eduGuid4","eduGuid5","eduGuid6"]

    @IBOutlet weak var educationGuidTableView: UITableView!
    
    var refreshView:LGRefreshView!
    var isRefreshing:Bool = false
    var guideLines:[EduGuidesEducationGuide] = [EduGuidesEducationGuide]()
    var guideLinesAll:[EduGuidesEducationGuide] = [EduGuidesEducationGuide]()
    
    var currentPage = 1
    var shouldShowLoadingCell = false
    
    override func viewDidLoad() {
        currentController = Controllers.EducationGuide
        super.viewDidLoad()
        
        let cellRow = UINib(nibName: "LoadMoreCell", bundle: nil)
        self.educationGuidTableView.register(cellRow, forCellReuseIdentifier: "LoadMoreCell")
        
        callEduGuideService(searchText: "")
        createRefreshView()
        // Do any additional setup after loading the view.
        //isHeroEnabled = true
        //educationGuidTableView.heroModifiers = [.cascade]
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
        
        refreshView = LGRefreshView.init(scrollView: educationGuidTableView, refreshHandler: { ( ref ) in
            
            self.isRefreshing = true
            self.currentPage = 1
            self.callEduGuideService(searchText: self.txtSearch?.text ?? "")
            
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
        callEduGuideService(searchText: (txtSearch?.text)!)
        viewSearchBar.removeFromSuperview()
        viewSearchBar = nil
        
    }
    

    //MARK:- TextField Delegate and Actions
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        //print(textField)
//        
//        if(textField.text?.isEmpty)!{
//            //reload your data source if necessary
//            guideLines = guideLinesAll
//            //self.educationGuidTableView.reloadData()
//            self.educationGuidTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
//            
//        }else{
//            guideLines = (guideLinesAll.filter() {
//                if let title = ($0 as EduGuidesEducationGuide).name?.lowercased() as String! {
//                    return title.contains((textField.text?.lowercased())!)
//                }else {
//                    return false
//                }
//            })
//            //self.educationGuidTableView.reloadData()
//            self.educationGuidTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
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
        callEduGuideService(searchText: (txtSearch?.text)!)
        return true
    }
    
    // MARK: - APIS
    func callEduGuideService(searchText:String){
        
        if !Connectivity.isConnectedToInternet {
            self.view.makeToast(AppString.internetUnreachable, duration: 1.5, position: .center)
            if refreshView != nil {
                self.refreshView.endRefreshing()
            }
            
            return
        }
        
        var parameter:[String:Any] = ["user_id":(Singleton.sharedInstance.userData?.id)!,"device_token":Singleton.sharedInstance.deviceToken ,"offset":String(currentPage)]
        
        if(self.txtSearch?.text?.isEmpty != true && self.txtSearch?.text != nil){
            parameter["search"] = searchText
        }

        
        if !isRefreshing && !shouldShowLoadingCell {
            self.showNormalHud(NSLocalizedString("Loading...", comment: ""))
        }
        
        EduGuidesBase.getEduGuidelines(urlPath: BASE_URL+EDU_GUIDE, parameter: parameter, vc: self) { (data) in
            self.refreshView.endRefreshing()
            self.removeNormalHud()
            self.isRefreshing = false
            if data.code != 200 {
                self.view.makeToast(data.message, duration: 1.5, position: .center)
                return
            }
            
            if self.shouldShowLoadingCell {
                self.guideLines += Array((data.result?.educationGuide)!)
                //self.guideLinesAll = Array((data.result?.educationGuide)!)
            }else{
                self.guideLines = Array((data.result?.educationGuide)!)
                //self.guideLinesAll = Array((data.result?.educationGuide)!)
            }
            
            
            self.shouldShowLoadingCell = self.currentPage < data.pages
            
            //self.educationGuidTableView.reloadData()
            
            self.educationGuidTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
        }
    }

}

extension EducationGuideController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (Constants.kWINDOW_WIDTH*0.45)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return shouldShowLoadingCell ? guideLines.count + 1 : guideLines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == guideLines.count && shouldShowLoadingCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell") as! LoadMoreCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "educationGuideCell") as! EducationGuideCell
            
          //  cell.heroModifiers = [.fade, .translate(x:-100)]
          //  cell.cellBgImgView?.image = UIImage(named: images[indexPath.row])
            cell.setData(data:guideLines[indexPath.row])
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == guideLines.count && shouldShowLoadingCell {
            currentPage += 1
            callEduGuideService(searchText: "")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let eduGuideDetailVC = AppConstants.APP_STORYBOARD.HOME.instantiateViewController(withIdentifier: "EducationGuideDetailController") as! EducationGuideDetailController
//        eduGuideDetailVC.eduData = self.guideLines[indexPath.row]
//        self.navigationController?.pushViewController(eduGuideDetailVC, animated:true)
        
        let eduGuideDetailVC = AppConstants.APP_STORYBOARD.HOME.instantiateViewController(withIdentifier: "EducationGuideDetailWebViewController") as! EducationGuideDetailWebViewController
        eduGuideDetailVC.eduData = self.guideLines[indexPath.row]
        self.navigationController?.pushViewController(eduGuideDetailVC, animated:true)
        
    }
}


