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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
