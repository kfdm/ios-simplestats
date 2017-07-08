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
        cell.detailTextLabel?.text = countdown["created"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = countdowns[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://tsundere.co/api/countdown"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                parse(json: json)
            }
        }
    }
    
    func parse(json: JSON) {
        for result in json["results"].arrayValue {
            let label = result["label"].stringValue
            let description = result["description"].stringValue
            let created = result["created"].stringValue
            let obj = ["label": label, "description": description, "created": created]
            countdowns.append(obj)
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

