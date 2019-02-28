//
//  ShellTasker.swift
//  AndroidTool
//
//  Created by Morten Just Petersen on 4/23/15.
//  Copyright (c) 2015 Morten Just Petersen. All rights reserved.
//

import Cocoa

class Script {
    
    private let fileName: String
    
    private var task: Process?
    
    private var disposable: Any? {
        didSet {
            NotificationCenter.default.removeObserver(disposable as Any)
        }
    }
    
    var outputIsVerbose = false
    
    init(fileName:String) {
        self.fileName = fileName
        print("T:\(fileName)")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(disposable as Any)
    }
    
    func stop(){
        task?.terminate()
        disposable = nil
    }
    
    func run(
            arguments args: [String] = [],
            isUserScript: Bool = false,
            isIOS: Bool = false,
            onCompletion: @escaping (_ output: String) -> Void) {
        
        let scriptPath = isUserScript
            ? fileName
            : Bundle.main.path(forResource: fileName, ofType: "sh")!
        let resourcesPath = Bundle.main.resourcePath!
        
        let task = Process()
        task.launchPath = "/bin/bash"
        let pipe = Pipe()
        
        var allArguments = [String]()
        allArguments.append("\(scriptPath)") // $1
        
        if !isIOS {
            allArguments.append(resourcesPath) // $1
        } else {
            let imobileUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "idevicescreenshot", ofType: "")!).deletingLastPathComponent()
            let imobilePath = imobileUrl.path
            //let imobilePath = NSBundle.mainBundle().pathForResource("idevicescreenshot", ofType: "")?.stringByDeletingLastPathComponent
            allArguments.append(imobilePath) // $1
        }
        
        allArguments.append(contentsOf: args)
        
        let defaultAndroidSdkRoot = resourcesPath + "/android-sdk"
        let useUserAndroidSdkRoot = preferences.useUserAndroidSdkRoot
        let androidSdkRoot = useUserAndroidSdkRoot
            ? preferences.androidSdkRoot ?? defaultAndroidSdkRoot
            : defaultAndroidSdkRoot
        
        task.arguments = allArguments
        task.standardOutput = pipe
        task.standardError = pipe
        task.environment = [
            "ANDROID_SDK_ROOT": androidSdkRoot
        ]
        
        // post a notification with the command, for the rawoutput debugging window
        postNotification(scriptPath, channel: notificationChannel)
        self.task = task
        task.launch()
        
        pipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
        disposable = NotificationCenter.default.addObserver(
            forName: .NSFileHandleDataAvailable,
            object: pipe.fileHandleForReading,
            queue: nil)
        { (notification) in
            DispatchQueue.global(priority: .default).async {
                let data = pipe.fileHandleForReading.availableData
                let output = String(data: data, encoding: .utf8)!
                DispatchQueue.main.async {
                    self.postNotification(output, channel: self.notificationChannel)
                    onCompletion(output)
                }
            }
        }
    }
    
    private func postNotification(_ message: String, channel: Notification.Name) {
        NotificationCenter.default.post(name: channel,
                                        object: message as NSString)
    }
    
    private var notificationChannel: Notification.Name {
        return outputIsVerbose ? .newDataVerbose : .newData
    }
}
