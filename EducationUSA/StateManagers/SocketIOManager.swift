
import UIKit
import SocketIO
import RealmSwift
//import socke

protocol SocketManagerDelegate {
    func didRecieveMessage(channel: String, message: NSDictionary)
    func socketConnect(status: Bool)
}
class SocketIOManager: NSObject {
    
    static let sharedInstance = SocketIOManager()
    
    var realm: Realm!
    var delegate : SocketManagerDelegate!
    
    override init() {
        super.init()
        if(!(realm != nil)){
            realm = try! Realm()
        }
    }
    
    lazy var manager = { () -> SocketManager in
        let man = SocketManager(socketURL: URL(string: ChatConstants.socketURL)!, config: [.log(true), .compress, .connectParams(["user_id":Singleton.sharedInstance.userData!.id]),.path("/node/socket.io")])
        return man
        
        
    }()
    typealias CompletionHandler = (_ success:Bool) -> Void
    
    
    
    
    
    func establishConnection(){
        let socket = manager.defaultSocket
        
        print(socket.status)
        if (isConnected() == false){
            socket.connect()
            var status = false
            socket.on("connect", callback: {responseResult,ack in
                self.sendAllPendingMessage()
                print(responseResult)
                status = true
                if (self.delegate != nil){
                    self.delegate.socketConnect(status: status)
                }
            })
        }
        
    }
    
    func closeConnection(){
        let socket = manager.defaultSocket
        socket.disconnect()
    }
    
    func isConnected()->Bool{
        let socket = manager.defaultSocket
        return socket.status.active
        //return socket.manager!.status.active
    }
    
    func subscribeChanel(channel: String){
        let socket = manager.defaultSocket
        socket.emit("subscribe:channel", channel)
        listenToChannel(channel: channel)
        
    }
    func stopListeningChannel(channel: String){
        let socket = manager.defaultSocket
        socket.off(channel)
    }
    
    func listenToChannel(channel: String){
        let socket = manager.defaultSocket
        socket.on(channel) { (dataArray, socketAck) -> Void in
            let message = self.convertToDictionary(text: dataArray[0] as! String)
            self.delegate.didRecieveMessage(channel: channel, message: message as! NSDictionary)
        }
    }
    
    func sendAgentMessage(message: NSDictionary){
        if NetworkManager.sharedInstance.isConnected(){
            let socket = manager.defaultSocket
            let messItem = Message(value: message)
            addHistoryMessage(chanel: messItem.channel!, message: messItem)
            socket.emit("io:sendmessageagent", message)
            return
        }
        let messItem = Message(value: message)
        addHistoryMessage(chanel: messItem.channel!, message: Message(value: message))
        savePendingMessage(message: message)
        
    }
    func updateTypingStatus(message: NSDictionary){
        let socket = manager.defaultSocket
        socket.emit("io:sendmessageagent", message)
    }
    
    func sendRequestToAgent(request: NSDictionary){
        let socket = manager.defaultSocket
        socket.emit("agentrequestgenerated:channel", request)
    }
    
    
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
    func savePendingMessage(message: NSDictionary){
        let realm = Singleton.sharedInstance.realm
        let item = PendingMessage(value: message)
        if !(item.isInvalidated){
            if Singleton.sharedInstance.pendingMessages.index(of: item) != nil{
                return
            }
            try! realm?.write() {
                Singleton.sharedInstance.pendingMessages.append(item)
                realm?.add(Singleton.sharedInstance.pendingMessages, update: .all)
            }
        }
    }
    func sendAllPendingMessage() {
        
        if Singleton.sharedInstance.pendingMessages.count == 0{
            
            //            self.isCalled = false
            return
        }
        if let item = Singleton.sharedInstance.pendingMessages.first {
            if item.senderUserId == Singleton.sharedInstance.userData!.id{
                try! self.realm?.write() {
                    item.messageDeliveryStatus = DeliveryType.delivered.rawValue
                }
                let messItem = item.toDictionary() as NSDictionary
                if NetworkManager.sharedInstance.isConnected(){
                    let socket = manager.defaultSocket
                    socket.emit("io:sendmessageagent", messItem)
                    try! self.realm?.write() {
                        if !(item.isInvalidated){
                            item.messageDeliveryStatus = DeliveryType.delivered.rawValue
                            if Singleton.sharedInstance.pendingMessages.count > 0 {
                                self.realm?.delete(item)
                                self.realm?.refresh()
                                Singleton.sharedInstance.pendingMessages.remove(at: 0)
                            }
                        }
                    }
                    if Singleton.sharedInstance.pendingMessages.count > 0 {
                        self.sendAllPendingMessage()
                    }
                }
            }
        }
    }
    func addHistoryMessage(chanel: String, history: [Message]){
        let realm = Singleton.sharedInstance.realm
        
        for item in Singleton.sharedInstance.historyMessages{
            if chanel == item.channelName{
                try! realm?.write() {
                    item.messages.removeAll()
                    for message in history{
                        item.messages.append(message)
                    }
                    realm?.add(Singleton.sharedInstance.historyMessages, update: .all)
                }
                return
            }
        }
        let item = UserMessage()
        item.channelName = chanel
        for message in history{
            item.messages.append(message)
        }
        try! realm?.write() {
            Singleton.sharedInstance.historyMessages.append(item)
            realm?.add(Singleton.sharedInstance.historyMessages, update: .all)
        }
    }
    func addHistoryMessage(chanel: String, message: Message){
        let realm = Singleton.sharedInstance.realm
        
        for item in Singleton.sharedInstance.historyMessages{
            if chanel == item.channelName {
                try! realm?.write() {
                    item.messages.append(message)
                    realm?.add(Singleton.sharedInstance.historyMessages, update: .all)
                }
                
                return
            }
        }
    }
    func getChannelHistory(channel: String)-> UserMessage {
        
        if let index = Singleton.sharedInstance.historyMessages.index(at: channel){
            return Singleton.sharedInstance.historyMessages[index]
        }
        else{
            return UserMessage()
        }
    }
    fileprivate func listenForOtherMessages() {
        let socket = manager.defaultSocket
        socket.on("threadJoined") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "threadJoined"), object: dataArray[0] as! [String: AnyObject])
        }
        socket.on("messageReceivedByServer") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "messageReceivedByServer"), object: dataArray[0] as! [String: AnyObject])
        }
        socket.on("threadLeaved") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "threadLeaved"), object: dataArray[0] as! [String: AnyObject])
        }
        socket.on("userOffline") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "userOffline"), object: dataArray[0] as! NSDictionary)
        }
        socket.on("newMessage") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "newMessage"), object: dataArray[0] as! [String: AnyObject])
        }
        
        
        //        userOnline
        socket.on("userOnline") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "userOnline"), object: dataArray[0] as! NSDictionary)
        }
        socket.on("typing") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "typing"), object: dataArray[0] as? [String: AnyObject])
            
        }
        socket.on("stopTyping") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "userStopTypingNotification"), object: dataArray[0] as? [String: AnyObject])
        }
    }
    
}
