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
        
        let todoPriority: Int = todo.priority.rawValue
        cell.todoItem = todo
        
        setupPriorityButtonAttributes(cell: cell, priority: todoPriority)
        
        cell.delegate = self

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
    
    func setupPriorityButtonAttributes(cell: TodoItemTableViewCell, priority: Int) {
        switch(priority) {
        case 0:
            cell.todoPriorityButton.setTitle("No Prio", for: .normal) //TODO: Refactor to have different state by priority?
            cell.todoPriorityButton.backgroundColor = .black
        case 1:
            cell.todoPriorityButton.setTitle("Low", for: .normal) //TODO: Refactor to have different state by priority?
            cell.todoPriorityButton.backgroundColor = .green
        case 2:
            cell.todoPriorityButton.setTitle("Med", for: .normal) //TODO: Refactor to have different state by priority?
            cell.todoPriorityButton.backgroundColor = .yellow
        case 3:
            cell.todoPriorityButton.setTitle("High", for: .normal) //TODO: Refactor to have different state by priority?
            cell.todoPriorityButton.backgroundColor = .red
        default:
            return
        }
    }
}

extension TodoListTableViewController: TodoItemTableViewCellDelegate {
    func cyclePriority(_ sender: TodoItemTableViewCell) {
        var newPriority = sender.todoItem.priority.rawValue + 1
        if newPriority > 3 {
            newPriority = 0
        }
        
        let updatedTodo = Todo()
        updatedTodo.title = sender.todoItem.title
        updatedTodo.modificationDate = Date()
        updatedTodo.priority = Todo.TodoPriority(rawValue: newPriority)!
        
        RealmHelper.updateTodo(todoToBeUpdated: sender.todoItem, updatedTodo: updatedTodo)
        
        todos = RealmHelper.getTodos(sorted: .byDate)
    }
}
























