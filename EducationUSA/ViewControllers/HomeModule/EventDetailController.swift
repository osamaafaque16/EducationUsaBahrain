     //
//  EventDetailController.swift
//  EducationUSA
//
//  Created by XEONCITY on 04/01/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit
import GoogleMaps
import AlamofireImage

     
     
class EventDetailController: BaseController {
    
    //callBacks
    var updateEventData : ((_ event:EventEvents) -> Void)?
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var textViewEventDescription: UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblFor: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var stackViewLocation: UIStackView!
    @IBOutlet weak var mapViewTopSpacing: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    var eventData:EventEvents?
    var pdfUrl = ""
    
    var fromNotification:Bool = false
    var eventId :String?
    var notiId :String?
    var actionType:String?
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        currentController = Controllers.EventDetail
        super.viewDidLoad()
        textViewEventDescription.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        
        // Do any additional setup after loading the view.
        
        scrollView.isHidden = true
        
        //btnFollow.isHidden = true

        if fromNotification {
            callEventService()
        }else{
            setData()
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblTitle.text = eventData?.name.uppercased()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textViewHeight.constant = textViewEventDescription.intrinsicContentSize.height
        print(textViewEventDescription.intrinsicContentSize.height)
        
        


    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        if eventData?.location == nil {
//            mapViewTopSpacing.constant = -(viewMap.frame.height)
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onBtnDownload(_ sender: UIButton) {
    
        print("Download start")
      
//        guard let url = URL(string: "https://www.tutorialspoint.com/swift/swift_tutorial.pdf")else {return}
//        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
//        let downloadTask = urlSession.downloadTask(with: url)
//        downloadTask.resume()
      
        downloadFile()

    
    }
    
    func setData() {
        
        let URL = Foundation.URL(string: eventData?.image ?? "")
        imgEvent.image = UIImage(named: "no-image")?.af_imageAspectScaled(toFill: imgEvent.frame.size)
        if URL != nil
        {
            
            imgEvent.af_setImage(
                withURL: URL!,
                placeholderImage:UIImage(named: "no-image")?.af_imageAspectScaled(toFill: imgEvent.frame.size),
                filter: AspectScaledToFillSizeFilter(size: imgEvent.frame.size),
                imageTransition: .crossDissolve(0.3)
            )
        }
        
        lblTitle.text = eventData?.name
        
        if eventData?.location == nil {
            //mapViewTopSpacing.constant = -(viewMap.frame.height)
           // viewMap.isHidden = true
        }
        eventTitle.text = eventData?.name
       // lblFor.text = eventData?.audience
      //  lblType.text = eventData?.type

        //btnFollow.isSelected = eventData?.isFollow == "1" ? true:false
        
        if let location = eventData?.location {
            lblLocation.text = location
            //configureMap()
        }else{
            
            stackViewLocation.isHidden = true
            viewMap.isHidden = true
            //eventTitle.isHidden = true
        }
        
        let dateComponents = Utility.getDateComponents((eventData?.eventDate)!)!
        let strDate = Utility.getDateFormat(date: (eventData?.eventDate)!, In: "yyy-MM-dd HH:mm:ss", Out: "EEEE, MMMM dd, yyyy")
        let strTime = Utility.getDateFormat(date: (eventData?.startTime)!, In: "HH:mm:ss", Out: "hh:mm a")
        let endTime = Utility.getDateFormat(date: (eventData?.endTime)!, In: "HH:mm:ss", Out: "hh:mm a")
        lblTime.text = "\(strTime) to \(endTime)"
        lblDate.text = strDate
//        switch (dateComponents.weekday!)
//        {
//
//        case 1:
//            lblDateTime.text = NSLocalizedString("Sunday", comment: "")+" "+strDate
//            break
//
//        case 2:
//            lblDateTime.text = NSLocalizedString("Monday", comment: "")+" "+strDate
//            break
//
//        case 3:
//            lblDateTime.text = NSLocalizedString("Tuesday", comment: "")+" "+strDate
//            break
//
//        case 4:
//            lblDateTime.text = NSLocalizedString("Wednesday", comment: "")+" "+strDate
//            break
//        case 5:
//            lblDateTime.text = NSLocalizedString("Thursday", comment: "")+" "+strDate
//            break
//
//        case 6:
//            lblDateTime.text = NSLocalizedString("Friday", comment: "")+" "+strDate
//            break
//
//        case 7:
//            lblDateTime.text = NSLocalizedString("Saturday", comment: "")+" "+strDate
//            break
//
//        default:
//            break
//
//
//        }
        DispatchQueue.main.async {
            
            self.textViewEventDescription.attributedText = self.eventData?.descriptionValue.convertHtml()
            let attString = NSMutableAttributedString(attributedString: (self.eventData?.descriptionValue.convertHtml())!)
            let attStrin1 = attString.setFontFace(font: UIFont(name: "Roboto-Regular", size: 15.0)!)
            self.textViewEventDescription.attributedText = attString.attributedSubstring(from: NSMakeRange(0, attString.length))
//            Utility.delay(delay: 0.0) {
//                self.textViewHeight.constant = self.textViewEventDescription.intrinsicContentSize.height - 80
//            }
            
        }
        
//        textViewHeight.constant = textViewEventDescription.intrinsicContentSize.height
//        print(textViewEventDescription.intrinsicContentSize.height)
        
        scrollView.isHidden = false
    }
    
    func configureMap() {
//        guard let lat = eventData?.latitude else {
//            return
//        }
//        guard let long = eventData?.longitude else {
//            return
//        }
        let latitude = Double((eventData?.latitude)!)
        let longitude = Double((eventData?.longitude)!)
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude!, longitude: longitude!, zoom: 13.0)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
        marker.map = self.viewMap
        
        self.viewMap.animate(to: camera)
        self.viewMap.isMyLocationEnabled = true
    }
    
    @IBAction func followClicked(_ sender: UIButton) {
        
        if Singleton.sharedInstance.isGuest == true {
            self.showAlert(title: NSLocalizedString("Alert!", comment: ""), subTitle: NSLocalizedString("Guest can't follow event, Kindly Login", comment: ""), doneBtnTitle: nil, buttons: [NSLocalizedString("Login", comment: ""),NSLocalizedString("Cancel", comment: "")], type: "guest")
        }else{
            callFollowService()
        }
  
    }
    
    
    //MARK:- APIS

    func callEventService(){
        
        if !Connectivity.isConnectedToInternet {
            self.view.makeToast(AppString.internetUnreachable, duration: 1.5, position: .center)
            return
        }
        
        let parameter:[String:Any] = ["user_id":(Singleton.sharedInstance.userData?.id)!,"ref_id":eventId!,"notification_id":notiId!,"action_type":actionType!]
        
        self.showNormalHud(NSLocalizedString("Loading...", comment: ""))

        
        EventBase.getEvents(urlPath: BASE_URL+NOTI_DATA, parameter: parameter, vc: self) { (data) in
            
            self.removeNormalHud()

            if data.code != 200 {
                self.view.makeToast(data.message, duration: 1.5, position: .center)
                return
            }
            
            self.eventData = data.result?.event
            self.setData()
            
        }
    }
    
    func callFollowService() {
        
        if !Connectivity.isConnectedToInternet {
            self.view.makeToast(AppString.internetUnreachable, duration: 1.5, position: .center)
            return
        }
        self.showNormalHud("")
        let isFollow = btnFollow.isSelected == true ? "0":"1"
        
        let parameters:[String:Any] = [ "user_id" : (Singleton.sharedInstance.userData?.id)!,
                                        "device_token" : Singleton.sharedInstance.deviceToken,
                                        "event_id" : String((eventData?.id)!),
                                        "response" :  isFollow]
        
        EventBase.followRequest(urlPath: BASE_URL+EVENT_FOLLOW, parameters: parameters, vc: self) { (data) in
            self.removeNormalHud()
            if data.code != 200 {
                self.view.makeToast(data.message, duration: 1.5, position: .center)
                return
            }
            
            self.btnFollow.isSelected = !self.btnFollow.isSelected
            self.eventData?.isFollow = isFollow
            //self.updateEventData!(self.eventData!)
        }
    }

}
     extension NSMutableAttributedString {
         func setFontFace(font: UIFont, color: UIColor? = nil) {
             beginEditing()
             self.enumerateAttribute(
                 .font,
                 in: NSRange(location: 0, length: self.length)
             ) { (value, range, stop) in

                 if let f = value as? UIFont,
                   let newFontDescriptor = f.fontDescriptor
                     .withFamily(font.familyName)
                     .withSymbolicTraits(f.fontDescriptor.symbolicTraits) {

                     let newFont = UIFont(
                         descriptor: newFontDescriptor,
                         size: font.pointSize
                     )
                     removeAttribute(.font, range: range)
                     addAttribute(.font, value: newFont, range: range)
                     if let color = color {
                         removeAttribute(
                             .foregroundColor,
                             range: range
                         )
                         addAttribute(
                             .foregroundColor,
                             value: color,
                             range: range
                         )
                     }
                 }
             }
             endEditing()
         }
     }

//extension EventDetailController : URLSessionDownloadDelegate {
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        print("File Downloaded Location- ",  location)
//
//        guard let url = downloadTask.originalRequest?.url else {
//            return
//        }
//        let docsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
//        let destinationPath = docsPath.appendingPathComponent(url.lastPathComponent)
//
//        try? FileManager.default.removeItem(at: destinationPath)
//
//        do{
//            try FileManager.default.copyItem(at: location, to: destinationPath)
//            //self.pdfUrl = destinationPath
//           // print("File Downloaded Location- ",  self.pdfUrl ?? "NOT")
//        }catch let error {
//            print("Copy Error: \(error.localizedDescription)")
//        }
//    }
//}
     
extension EventDetailController{
      
    func downloadFile(){
        if let url = eventData?.eventURL{
        //let url = eventData?.eventURL
        let fileName = ""
        let message = "Downloaded Event Flyer"
        self.view.makeToast(message, duration: 1.5, position: .center)
        
        savePdf(urlString: url, fileName: fileName)
        }
      
    }

    func savePdf(urlString:String, fileName:String) {
            DispatchQueue.main.async {
                let url = URL(string: urlString)
                let pdfData = try? Data.init(contentsOf: url!)
                let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                let pdfNameFromUrl = "EducationUsa-Bahrain\(fileName).pdf"
                let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
                do {
                    try pdfData?.write(to: actualPath, options: .atomic)
                    print("pdf successfully saved!")
    //file is downloaded in app data container, I can find file from x code > devices > MyApp > download Container >This container has the file
                } catch {
                    print("Pdf could not be saved")
                }
            }
        }
     }
