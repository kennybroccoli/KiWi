//
//  EnterPassViewController.swift
//  
//
//  Created by Kenny Lee on 8/26/15.
//
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import Security

class EnterPassViewController: UIViewController {

    @IBOutlet var enteredPassword: UITextField!
    let networkName = ViewController().getNetworkName()! as String
   // let password = enteredPassword.text
    
    @IBAction func savePassword(sender: UIButton) {
        
        Keychain.set(networkName, value: enteredPassword.text)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if Keychain.get(networkName) != nil {
            
            self.view.hidden = true
            self.performSegueWithIdentifier("savePassword", sender: self)
            
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
