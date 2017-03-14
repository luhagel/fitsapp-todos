//
//  TodoListTableViewController.swift
//  FitsappTodos
//
//  Created by Luca Hagel on 3/14/17.
//  Copyright © 2017 Luca Hagel. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListTableViewController: UITableViewController {
  
    var todos: Results<Todo>! {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        todos = RealmHelper.getTodos(sorted: .byDate)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todos.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath) as! TodoItemTableViewCell

        // Configure the cell...
        cell.todoTitleLabel.text = "Test Todo"
        cell.todoDateLabel.text = "Today"

        return cell
    }

}
