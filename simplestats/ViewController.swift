//
//  ViewController.swift
//  simplestats
//
//  Created by Paul Traylor on 2017/07/08.
//  Copyright © 2017年 Paul Traylor. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var widgets = [Widget]()

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return widgets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let widget = widgets[indexPath.row]
        cell.textLabel?.text = widget.label
        cell.detailTextLabel?.text = widget.format()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if widgets[indexPath.row].more != "" {
            let moreURL = URL(string: widgets[indexPath.row].more)!
            UIApplication.shared.open(moreURL, options: [:], completionHandler: nil)
        } else {
            let vc = DetailViewController()
            vc.detailItem = widgets[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
 
    var counter = 30
    
    
    func updateCounter() {
        //you code, this is an example
        if counter > 0 {
            print("\(counter) seconds to the end of the world")
            counter -= 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        let countdownApi = "https://tsundere.co/api/countdown"
        
        if let url = URL(string: countdownApi) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                for result in json["results"].arrayValue {
                    let obj = Widget(
                        label: result["label"].stringValue,
                        description: result["description"].stringValue,
                        value: result["created"].stringValue,
                        created: result["created"].stringValue,
                        more: result["more"].stringValue
                    )
                    widgets.append(obj)
                }
            }
        }
        
        let chartApi = "https://tsundere.co/api/chart"
        
        if let url = URL(string: chartApi) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data: data)
                for result in json["results"].arrayValue {
                    let obj = Widget(
                        label: result["label"].stringValue,
                        description: result["description"].stringValue,
                        value: result["value"].stringValue,
                        created: result["created"].stringValue,
                        more: result["move"].stringValue
                    )
                    widgets.append(obj)
                }            }
        }
        
        tableView.reloadData()
    }

}

