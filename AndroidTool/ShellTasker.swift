//
//  ShellTasker.swift
//  AndroidTool
//
//  Created by Morten Just Petersen on 4/23/15.
//  Copyright (c) 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

class ShellTasker: NSObject {
    
    private let scriptFile: String
    private var task: Process?
    private var disposable: Any? {
        didSet {
            NotificationCenter.default.removeObserver(disposable as Any)
        }
    }
    var outputIsVerbose = false
    
    init(scriptFile:String) {
        self.scriptFile = scriptFile
        print("T:\(scriptFile)")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(disposable as Any)
    }
    
    func stop(){
        task?.terminate()
    }
    
    func postNotification(_ message: String, channel: Notification.Name){
        NotificationCenter.default.post(name: channel,
                                        object: message as NSString)
    }
    
    func run(
            arguments args: [String] = [],
            isUserScript: Bool = false,
            isIOS: Bool = false,
            complete: @escaping (_ output: String) -> Void) {
        
        let scriptPath = isUserScript
            ? scriptFile
            : Bundle.main.path(forResource: scriptFile, ofType: "sh")!
        let resourcesPath = Bundle.main.resourcePath!
        
        let task = Process()
        task.launchPath = "/bin/bash"
        let pipe = Pipe()
        
        var allArguments = [String]()
        allArguments.append("\(scriptPath)") // $1
        
        if !isIOS {
            allArguments.append(resourcesPath) // $1
        } else {
            let imobileUrl = NSURL(fileURLWithPath: Bundle.main.path(forResource: "idevicescreenshot", ofType: "")!).deletingLastPathComponent
            let imobilePath = imobileUrl?.path
            //let imobilePath = NSBundle.mainBundle().pathForResource("idevicescreenshot", ofType: "")?.stringByDeletingLastPathComponent
            allArguments.append(imobilePath!) // $1
        }
        
        for arg in args {
            allArguments.append(arg)
        }
        
        let defaultAndoridSdkRoot = resourcesPath + "/android-sdk"
        let useUserAndoridSdkRoot = UserDefaults.standard.bool(forKey: C.PREF_USE_USER_ANDROID_SDK_ROOT)
        let androidSdkRoot = useUserAndoridSdkRoot
            ? UserDefaults.standard.string(forKey: C.PREF_ANDROID_SDK_ROOT) ?? defaultAndoridSdkRoot
            : defaultAndoridSdkRoot
        
        task.arguments = allArguments
        task.standardOutput = pipe
        task.standardError = pipe
        task.environment = [
            "ANDROID_SDK_ROOT": androidSdkRoot
        ]
        
        // post a notification with the command, for the rawoutput debugging window
        postNotification(scriptPath, channel: notificationChannel())
        self.task = task
        task.launch()
        
        pipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
        disposable = NotificationCenter.default.addObserver(
            forName: .NSFileHandleDataAvailable,
            object: pipe.fileHandleForReading,
            queue: nil)
        { (notification) -> Void in
            DispatchQueue.global(priority: .default).async {
                let data = pipe.fileHandleForReading.availableData
                let output = String(data: data, encoding: .utf8)!
                DispatchQueue.main.async {
                    self.postNotification(output, channel: self.notificationChannel())
                    complete(output)
                }
            }
        }
    }
    
    private func notificationChannel() -> Notification.Name {
        return outputIsVerbose ? .newDataVerbose : .newData
    }
}
