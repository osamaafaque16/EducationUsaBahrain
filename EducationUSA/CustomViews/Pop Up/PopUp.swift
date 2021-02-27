//
//  PopUp.swift
//  Aroma
//
//  Created by Avinash Kumar on 8/16/17.
//  Copyright © 2017 Avinash Kumar. All rights reserved.
//

import UIKit
import EZAlertController
import RealmSwift

class PopUp: UIView , UITableViewDelegate,UITableViewDataSource{
    
    //callBacks
    var openAttachment : ((_ index:Int) -> Void)?
    
    @IBOutlet weak var lblComments: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var tableViewAttachment: UITableView!
    
    var attachmentData:List<EduGuidesAttachment> = List<EduGuidesAttachment>()
    
    override func awakeFromNib() {
        
        showAnimate()
        
        tableViewAttachment.dataSource = self
        tableViewAttachment.delegate = self
        tableViewAttachment.register(UITableViewCell.self, forCellReuseIdentifier: "AttachmentCell")
        tableViewAttachment.rowHeight = UITableViewAutomaticDimension
        tableViewAttachment.estimatedRowHeight = 100
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }

    
    @IBAction func btnScreenPressed(_ sender: Any) {
        //self.removeFromSuperview()
        removeAnimate()

    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 0.0
            self.view.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
        }) { (success) in
            self.removeFromSuperview()
        }

    }
    
    //MARK:- TableView delegate and DataScource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attachmentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttachmentCell")
        cell?.selectionStyle = .none
        cell?.textLabel?.numberOfLines = 3
        cell?.textLabel?.textColor = UIColor.darkGray
        cell?.textLabel?.text = attachmentData[indexPath.row].file
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        openAttachment!(indexPath.row)
    }
}
