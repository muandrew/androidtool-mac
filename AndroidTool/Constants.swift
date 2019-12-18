//
//  Constants.swift
//  AndroidTool
//
//  Created by Morten Just Petersen on 11/13/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

class Constants {

    static let DROP_INVITE = "Drop a ZIP or APK prototype"
    static let PREF_ANDROID_SDK_ROOT = "androidSdkRoot"
    static let PREF_FLASHIMAGESINZIPFILES = "flashImagesInZipFiles"
    static let PREF_BATTERY_LEVEL = "batteryLevel"
    static let PREF_BIT_RATE = "bitratePref"
    static let PREF_DATA_TYPE = "dataType"
    static let PREF_GENERATEGIF = "generateGif"
    static let PREF_LAUNCHINSTALLEDAPP = "launchInstalledApp"
    static let PREF_MOBILE_DATATYPE = "mobileDatatype"
    static let PREF_MOBILE_LEVEL = "mobileLevel"
    static let PREF_SCALE = "scalePref"
    static let PREF_SCREENSHOTFOLDER = "screenshotsFolder"
    static let PREF_SCREENRECORDINGSFOLDER = "screenRecordingsFolder"
    static let PREF_USEACTIVITYINFILENAME = "useActivityInFilename"
    static let PREF_USE_USER_ANDROID_SDK_ROOT = "useUserAndroidSdkRoot"
    static let PREF_TIME_VALUE = "timeValue"
    static let PREF_VERBOSEOUTPUT = "verboseOutput"
    static let NOTIF_NEWSESSION = "mj.newSession"
    static let NOTIF_ALLOUTPUT = "mj.newAllOutput"
    static let NOTIF_COMMAND = "mj.command"
    static let NOTIF_COMMANDVERBOSE = "mj.commandVerbose"
    
    static let defaultPrefValues = [
        PREF_ANDROID_SDK_ROOT: "",
        PREF_BATTERY_LEVEL: "100%",
        PREF_FLASHIMAGESINZIPFILES: false,
        PREF_GENERATEGIF: false,
        PREF_LAUNCHINSTALLEDAPP: true,
        PREF_MOBILE_DATATYPE: "No data type",
        PREF_MOBILE_LEVEL : "4 bars",
        PREF_SCREENRECORDINGSFOLDER: "",
        PREF_SCREENSHOTFOLDER: "",
        PREF_TIME_VALUE: "10:09",
        PREF_USEACTIVITYINFILENAME: true,
        PREF_USE_USER_ANDROID_SDK_ROOT: false,
        PREF_VERBOSEOUTPUT: false,
    ] as [String : Any]
    
    static let tweakProperties = [
        "airplane",
        ALARM,
        "batteryCharging",
        BATTERYLEVEL,
        BLUETOOTH,
        "clock",
        LOCATION,
        "mobile",
        "mobileDatatype",
        "mobileLevel",
        MUTE,
        "nosim",
        NOTIFICATIONS,
        "speakerphone",
        SYNC,
        VOLUME,
        WIFI,
    ]
    
    static let ALARM = "alarm"
    static let BATTERYLEVEL = "batteryLevel"
    static let BLUETOOTH = "bluetooth"
    static let CHARGING = "charging"
    static let LOCATION = "location"
    static let MUTE = "mute"
    static let NOTIFICATIONS = "notifications"
    static let SYNC = "sync"
    static let TIME = "time"
    static let TIMEVALUE = "timeValue"
    static let VOLUME = "volume"
    static let WIFI = "wifi"
    
}

extension Notification.Name {
    
    static let newData = NSNotification.Name("mj.newData")
    static let newDataVerbose = NSNotification.Name("mj.newDataVerbose")

    
}

let preferences = UserDefaults.standard

extension UserDefaults {
    
    var androidSdkRoot: String? {
        get {
            return string(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
    var useUserAndroidSdkRoot: Bool {
        get {
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
}
