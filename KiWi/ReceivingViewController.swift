//
//  ReceivingViewController.swift
//  KiWi
//
//  Created by Kenny Lee on 7/14/15.
//  Copyright (c) 2015 Hippo. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CoreBluetooth

class ReceivingViewController: UIViewController, CBPeripheralManagerDelegate {
    
    //Should check if user has bluetooth enabled. Will then receive a pop-up request from the hosting device, and should utilize the progress bar to show packets received. Once logged in, should segue to the success page.
    var appDelegate:AppDelegate!
    var CBPManager: CBPeripheralManager!


    override func viewDidLoad() {
        super.viewDidLoad()
        CBPManager = CBPeripheralManager(delegate:self, queue:nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // function necessary for bluetooth
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!){
        switch (peripheral.state) {
            
        case .PoweredOn:
            
            // set up MPC
            
            appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.mpcHandler.setupPeerWithDisplayName(UIDevice.currentDevice().name)
            appDelegate.mpcHandler.setupSession()
            appDelegate.mpcHandler.advertiseSelf(true)
                        
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleReceivedDataWithNotification:", name: "MPC_DidReceiveDataNotification", object: nil)
            
        default:
            break
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func handleReceivedDataWithNotification(notification: NSNotification){
        let receivedDataDictionary = notification.userInfo as! Dictionary<String, AnyObject>
        let data = receivedDataDictionary["data"] as! NSData
        
        // take data out data variable and connect to the wifi with it...
        let wifiData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Dictionary<String, String>
        println(wifiData["ssid"])
        println(wifiData["password"])
        
    }
    
    

}
