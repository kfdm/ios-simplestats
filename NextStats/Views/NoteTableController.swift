//
//  NoteTableController.swift
//  NextStats
//
//  Created by Paul Traylor on 2018/09/17.
//  Copyright © 2018年 Paul Traylor. All rights reserved.
//

import Foundation
import UIKit

class NoteTableController: UITableViewController, Storyboarded {
    var notes = [Note]()
    weak var coordinator: MainCoordinator?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItems = [
            UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addNoteSelector))
        ]
    }

    // MARK: - selectors

    @objc func addNoteSelector() {
        coordinator?.showAddNote()
    }

    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let parent = tabBarController as? DetailController else { return }
        guard let widget = parent.widget else { return }
        Note.list(for: widget, limit: 500) { (notes) in
            self.notes = notes.sorted { $0.timestamp > $1.timestamp }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - tableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableCell", for: indexPath)
        let note = notes[indexPath.row]

        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.description

        return cell
    }
}
