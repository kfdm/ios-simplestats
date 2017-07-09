//
//  ViewController.swift
//  simplestats
//
//  Created by Paul Traylor on 2017/07/08.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var countdowns = [[String: String]]()

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countdowns.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let countdown = countdowns[indexPath.row]
        cell.textLabel?.text = countdown["label"]
        cell.detailTextLabel?.text = countdown["value"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = countdowns[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let countdownApi = "https://tsundere.co/api/countdown"
        
        if let url = URL(string: countdownApi) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                for result in json["results"].arrayValue {
                    let obj = [
                        "label": result["label"].stringValue,
                        "description": result["description"].stringValue,
                        "value": result["created"].stringValue,
                        ]
                    countdowns.append(obj)
                }
            }
        }
        
        let chartApi = "https://tsundere.co/api/chart"
        
        if let url = URL(string: chartApi) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                for result in json["results"].arrayValue {
                    let obj = [
                        "label": result["label"].stringValue,
                        "description": result["description"].stringValue,
                        "value": result["value"].stringValue,
                        ]
                    countdowns.append(obj)
                }            }
        }
        
        tableView.reloadData()
    }

}

