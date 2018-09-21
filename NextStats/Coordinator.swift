//
//  Coordinator.swift
//  NextStats
//
//  Created by Paul Traylor on 2018/09/20.
//  Copyright © 2018年 Paul Traylor. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        if isLoggedIn() {
            showMain()
        } else {
            showLogin()
        }
    }

    func showMain() {
        let vc = MainController.instantiate()
        vc.coordinator = self
        navigationController.setViewControllers([vc], animated: true)
    }

    func showAddWidget() {
        let vc = AddWidgetController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }

    func showAddNote() {
        let vc = NoteTableController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }

    func showLogin() {
        let vc = LoginController.instantiate()
        vc.coordinator = self
        navigationController.setViewControllers([vc], animated: true)
    }

    func moveToDetailController(with widget: Widget) {
        let vc = DetailController.instantiate()
        vc.coordinator = self
        vc.widget = widget
        navigationController.pushViewController(vc, animated: true)
    }

    func isLoggedIn() -> Bool {
        print("isLoggedIn Check")
        return ApplicationSettings.username != nil
    }
}
