//
//  ViewController.swift
//  KiWi
//
//  Created by Kenny Lee on 7/13/15.
//  Copyright (c) 2015 Hippo. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork

class ViewController: UIViewController {

    @IBOutlet weak private var networkLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set the Newtork label to the network name
        if let networkName = self.getNetworkName()
        {
            self.networkLabel.text = networkName
            println(Keychain.get(networkName))
        }
        else
        {
            println(Keychain.get("WBJWL"))
            self.networkLabel.text = "Unavailable"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func getNetworkName() -> String? {
        // return the network name or nil
        // code works on device not on simulator.... that is dumb
        
        if let interfaces = CNCopySupportedInterfaces() {
            let interfacesArray = interfaces.takeRetainedValue() as! [String]
            if let unsafeInterfaceData = CNCopyCurrentNetworkInfo(interfacesArray[0] as String) {
                let interfaceData = unsafeInterfaceData.takeRetainedValue() as Dictionary
                return (interfaceData["SSID"] as! String)
            }
        }
        return nil
    
    }

}