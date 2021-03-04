//
//  ServiceHeaders.swift
//  BzzChater
//
//  Created by Soomro Shahid on 7/16/16.
//  Copyright © 2016 Muzamil Hassan. All rights reserved.
//

import UIKit
import Foundation


//var BASE_URL: String =  "http://educationusa.stagingic.com/api/"
//var ChatBase_URL: String =  "https://educationusachat.stagingic.com/node"

var BASE_URL: String =  "http://educationusa.live/api/"
//var BASE_URL: String =  "http://educationusabahrain.stagingic.com/api/"

var ChatBase_URL: String =  "https://chat.educationusa.live/node"

var SIGNIN:String           = "login"
var GUEST_SIGNIN:String     = "guest-login"
var SIGNUP:String           = "register"
var UPDATE_PROFILE:String   = "user/update-profile"
var RESET_PASS:String      = "update-forgot-password"
var CHANGE_PASS:String      = "user/update-password"
var FORGOT_PASS:String      = "email-password-code"
var VERIFY_CODE:String      = "verify-password-code"

var FAQ:String              = "get-faqs"
var EVENT:String            = "events/get-all-events"
var EVENT_FOLLOW:String     = "user-event-response"
var EDU_GUIDE:String        = "get-all-education-guides"
var CONTACTUS:String        = "get-contact-details"
var RECIPIE:String          = "Receipe/"
var ABOUT:String            = "about_us"
var TERMS:String            = "get-cms-page"

var NOTIFICATION:String     = "notification/get-all-notification"
var NOTI_DELETE:String      = "notification/remove-notification"
//var NOTI_DELETE_ALL:String  = "removeAllNotifications"
var NOTI_ON_OFF:String      = "user/update-notification-status"
var NOTI_DATA:String        = "notification/get-notification-data"
var HISTORY: String         = "/api/LoadChannel/{channel}"
var REGISTER_PUSH           = "/api/users/RegisterPushNotification"

var LOGOUT:String           = "logout"

//NEW
//POST
var RECOVER:String           = "recover"
var SOCIAL_LOGIN:String           = "social/login"
var SOCIAL_LOGIN2:String           = "social/login_2"
var SOCIAL_EXIST:String           = "social/exist"
var AGENT_LOGIN:String        = "agent-login"
var AGENT_UPDATE_PASSWORD:String        = "agent-update-password"
var AGENT_IMAGE_UPLOAD:String        = "agent-image-upload"
var USER_UPDATE_PASSWORD:String        = "user/update-password"
var USER_IMAGE_UPLOAD:String        = "user-image-upload"
var USER_SAVE_STORAGE:String        = "user-save-storage"
var USER_UPDATE_STORAGE:String        = "user-update-storage/"//{id}

//GET
var CONSULT_ADVISOR:String        = "consult-adviser"
var FULL_BRIGHT:String        = "full-bright"
var GET_USER_STORAGE:String        = "get-user-storage"
var GET_USER_STORAGE_KEY:String        = "get-user-storageByKey"
var GET_USER_PROFILE:String        = "get-user-profile"
var GET_USER_PROFILES:String        = "get-user-profiles"
var GET_USER_PROFILE_USER:String        = "user/get-profile"
var GET_STUDENT_VISA:String        = "get-student-visa"
var GET_EDUCATION_GUIDELINE:String        = "get-education-guideline"

