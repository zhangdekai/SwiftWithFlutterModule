//
//  ViewController.swift
//  IOSNativeWithFlutterModule
//
//  Created by zhang dekai on 2020/6/21.
//  Copyright © 2020 zhang dekai. All rights reserved.
//


/**
* FlutterMethodChannel : 调用方法(method invocation)一次通讯的
* 以下两种都是持续通讯的!
*      FlutterBasicMessageChannel :传递字符&半结构化的信息.
*      FlutterEventChannel    : 用于数据流(stream)的通讯
*/

import UIKit

class ViewController: UIViewController {
    
    
    //MARK:  life style
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.msgChannel.setMessageHandler { (message, callBack) in
            print("收到Flutter的:\(message ?? "NO")")
            
            
            
            guard let msg = message as? String else {
                return
            }
            
            self.flutterMsgLable.text = msg
            if msg == "" {
                self.flutterMsgLable.text = "收到消息为空吧，是不是你没输入？"
            }
            
        }
        
    }

    @IBAction func jumpToFlutter1(_ sender: Any) {
        let methodChannel = FlutterMethodChannel.init(name: "one_page", binaryMessenger: self.flutterVc as! FlutterBinaryMessenger)
        methodChannel.invokeMethod("one", arguments: "hello Flutter")
        
        self.present(self.flutterVc, animated: true, completion: nil)
        
        methodChannel.setMethodCallHandler { (call, result) in
            if call.method == "exit" {
                self.flutterVc.dismiss(animated: true, completion: nil)
            }
        }
        
        
    }
    
    @IBAction func jumpToFlutter2(_ sender: Any) {
        
        let methodChannel = FlutterMethodChannel.init(name: "two_page", binaryMessenger: self.flutterVc as! FlutterBinaryMessenger)
        methodChannel.invokeMethod("two", arguments: "hello Flutter")
        
        self.present(self.flutterVc, animated: true, completion: nil)
        
        methodChannel.setMethodCallHandler { (call, result) in
            if call.method == "exit" {
                self.flutterVc.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var a = 0;
        
        msgChannel.sendMessage("\(a += 1)")
    }
    
    
    //MARK: - setter getter
    
    @IBOutlet weak var flutterMsgLable: UILabel!
    lazy var flutterEngine: FlutterEngine = {
        var engine = FlutterEngine.init(name: "DeKai")
        if engine.run() {
            return engine
        }
        return engine
    }()
    
    lazy var flutterVc: FlutterViewController = {
        var vc = FlutterViewController.init(engine: self.flutterEngine, nibName: nil, bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }()
    
    lazy var msgChannel = FlutterBasicMessageChannel.init(name: "messageChannel", binaryMessenger: self.flutterVc as! FlutterBinaryMessenger)
}

