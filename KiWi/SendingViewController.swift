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
import SystemConfiguration.CaptiveNetwork


class SendingViewController: UIViewController, MCBrowserViewControllerDelegate, CBCentralManagerDelegate {
    
    // Check if bluetooth is enabled (Using CoreBluetooth Framework). If so, launch MCBrowserViewController. 
    // If not, request to turn on bluetooth. 
    // User will then select devices to pair with, and then app should automatically send the passkey.
    // Utilize the progress bar to show packets sent, and then segue to success page.
    
    var appDelegate:AppDelegate!
    var CBManager: CBCentralManager!
    
    @IBOutlet weak var searchForUsers: UIButton!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // binded to the Find button
    @IBAction func find(sender: UIButton) {
        
        // Starts Bluetooth/MPC program
        CBManager = CBCentralManager(delegate:self, queue:nil)
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
        // If bluetooth is on it sets up MPC: necessary for bluetooth
        switch (central.state) {
            
            case .PoweredOn:
                
                // set up MPC
            
                appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.mpcHandler.setupPeerWithDisplayName(UIDevice.currentDevice().name)
                appDelegate.mpcHandler.setupSession()
                appDelegate.mpcHandler.advertiseSelf(true)
            
                NSNotificationCenter.defaultCenter().addObserver(self, selector:    "peerChangedStateWithNotification:", name: "MPC_DidChangeStateNotification", object: nil)
            
                if appDelegate.mpcHandler.session != nil {
                    appDelegate.mpcHandler.setupBrowser()
                    appDelegate.mpcHandler.browser.delegate = self
                    self.presentViewController(appDelegate.mpcHandler.browser, animated: true, completion: nil)
                
                }
            
            default:
                break
            
        }

    }
    
    func getNetworkName() -> String? {
        
        // return the network name or nil
        // code works on device not on simulator....
        
        if let interfaces = CNCopySupportedInterfaces() {
            let interfacesArray = interfaces.takeRetainedValue() as! [String]
            if let unsafeInterfaceData = CNCopyCurrentNetworkInfo(interfacesArray[0] as String) {
                let interfaceData = unsafeInterfaceData.takeRetainedValue() as Dictionary
                return interfaceData["SSID"] as! String
            }
        }
        return nil
    }
    
    func peerChangedStateWithNotification(notification: NSNotification){
        // when a connection is made it will send the wifi information to the peer
        
        let state = notification.userInfo!["state"] as! Int
        
        println("this is the state")
        println(state)
        
        if state == MCSessionState.Connected.rawValue{
            
            // now we will send the data over to the users
            let connectedPeers = self.appDelegate.mpcHandler.session.connectedPeers
            println(connectedPeers) 
            if let ssid = self.getNetworkName()
            {
                let wifiDictionary: [String:NSString!] = ["ssid":ssid, "password":"Test"]
                let wifiData :NSData = NSKeyedArchiver.archivedDataWithRootObject(wifiDictionary)
                
                self.appDelegate.mpcHandler.session.sendData(wifiData, toPeers: connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: nil)

            }

        }
        
    }
    
}
