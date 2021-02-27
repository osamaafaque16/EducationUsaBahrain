//
//  ProfileController.swift
//  AROMA
//
//  Created by Aurangzaib Khan on 8/25/17.
//  Copyright © 2017 Aurangzaib Khan. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import AlamofireImage
import RealmSwift
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class ProfileController: BaseController,UIScrollViewDelegate
{
    //MARK:- IBOutlets
    @IBOutlet weak var imgTest: UIImageView!
    @IBOutlet weak var imgEditProfile: UIImageView!
    @IBOutlet weak var hideBorder: UIView!
    @IBOutlet weak var btnUploadImage: UIButton!
    @IBOutlet weak var imgBorder: UIView!
    //@IBOutlet weak var btnGender: UIButton!
    //@IBOutlet weak var btnNationality: UIButton!
    //@IBOutlet weak var btnAge: UIButton!
    @IBOutlet weak var txtfldName: UITextField!
  //  @IBOutlet weak var btnCode: UIButton!
  //  @IBOutlet weak var btnCodeArrow: UIButton!
    //@IBOutlet weak var btnAddress: UIButton!
    
   // @IBOutlet weak var txtFldPhoneNo: UITextField!
    //@IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var stackViewEmail: UIStackView!
    @IBOutlet weak var btnEditProfile: UIButton!
    
    
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblNationality: UILabel!
    @IBOutlet weak var lblAge: UILabel!
//    @IBOutlet weak var txtfldName: UITextField!
//    @IBOutlet weak var btnCode: UIButton!
//    @IBOutlet weak var btnCodeArrow: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblFldPhoneNo: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var rounderView: UIView!
//
//    @IBOutlet weak var txtFldPhoneNo: UITextField!
    
//    @IBOutlet weak var stackViewEmail: UIStackView!
//    @IBOutlet weak var btnEditProfile: UIButton!
    
    //MARK:- Variables
    let imagePicker = UIImagePickerController()
    var imgProfile: UIImage? = nil

    var pickerViewObj:PickerView!
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad() {
        currentController = Controllers.Profile
        super.viewDidLoad()
        btnEditProfile.layer.shadowRadius = 3.0
        btnEditProfile.layer.shadowColor = UIColor.black.cgColor
        btnEditProfile.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        btnEditProfile.layer.shadowOpacity = 0.2
        btnEditProfile.layer.masksToBounds = false
        
        rounderView.layer.shadowRadius = 2.0
        rounderView.layer.shadowColor = UIColor.black.cgColor
        rounderView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        rounderView.layer.shadowOpacity = 0.1
        rounderView.layer.masksToBounds = false
        
        
        pickerViewObj = Bundle.main.loadNibNamed("PickerView", owner: self, options: nil)?.last as? PickerView
        pickerViewObj.frame = view.frame
        
        txtfldName.delegate = self
        
        btnUploadImage.isHidden = true
       /// btnCode.isUserInteractionEnabled = false
       /// btnCodeArrow.isUserInteractionEnabled = false
        //btnNationality.isUserInteractionEnabled = false
        //btnGender.isUserInteractionEnabled = false
       // btnAge.isUserInteractionEnabled = false
        txtfldName.isUserInteractionEnabled = false
       // btnAge.isUserInteractionEnabled = false//
        //btnAddress.isUserInteractionEnabled = false
      //  txtFldEmail.isUserInteractionEnabled = false
      //  txtFldPhoneNo.isUserInteractionEnabled = false
        
      //  txtFldPhoneNo.placeholder = NSLocalizedString("Enter mobile no", comment: "")
        
        setData()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        setData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setBorder()

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // scrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y <= 0) {
            scrollView.contentOffset = CGPoint.zero;
        }
    }
    
    func setBorder() {
        imgEditProfile.layer.cornerRadius = imgEditProfile.frame.size.height/2
        imgEditProfile.layer.masksToBounds = false
        imgEditProfile.clipsToBounds = true
        self.imgEditProfile.layer.borderWidth = 4
        self.imgEditProfile.layer.borderColor = UIColor.white.cgColor

    }

    func setData() {
        
        let URL = Foundation.URL(string: Singleton.sharedInstance.userData?.userImage ?? "")
        
        //print(URL!)
        if URL != nil
        {
            imgEditProfile.af_setImage(
                withURL: URL!,
                placeholderImage:#imageLiteral(resourceName: "noimage"),
                filter: AspectScaledToFillSizeFilter(size: imgEditProfile.frame.size),
                imageTransition: .crossDissolve(0.3)
            )
        }
        
        txtfldName.text = Singleton.sharedInstance.userData?.name ?? "N/A"
       // lblNationality.text = Singleton.sharedInstance.userData?.country ?? NSLocalizedString("Country", comment: "")
        //btnNationality.setTitle(Singleton.sharedInstance.userData?.country ?? NSLocalizedString("Country", comment: ""), for: .normal)
        //btnGender.setTitle(Singleton.sharedInstance.userData?.gender ?? NSLocalizedString("Gender", comment: ""), for: .normal)
        
    lblNationality.text = Singleton.sharedInstance.userData?.country ?? " "
        lblAge.text = Singleton.sharedInstance.userData?.dob ?? NSLocalizedString("DOB", comment: "")
        
        lblAddress.text = Singleton.sharedInstance.userData?.address ?? " "
        
        lblEmail.text = Singleton.sharedInstance.userData?.email ?? " "
        
        lblAge.text = Singleton.sharedInstance.userData?.dob ?? " "
        
        lblFldPhoneNo.text = (Singleton.sharedInstance.userData?.countryCode ?? " ") + (Singleton.sharedInstance.userData?.phone ?? " ")
       // btnAge.setTitle(Singleton.sharedInstance.userData?.dob ?? NSLocalizedString("DOB", comment: ""), for: .normal)
       // btnCode.setTitle(Singleton.sharedInstance.userData?.countryCode ?? NSLocalizedString("Code", comment: ""), for: .normal)
       // btnAddress.setTitle(Singleton.sharedInstance.userData?.address ?? NSLocalizedString("Location", comment: ""), for: .normal)
      //  txtFldPhoneNo.text = Singleton.sharedInstance.userData?.phone ?? NSLocalizedString("Phone", comment: "")
        //txtFldEmail.text = Singleton.sharedInstance.userData?.email
        
        

        
        
        if Singleton.sharedInstance.userData?.gender != nil {
            
            let pre = Locale.preferredLanguages[0]
            if pre.hasPrefix("en") {
                if  Singleton.sharedInstance.userData?.gender == "Male" || Singleton.sharedInstance.userData?.gender == "ذكر" {
                    lblGender.text = "Male"
                    //btnGender.setTitle("Male" , for: .normal)
                }else{
                    lblGender.text = "Female"
                    //btnGender.setTitle("Female" , for: .normal)
                }
            }else{
                if  Singleton.sharedInstance.userData?.gender == "Male" || Singleton.sharedInstance.userData?.gender == "ذكر" {
                    lblGender.text = "ذكر"
                    //btnGender.setTitle("ذكر" , for: .normal)
                }else{
                    lblGender.text = "انثى"
                    //btnGender.setTitle("انثى", for: .normal)
                }
            }
            
            //btnGender.setTitle(NSLocalizedString(NSLocalizedString((Singleton.sharedInstance.userData?.gender)!, comment: ""), comment: "") , for: .normal)

        }else{
            lblGender.text = " "  //NSLocalizedString("Gender", comment: "")
            //btnGender.setTitle(NSLocalizedString("Gender", comment: ""), for: .normal)
        }

        
    }
    
    
    //MARK:- IBActions
    
    @IBAction func actionCodeButton(_ sender: Any) {
        
        view.addSubview(pickerViewObj)
        pickerViewObj.showAnimate()
        pickerViewObj.DoneCallback = {CountryCode,countryName in
            //self.btnCode.setTitle(CountryCode, for: .normal)
            self.pickerViewObj.removeAnimate()
            //self.pickerViewObj.removeFromSuperview()
            
        }
        pickerViewObj.CancelCallback = {
            self.pickerViewObj.removeAnimate()
            //self.pickerViewObj.removeFromSuperview()
        }
        
    }
    
    @IBAction func btnCountry(_ sender: UIButton)
    {
//        view.addSubview(pickerViewObj)
//        pickerViewObj.showAnimate()
//        pickerViewObj.DoneCallback = {CountryCode,countryName in
//            sender.setTitle(countryName, for: .normal)
//            self.pickerViewObj.removeAnimate()
//            //self.pickerViewObj.removeFromSuperview()
//            
//        }
//        pickerViewObj.CancelCallback = {
//            self.pickerViewObj.removeAnimate()
//            //self.pickerViewObj.removeFromSuperview()
//        }
        
    }
    
    
    @IBAction func btnNationality(_ sender: UIButton)
    {
        
        
        let nationalities = ["Afghan","Albanian","Algerian","American","Andorran","Angolan","Antiguans","Argentinean","Armenian","Australian","Austrian","Azerbaijani","Bahamian","Bahraini","Bangladeshi","Barbadian","Barbudans","Batswana","Belarusian","Belgian","Belizean","Beninese","Bhutanese","Bolivian","Bosnian","Brazilian", "British","Bruneian","Bulgarian","Burkinabe","Burmese","Burundian","Cambodian","Cameroonian","Canadian","CapeVerdean","CentralAfrican","Chadian","Chilean","Chinese","Colombian","Comoran","Congolese","CostaRican","Croatian","Cuban","Cypriot","Czech","Danish","Djibouti","Dominican","Dutch","EastTimorese","Ecuadorean","Egyptian","Emirian","EquatorialGuinean","Eritrean","Estonian","Ethiopian","Fijian","Filipino","Finnish","French","Gabonese","Gambian","Georgian","German","Ghanaian","Greek","Grenadian","Guatemalan","GuineaBissauan","Guinean","Guyanese","Haitian","Herzegovinian","Honduran","Hungarian","IKiribati","Icelander","Indian","Indonesian","Iranian","Iraqi","Irish","Israeli","Italian","Ivorian","Jamaican","Japanese","Jordanian","Kazakhstani","Kenyan","KittianandNevisian","Kuwaiti","Kyrgyz","Laotian","Latvian","Lebanese","Liberian","Libyan","Liechtensteiner","Lithuanian","Luxembourger","Macedonian","Malagasy","Malawian","Malaysian","Maldivan","Malian","Maltese","Marshallese","Mauritanian","Mauritian","Mexican","Micronesian","Moldovan","Monacan","Mongolian","Moroccan","Mosotho","Motswana","Mozambican","Namibian","Nauruan","Nepalese","NewZealander","Nicaraguan","Nigerian","Nigerien","NorthKorean","NorthernIrish","Norwegian","Omani","Pakistani","Palauan","Panamanian","PapuaNewGuinean","Paraguayan","Peruvian","Polish","Portuguese","Qatari","Romanian","Russian","Rwandan","SaintLucian","Salvadoran","Samoan","SanMarinese","SaoTomean","Saudi","Scottish","Senegalese","Serbian","Seychellois","SierraLeonean","Singaporean","Slovakian","Slovenian","SolomonIslander","Somali","SouthAfrican","SouthKorean","Spanish","SriLankan","Sudanese","Surinamer","Swazi","Swedish","Swiss","Syrian","Taiwanese","Tajik","Tanzanian","Thai","Togolese","Tongan","Trinidadian/Tobagonian","Tunisian","Turkish","Tuvaluan","Ugandan","Ukrainian","Uruguayan","Uzbekistani","Venezuelan","Vietnamese","Welsh","Yemenite","Zambian","Zimbabwean"]
        
        ActionSheetStringPicker.show(withTitle: NSLocalizedString("Select Nationality", comment: ""), rows: nationalities, initialSelection: 1, doneBlock: { picker, value, index in
            
            self.lblNationality.text = nationalities[value]
                //self.btnNationality.setTitle((nationalities[value]), for: .normal)
                
                return
                
        }, cancel:{ ActionStringCancelBlock in
                
                return
                
        }, origin: sender)

    }
    
    @IBAction func btnAddressClicked(_ sender: UIButton) {

        
        let picker = GMSPlacePickerViewController(config: GMSPlacePickerConfig(viewport: nil))
        picker.delegate = self
        //picker.navigationController?.navigationBar.barTintColor = Utility.UIColorFromRGB(rgbValue: 0x032952)
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func btnGender(_ sender: UIButton){
        
        let gender = [NSLocalizedString("Male", comment: ""), NSLocalizedString("Female", comment: "")]
        
        ActionSheetStringPicker.show(withTitle: NSLocalizedString("Select Your Gender", comment: ""), rows: gender, initialSelection: 1, doneBlock:{
            picker, value, index in
                self.lblGender.text = gender[value]
                //self.btnGender.setTitle((gender[value]), for: .normal)
                return
            
        }, cancel:{ ActionStringCancelBlock in
                
                return
                
        }, origin: sender)
        
    }
    
    
    @IBAction func brnAge(_ sender: UIButton){
    
        let datePicker = ActionSheetDatePicker(title: NSLocalizedString("Select DOB", comment: ""), datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            
            sender.setTitle(dateFormatter.string(from: value as! Date), for: UIControlState())

            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender.superview!.superview)
        //let secondsInWeek: TimeInterval = 7 * 24 * 60 * 60;
        datePicker?.maximumDate = Date()
        
        datePicker?.show()
        
    }
    
    
    
    @IBAction func btnUploadImage(_ sender: UIButton)
    {
        
        let alert = UIAlertController(title: NSLocalizedString("Select Source", comment: "") , message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default, handler:
            {
            (UIAlertAction) in
            self.selectPictureFrom(0)
            }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Gallery", comment: ""), style: .default, handler:
            {
            (UIAlertAction) in
            self.selectPictureFrom(1)
            
            }))
        
        present(alert, animated: true, completion: nil)

    }
    
    @IBAction func editProfileClicked(_ sender: UIButton) {
        
        
        let storyBoard = AppConstants.APP_STORYBOARD.USER
        let termsVC = storyBoard.instantiateViewController(withIdentifier: "EditProfileController") as! EditProfileController
        self.navigationController?.pushViewController(termsVC, animated:true)
        return
        
        if sender.isSelected == false {
            sender.isSelected = true
            
            lblTitle.text = NSLocalizedString("Edit Profile", comment: "")
            sender.setTitle(NSLocalizedString("Update Profile", comment: ""), for: .normal)
            
            lblNationality.text = Singleton.sharedInstance.userData?.country ?? NSLocalizedString("Select nationality", comment: "")
           // btnNationality.setTitle(Singleton.sharedInstance.userData?.country ?? NSLocalizedString("Select nationality", comment: ""), for: .normal)
            //btnGender.setTitle(Singleton.sharedInstance.userData?.gender ?? NSLocalizedString("Select gender", comment: ""), for: .normal)
            //btnAge.setTitle(Singleton.sharedInstance.userData?.dob ?? NSLocalizedString("Select DOB", comment: ""), for: .normal)
            //btnCode.setTitle(Singleton.sharedInstance.userData?.countryCode ?? NSLocalizedString("Code", comment: ""), for: .normal)
            //btnAddress.setTitle(Singleton.sharedInstance.userData?.address ?? NSLocalizedString("Select address", comment: ""), for: .normal)
            //txtFldPhoneNo.text = Singleton.sharedInstance.userData?.phone ?? ""
            
            
            
            if Singleton.sharedInstance.userData?.gender != nil {
                
                let pre = Locale.preferredLanguages[0]
                if pre.hasPrefix("en") {
                    if  Singleton.sharedInstance.userData?.gender == "Male" || Singleton.sharedInstance.userData?.gender == "ذكر" {
                        lblGender.text = "Male"
                     //   btnGender.setTitle("Male" , for: .normal)
                    }else{
                        lblGender.text = "Female"
                     //   btnGender.setTitle("Female" , for: .normal)
                    }
                }else{
                    if  Singleton.sharedInstance.userData?.gender == "Male" || Singleton.sharedInstance.userData?.gender == "ذكر" {
                        lblGender.text = "ذكر"
                       // btnGender.setTitle("ذكر" , for: .normal)
                    }else{
                        lblGender.text = "انثى"
                       // btnGender.setTitle("انثى", for: .normal)
                    }
                }
                
            }else{
                lblGender.text = NSLocalizedString("Gender", comment: "")
               // btnGender.setTitle(NSLocalizedString("Gender", comment: ""), for: .normal)
            }
            
            
            
            btnUploadImage.isHidden = false
            //btnCode.isUserInteractionEnabled = true
            //btnCodeArrow.isUserInteractionEnabled = true
            //btnNationality.isUserInteractionEnabled = true
            //btnGender.isUserInteractionEnabled = true
            //btnAge.isUserInteractionEnabled = true
            txtfldName.isUserInteractionEnabled = true
            //btnAge.isUserInteractionEnabled = true
            //btnAddress.isUserInteractionEnabled = true
            //txtFldPhoneNo.isUserInteractionEnabled = true
            
            UIView.animate(withDuration: 0.3){
                self.stackViewEmail.isHidden = true
            }
            
            
            
        }else{
            
            if (!Validation.validateStringLength(txtfldName.text!)) {
                self.view.makeToast(NSLocalizedString("Full name is required", comment: ""), duration: 1.5, position: .center)
                return
            }
            
//            if btnCode.titleLabel?.text != NSLocalizedString("Code", comment: "") && !Validation.validateStringLength(txtFldPhoneNo.text!) {
//                self.view.makeToast(NSLocalizedString("Please enter mobile number.", comment: ""), duration: 1.5, position: .center)
//                return
//            }
//
//            if btnCode.titleLabel?.text == NSLocalizedString("Code", comment: "") && Validation.validateStringLength(txtFldPhoneNo.text!) {
//                self.view.makeToast(NSLocalizedString("Select country code.", comment: ""), duration: 1.5, position: .center)
//                return
//            }
            
            callUpdateProfileService()
            

        }

        
    }
    
    //MARK:- APIS
    
    func callUpdateProfileService() {
//
//        var parameter:[String:Any] = [
//            "user_id" : String((Singleton.sharedInstance.userData?.id)!),
//            "name" : txtfldName.text!,
//            "device_token" : Singleton.sharedInstance.deviceToken ]
//
//        if btnCode.titleLabel?.text != NSLocalizedString("Code", comment: "") {
//            parameter["country_code"] = (btnCode.titleLabel?.text)!
//        }
//        if txtFldPhoneNo.text != NSLocalizedString("Enter mobile no", comment: "") {
//            parameter["phone"] = txtFldPhoneNo.text!
//        }
////        if btnNationality.titleLabel?.text != NSLocalizedString("Select nationality", comment: "") {
////            parameter["country"] = (btnNationality.titleLabel?.text)!
////        }
//        if btnAge.titleLabel?.text != NSLocalizedString("Select DOB", comment: "") {
//            parameter["dob"] = (btnAge.titleLabel?.text)!
//        }
//        if btnAddress.titleLabel?.text != NSLocalizedString("Select address", comment: "") {
//            parameter["address"] = (btnAddress.titleLabel?.text)!
//        }
////        if btnGender.titleLabel?.text != NSLocalizedString("Select gender", comment: "") {
////
////            parameter["gender"] = (btnGender.titleLabel?.text)!
////        }
//
//
//        var image = [String:Any]()
//        if self.imgProfile != nil {
//            let imageInJPEG = UIImageJPEGRepresentation(self.imgProfile!, 0.1)
//            let compressImage = UIImage.init(data: imageInJPEG!)
//            let imgProfile12 = compressImage!.af_imageAspectScaled(toFill: CGSize(width: 200, height: 200))
//            print(imgProfile12)
//            image = ["key":"image", "value":(imgProfile12)] as [String : Any]
//        }
//
//        let header = ["Authorization" : "Bearer "+(Singleton.sharedInstance.accessToken)!]
//
//        self.showNormalHud(NSLocalizedString("Loading...", comment: ""))
//
//        UserBase.updateUserProfile(urlPath: BASE_URL+UPDATE_PROFILE, parameters: parameter, imageData: image, header: header, completionHandler: { (data) in
//            self.removeNormalHud()
//
//            if data.code != 200  {
//                self.view.makeToast(data.message, duration: 1.5, position: .center)
//                return
//            }
//
//
//            let realm = try! Realm()
//            try! realm.write {
//                realm.add((data.result?.user)!, update: .all)
//                // Singleton.sharedInstance.userData = data.result?.user
//            }
//
//
//            self.setData()
//            self.btnEditProfile.isSelected = false
//            self.btnEditProfile.setTitle(NSLocalizedString("Edit Profile", comment: ""), for: .normal)
//            self.lblTitle.text = NSLocalizedString("Profile", comment: "")
//            self.btnUploadImage.isHidden = true
//            self.btnCode.isUserInteractionEnabled = false
//            self.btnCodeArrow.isUserInteractionEnabled = false
//           // self.btnNationality.isUserInteractionEnabled = false
//            //self.btnGender.isUserInteractionEnabled = false
//            self.btnAge.isUserInteractionEnabled = false
//            self.txtfldName.isUserInteractionEnabled = false
//            self.btnAddress.isUserInteractionEnabled = false
//            self.txtFldPhoneNo.isUserInteractionEnabled = false
//            UIView.animate(withDuration: 0.3){
//                self.stackViewEmail.isHidden = false
//            }
//
//
//        }) { (error) in
//            self.removeNormalHud()
//            print(error)
//            self.view.makeToast(NSLocalizedString("Sorry, something went wrong!", comment: ""), duration: 1.5, position: .center)
//        }
//
    }
    
} // end class



