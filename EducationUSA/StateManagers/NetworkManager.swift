//
//  NetworkManager.swift
//  EducationUSA
//
//  Created by zaidtayyab on 02/08/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import Foundation
import Reachability
protocol NetworkManagerDelegate {
    func isConnected()
    func isNotConnected()
}
class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    private init() {}
    
    var reachability : Reachability!
    var delegate : NetworkManagerDelegate!
    func observeReachability(){
        UserDefaults.standard.set(true, forKey: "isFirstConnection")
        self.reachability = Reachability()
        NotificationCenter.default.addObserver(self, selector:#selector(self.reachabilityChanged), name: NSNotification.Name(rawValue: "reachabilityChanged"), object: nil)
        do {
            try self.reachability.startNotifier()
        }
        catch(let error) {
            print("Error occured while starting reachability notifications : \(error.localizedDescription)")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        let firstConnectionCheck: Bool = UserDefaults.standard.value(forKey: "isFirstConnection") as! Bool
        switch reachability.connection {
        case .cellular:
            if Singleton.sharedInstance.isUserLoggedInApp(){
                SocketIOManager.sharedInstance.establishConnection()
            }
            print("Network available via Cellular Data.")
            if delegate != nil{
                delegate.isConnected()
            }
            break
        case .wifi:
            print("Network available via WiFi.")
            if delegate != nil{
                delegate.isConnected()
            }
            if Singleton.sharedInstance.isUserLoggedInApp(){
                SocketIOManager.sharedInstance.establishConnection()
            }
            break
        case .none:
            print("Network is not available.")
            if delegate != nil{
                delegate.isNotConnected()
            }
            if Singleton.sharedInstance.isUserLoggedInApp(){
                SocketIOManager.sharedInstance.closeConnection()
            }
            break
        }
        UserDefaults.standard.set(false, forKey: "isFirstConnection")
    }
    
    func isConnected()-> Bool{
        if reachability != nil{
            if (reachability.connection != .none) && reachability != nil{
                return true
            }
            return false
        }
        else{
            return false
        }
        
    }
}


