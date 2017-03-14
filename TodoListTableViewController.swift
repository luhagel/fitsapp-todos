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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showNewTodoAlertController))
        
        todos = RealmHelper.getTodos(sorted: .byDate)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath) as! TodoItemTableViewCell
        let todo = todos[indexPath.row]

        cell.todoTitleLabel.text = todo.title
        cell.todoDateLabel.text = todo.modificationDate.shortDate

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            RealmHelper.removeTodo(todo: todos[indexPath.row])
            todos = RealmHelper.getTodos(sorted: .byDate)
        }
    }
    
    func showNewTodoAlertController() {
        let newTodoAlertController = UIAlertController(title: "New Task", message: "What do you want to accomplish?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let field = newTodoAlertController.textFields![0].text {
                let newTodo: Todo = Todo()
                newTodo.title = field
                RealmHelper.addTodo(todo: newTodo)
                
                self.todos = RealmHelper.getTodos(sorted: .byDate)
                dump(self.todos)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        newTodoAlertController.addAction(confirmAction)
        newTodoAlertController.addAction(cancelAction)
        
        newTodoAlertController.addTextField { textfield in
            textfield.placeholder = "Finish the Fitsapp Swift assignment"
        }
        
        self.present(newTodoAlertController, animated: true, completion: nil)
    }

}
