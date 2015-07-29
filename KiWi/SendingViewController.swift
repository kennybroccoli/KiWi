//
//  SendingViewController.swift
//  KiWi
//
//  Created by Kenny Lee on 7/14/15.
//  Copyright (c) 2015 Hippo. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CoreBluetooth

class SendingViewController: UIViewController, MCBrowserViewControllerDelegate, CBCentralManagerDelegate {
    
    //Check if bluetooth is enabled (Using CoreBluetooth Framework). If so, launch MCBrowserViewController. If not, request to turn on bluetooth. User will then select devices to pair with, and then app should automatically send the passkey. Utilize the progress bar to show packets sent, and then segue to success page.
    
    var appDelegate:AppDelegate!
    var CBManager = CBCentralManager()

    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(true)
        
        switch (CBManager.state) {
            
        case .PoweredOn: //iPhone Simulator doesn't have Bluetooth capability, so this case will never be called. If calling this case the default, then the Bluetooth/WiFi Multipeer Connector browser will launch.
            
            appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.mpcHandler.setupPeerWithDisplayName(UIDevice.currentDevice().name)
            appDelegate.mpcHandler.setupSession()
            appDelegate.mpcHandler.advertiseSelf(true)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "peerChangedStateWithNotification:", name: "MPC_DidChangeStateNotification", object: nil)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleReceivedDataWithNotification:", name: "MPC_DidReceiveDataNotification", object: nil)
            
            
            if appDelegate.mpcHandler.session != nil {
            appDelegate.mpcHandler.setupBrowser()
            appDelegate.mpcHandler.browser.delegate = self
            self.presentViewController(appDelegate.mpcHandler.browser, animated: true, completion: nil)
            
            }
            
        default:
            break   //Not sure how to handle the notification to turn Bluetooth on here. Need the same for the receiving view controller.

        }
  
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        
        var centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    // Notifies the delegate, when the user taps the done button
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
            appDelegate.mpcHandler.browser.dismissViewControllerAnimated(true, completion: nil)
            CBManager.stopScan()
    }
    
    // Notifies delegate that the user taps the cancel button.
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
            appDelegate.mpcHandler.browser.dismissViewControllerAnimated(true, completion: nil)
            CBManager.stopScan()
    }

    func centralManagerDidUpdateState(central: CBCentralManager!) {

    }
    
}