//MARK:- ImagePicker Controller Delegate
extension ProfileController:
    UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {

            imgProfile = pickedImage
            //imgTest.image = pickedImage
            
        }
        
//        imgEditProfile.contentMode = .center
        imgEditProfile.image = imgProfile?.af_imageAspectScaled(toFill: self.imgEditProfile.frame.size)
        imgEditProfile.backgroundColor = UIColor.yellow
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func selectPictureFrom(_ index:Int) {
        print(index)
        self.imagePicker.delegate = self
        self.imagePicker.navigationBar.isTranslucent = false
        //self.imagePicker.navigationBar.barTintColor = UIColor(red: 17/255, green: 47/255, blue: 43/255, alpha: 1)
        // Background color
        self.imagePicker.navigationBar.tintColor = UIColor.black
        
        //isSelectImg = true
        self.imagePicker.allowsEditing = true
        
        if (index == 0) {
            self.imagePicker.sourceType = .camera
            present(self.imagePicker, animated: true, completion: nil)
        }
        else if (index == 1) {
            self.imagePicker.sourceType = .photoLibrary
            present(self.imagePicker, animated: true, completion: nil)
        }
        
    }
    

    
    
} // end imagepickerviews



extension ProfileController: UITextFieldDelegate
{


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        var maxLength = 20
        
        let currentString: NSString = txtfldName.text! as NSString
        
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if txtfldName == textField {
            maxLength = 20
        }
        
        return newString.length <= maxLength
        

        
        
        
    }




}
//MARK:- google map delegate
extension ProfileController: GMSPlacePickerViewControllerDelegate {
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        print("Place name: \(place)")
        
        
            print("Place address: \(place.formattedAddress)")
            print("Place attributions: \(place.attributions)")
        
        //btnAddress.setTitle(place.formattedAddress, for: .normal)
        
        
        viewController.dismiss(animated: true, completion: nil)
        
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    
    
}





