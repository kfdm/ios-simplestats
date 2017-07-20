//
//  LoginViewController.swift
//  simplestats
//
//  Created by Paul Traylor on 2017/07/20.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//

import UIKit
import OnePasswordExtension

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var onepasswordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.onepasswordButton.isHidden = (false == OnePasswordExtension.shared().isAppExtensionAvailable())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func findLoginFrom1Password(_ sender: UIButton) {
        OnePasswordExtension.shared().findLogin(forURLString: "https://tsundere.co", for: self, sender: sender, completion: { (loginDictionary, error) -> Void in
            if loginDictionary == nil {
                print("Error invoking 1Password App Extension for find login: \(error!)")
                return
            }

            self.username.text = loginDictionary?[AppExtensionUsernameKey] as? String
            self.password.text = loginDictionary?[AppExtensionPasswordKey] as? String
        })
    }
    @IBAction func login(_ sender: UIButton) {
        var token = fetchToken(username: self.username.text!, password: self.password.text!)
        print(token)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
