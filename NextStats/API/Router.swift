//
//  Router.swift
//  NextStats
//
//  Created by Paul Traylor on 2018/09/05.
//  Copyright © 2018年 Paul Traylor. All rights reserved.
//

import Foundation
import UIKit

class Router {
    static func switchRootViewController(_ viewController: UIViewController, animated: Bool = true, duration: TimeInterval = 0.5, options: UIViewAnimationOptions = .transitionFlipFromRight, completion: (() -> Void)? = nil) {
        print("switchRootViewController \(viewController)")
        print("\(UIApplication.shared.keyWindow)")
        guard let window = UIApplication.shared.keyWindow else { return }
        print("window \(window)")
        guard animated else {
            window.rootViewController = viewController
            return
        }

        print("animated \(animated)")
        UIView.transition(with: window, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            window.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }) { _ in
            completion?()
        }
    }

    static func isLoggedIn() -> Bool {
        print("isLoggedIn Check")
        return ApplicationSettings.username != nil
    }

    static func showLogin(animated: Bool = false, duration: TimeInterval = 0.5, options: UIViewAnimationOptions = .transitionFlipFromRight, completion: (() -> Void)? = nil) {
        print("showLogin")
        guard let window = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: LoginController.storyboardIdentifier()) as? LoginController else {
            return
        }
        switchRootViewController(window)
    }

    static func showMain(animated: Bool = true, duration: TimeInterval = 0.5, options: UIViewAnimationOptions = .transitionFlipFromRight, completion: (() -> Void)? = nil) {
        print("showMain")
        guard let window = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNavigationController") as? UINavigationController else {
            return
        }
        switchRootViewController(window)
    }
}
