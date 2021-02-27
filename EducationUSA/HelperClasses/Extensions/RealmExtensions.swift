//
//  RealmExtensions.swift
//  EducationUSA
//
//  Created by zaidtayyab on 02/08/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import Foundation
extension Array where Element: Message {
    func index(of message: Message) -> Int? {
        for (index, value) in self.enumerated() {
            if value.id == message.id {
                return index
            }
        }
        return nil
    }
}
extension Array where Element: UserMessage {
    func index(at channel: String) -> Int? {
        for (index, value) in self.enumerated() {
            if value.channelName == channel {
                return index
            }
        }
        return nil
    }
}
