//
//  LoginController.swift
//  NextStats
//
//  Created by Paul Traylor on 2018/08/30.
//  Copyright © 2018年 Paul Traylor. All rights reserved.
//

import Foundation
import UIKit
import OnePasswordExtension

class LoginController: UIViewController, Storyboarded {
    @IBOutlet weak var UsernameField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var OnepasswordButton: UIButton!

    weak var coordinator: MainCoordinator?

    override func viewDidLoad() {
        self.OnepasswordButton.isHidden = (false == OnePasswordExtension.shared().isAppExtensionAvailable())
        super.viewDidLoad()
    }

    @IBAction func LoginClick(_ sender: UIButton) {
        guard let username = UsernameField.text else { return }
        guard let password = PasswordField.text else { return }

        checkLogin(username: username, password: password) {response in
            switch response.statusCode {
            case 200:
                print("Successfully logged in")
                ApplicationSettings.username = username
                ApplicationSettings.password = password
                DispatchQueue.main.async {
                    self.coordinator?.showMain()
                }
            default:
                print("Error logging in")
                print(response)
            }
        }
    }

    @IBAction func OnePasswordClick(_ sender: UIButton) {
        OnePasswordExtension.shared().findLogin(forURLString: ApplicationSettings.baseURL.absoluteString, for: self, sender: sender, completion: { (loginDictionary, error) in
            guard let loginDictionary = loginDictionary else {
                if let error = error as NSError?, error.code != AppExtensionErrorCodeCancelledByUser {
                    print("Error invoking 1Password App Extension for find login: \(String(describing: error))")
                }
                return
            }

            self.UsernameField.text = loginDictionary[AppExtensionUsernameKey] as? String
            self.PasswordField.text = loginDictionary[AppExtensionPasswordKey] as? String
            self.LoginClick(sender)
        })
    }
}
