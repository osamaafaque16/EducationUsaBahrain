//
//  AgentChatViewController.swift
//  EducationUSA
//
//  Created by zaidtayyab on 27/08/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit
import Alamofire

class AgentChatViewController: BaseController {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var messageList = [Message]()
    var sender = Singleton.sharedInstance.userData!
    
    let agentChannel = Singleton.sharedInstance.agentChatChannel()
    var typingCheck: Bool!
    var searchTimer: Timer?
    
    var fromPush = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = NSLocalizedString("Live Chat", comment: "")
        createBackarrow()
        viewEssentials()
        tableViewEssentials()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //addObserver()
        
        if(!fromPush) {
            //didGetHistory()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SocketIOManager.sharedInstance.stopListeningChannel(channel: agentChannel)
        SocketIOManager.sharedInstance.addHistoryMessage(chanel: agentChannel, history: messageList)
        NotificationCenter.default.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        //NotificationCenter.default.removeObserver(self)
    }
    func viewEssentials(){
        typingCheck = true
        messageField.delegate = self
        messageField.addTarget(self, action: #selector(textFieldDidEditingChanged(_:)), for: .editingChanged)
        //addObserver()
        subscribeChanel()
        SocketIOManager.sharedInstance.delegate = self
        if messageField.text?.count == 0{
            sendButton.isEnabled = false
        }
    }
    
    func tableViewEssentials(){
        tableView.delegate = self
        tableView.dataSource = self
        let senderTextCellNib = UINib(nibName: "SentMessageCell", bundle: nil)
        let recieverTextCellNib = UINib(nibName: "ReceivedMessageCell", bundle: nil)
        tableView.register(senderTextCellNib, forCellReuseIdentifier: "senderTextCell")
        tableView.register(recieverTextCellNib, forCellReuseIdentifier: "recieverTextCell")
        tableView.tableFooterView = UIView()
    }
    func addObserver(){
        NotificationCenter.default.removeObserver(self)
        title = ""
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
    }
    @objc func applicationDidBecomeActive(){
        if NetworkManager.sharedInstance.isConnected(){
            getHistory(channel: agentChannel, check: false)
            return
        }
    }
    func sendRequest(){
        if (NetworkManager.sharedInstance.isConnected()){
            let request : NSDictionary = ["receiver_id":-1,
                                      "reciever_username":"",
                                      "sender_id":sender.id,
                                      "sender_username":sender.name]
            SocketIOManager.sharedInstance.sendRequestToAgent(request: request)
            return
        }
        Utility.showErrorWith(message: NSLocalizedString("Internet seems to be offline", comment: ""))
        
    }
    @objc func textFieldDidEditingChanged(_ textField: UITextField) {
       // buttonStateChanged(textField: textField)
        
        if !(Validation.validateStringLength(messageField.text!)){
            sendButton.isEnabled = false
        }else{
            sendButton.isEnabled = true
        }
        
        if (typingCheck){
            typingCheck = false
            updateTypingStatus(status: true)
            print("Start")
        }
        
        // if a timer is already active, prevent it from firing
        if searchTimer != nil {
            searchTimer?.invalidate()
            searchTimer = nil
        }
        
        // reschedule the search: in 1.0 second, call the searchForKeyword method on the new textfield content
        searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(searchForKeyword(_:)), userInfo: textField.text!, repeats: false)
    }
    @objc func searchForKeyword(_ timer: Timer) {
        typingCheck = true
        updateTypingStatus(status: false)
    }
    func updateTypingStatus(status: Bool){
        let type: Int!
        if (status){
            type = MediaType.typing.rawValue
        }
        else{
            type = MediaType.stopTyping.rawValue
        }
        let messDic : NSDictionary = ["message":"",
                                      "date":getCurrentDateStr(),
                                      "senderUserName":sender.name,
                                      "senderUserId":sender.id,
                                      "recieverUserId":-1,
                                      "channel":agentChannel,
                                      "isMedia":false,
                                      "mediaURL":[],
                                      "messageType":type,
                                      "id": Date().timeStamp]
        SocketIOManager.sharedInstance.updateTypingStatus(message: messDic)
    }
    func buttonStateChanged(textField: UITextField){
        if textField.text!.count == 0{
            sendButton.isEnabled = false
        }
        else{
            sendButton.isEnabled = true
        }
    }
    @IBAction func sendTapped(_ sender: Any) {
        if messageField.text != ""{
            let messDic : NSMutableDictionary = ["message":messageField.text!,
                                                 "date":getCurrentDateStr(),
                                                 "senderUserName":self.sender.name,
                                                 "senderUserId":self.sender.id,
                                                 "recieverUserId":-1,
                                                 "channel":agentChannel,
                                                 "isMedia":false,
                                                 "mediaURL":[],
                                                 "messageType":MediaType.text.rawValue,
                                                 "id": Date().timeStamp,
                                                 "messageStatusType":0,
                                                 "messageDeliveryStatus":DeliveryType.delivered.rawValue]
            
            if messageList.count == 0{
                sendRequest()
            }
            messageList.append(Message(value: messDic))
            messDic["message"] = messageField.text!.encodeEmoji
            tableView.reloadData()
            SocketIOManager.sharedInstance.sendAgentMessage(message: messDic)
            scrollToBottom()
            
            messageField.text = ""
//            view.endEditing(true)
        }
    }
    func scrollToBottom(){
        if self.messageList.count > 0{
            let indexPath = IndexPath(item: self.messageList.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
    }
    func didGetHistory(){
        if NetworkManager.sharedInstance.isConnected(){
            getHistory(channel: agentChannel, check: true)
            return
        }
        
        let history = SocketIOManager.sharedInstance.getChannelHistory(channel: agentChannel)
        for item in history.messages{
            let aItem = Message(value: item)
            messageList.append(aItem)
        }
        tableView.reloadData()
        scrollToBottom()
        Utility.showErrorWith(message: NSLocalizedString("No internet coverage.", comment: ""))
        
        
    }
    func subscribeChanel(){
        SocketIOManager.sharedInstance.subscribeChanel(channel: agentChannel)
    }
    func isMessage(message:Message)-> Bool{
        switch message.messageType {
        case MediaType.typing.rawValue:
            recieverStartTyping()
            return false
        case MediaType.stopTyping.rawValue:
            recieverStopTyping()
            return false
        case MediaType.text.rawValue:
            return true
        case MediaType.image.rawValue:
            return true
        default:
            return false
        }
    }
    func recieverStartTyping(){
        //title = "typing"
    }
    func recieverStopTyping(){
        //title = ""
    }
    
    
}
extension AgentChatViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text != ""{
            sendButton.isEnabled = true
            
        }
        else{
            sendButton.isEnabled = false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        return true
    }
}
extension AgentChatViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messItem = messageList[indexPath.row]
        let isSender = (messItem.senderUserId == sender.id) ? true : false
        if (isSender){
            let cell = tableView.dequeueReusableCell(withIdentifier: "senderTextCell", for: indexPath) as! SentMessageCell
            cell.lblMessage.text = messItem.message
            cell.lblName.text = messItem.senderUserName

            cell.lblDate.text = Utility.getDateFormatChat(date: messItem.date!, In: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", Out: "E hh:mm a", convertUTCtoCurrent: true)
            //messItem.date
            if messItem.messageDeliveryStatus == DeliveryType.seen.rawValue{
                cell.deliveryStatus.text = "Seen"
            }
            else if messItem.messageDeliveryStatus == DeliveryType.pending.rawValue{
//                cell.deliveryStatus.text = "Pending"
            }
            cell.deliveryStatus.text = ""
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "recieverTextCell", for: indexPath) as! ReceivedMessageCell
            cell.lblMessage.text = messItem.message
            cell.lblName.text = messItem.senderUserName

            cell.lblDate.text = Utility.getDateFormatChat(date: messItem.date!, In: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", Out: "E hh:mm a", convertUTCtoCurrent: true)
            if messItem.messageDeliveryStatus == DeliveryType.seen.rawValue{
                cell.deliveryStatus.text = "Seen"
            }
            else if messItem.messageDeliveryStatus == DeliveryType.pending.rawValue{
//                cell.deliveryStatus.text = "Pending"
            }
            
            cell.deliveryStatus.text = ""
            return cell
        }
        
    }
}
extension AgentChatViewController: SocketManagerDelegate{
    func didRecieveMessage(channel: String, message: NSDictionary) {
        if channel == agentChannel{
            let messItem = Message(value: message)
            let isSender = (messItem.senderUserId == sender.id) ? true : false
            if !(isSender){
                self.title = ""
                let messCheck = isMessage(message: messItem)
                if (messCheck){
                    if messItem.messageStatusType == MessageStatusType.none.rawValue && messItem.messageDeliveryStatus == DeliveryType.delivered.rawValue{
                        /*itemDic["messageDeliveryStatus"] = DeliveryType.seen.rawValue
                         //update message status to Updated and message delivery status to Seen
                         messItem.messageDeliveryStatus = DeliveryType.seen.rawValue
                         messItem.messageStatusType = MessageStatusType.update.rawValue*/
                        messItem.message = messItem.message?.decodeEmoji
                        SocketIOManager.sharedInstance.addHistoryMessage(chanel: agentChannel, message: messItem)
                        messageList.append(messItem)
                        tableView.reloadData()
                        scrollToBottom()
                        return
                    }
                    if messItem.messageStatusType == MessageStatusType.delete.rawValue{
                        if let index = messageList.index(of: messItem) {
                            messageList[index] = messItem
                            tableView.reloadData()
                            return
                        }
                        
                    }
                }
            }
        }
    }
    
    func socketConnect(status: Bool) {
        print("connected")
        if fromPush {
            subscribeChanel()
        }
    }
    
    
}
extension AgentChatViewController{
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    func getHistory(channel: String, check: Bool){
        if !Connectivity.isConnectedToInternet {
            self.view.makeToast(AppString.internetUnreachable, duration: 1.5, position: .center)
            return
        }
        
        let parameter:[String:Any] = ["channel":agentChannel]
        
        
        self.showNormalHud(NSLocalizedString("Loading...", comment: ""))
        
        
        ContactUsBase.getChatHistory(urlPath: ChatBase_URL+HISTORY, parameter: parameter, vc: self) { (result) in
            
            self.removeNormalHud()
            let response = result["statusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                if self.messageList.count != 0{
                    self.messageList.removeAll()
                }
                let responseResult = result["RequestList"] as? NSArray
                self.populateMessageList(array: responseResult!)
                
            }else{
                Utility.showErrorWith(message: "An error occured. Please try again")
                return
            }
            
            

        }

        
    }
    
    func populateMessageList(array: NSArray){
        for item in array{
            if let aItem = item as? String{
                var dicItem = self.convertToDictionary(text: aItem)
//                dicItem["message"]
                dicItem!["message"] = (dicItem!["message"] as! String).decodeEmoji
                self.messageList.append(Message(value: dicItem as! NSDictionary))
            }
        }
        SocketIOManager.sharedInstance.addHistoryMessage(chanel: agentChannel, history: self.messageList)
        tableView.reloadData()
        scrollToBottom()
    }
    
}



