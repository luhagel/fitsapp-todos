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
    
    var filteredTodos: Results<Todo>?
    var sortMethod: TodoSortMethod = .byDate
    let todoSearchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showNewTodoAlertController))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(self.toggleSortMethod))
        
//        todoSearchController.searchResultsUpdater = self
//        todoSearchController.dimsBackgroundDuringPresentation = false
//        tableView.tableHeaderView = todoSearchController.searchBar
        
        todos = RealmHelper.getTodos(sorted: sortMethod, nameContains: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if todoSearchController.isActive && todoSearchController.searchBar.text != "" {
            return filteredTodos!.count
        }
        return todos.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath) as! TodoItemTableViewCell
        
        let todo: Todo
        
        if todoSearchController.isActive && todoSearchController.searchBar.text != "" {
            todo = filteredTodos![indexPath.row]
        } else {
            todo = todos[indexPath.row]
        }

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
            todos = RealmHelper.getTodos(sorted: sortMethod, nameContains: nil)
        }
    }
    
    func showNewTodoAlertController() {
        let newTodoAlertController = UIAlertController(title: "New Task", message: "What do you want to accomplish?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        let confirmAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let field = newTodoAlertController.textFields![0].text {
                let newTodo: Todo = Todo()
                newTodo.title = field
                RealmHelper.addTodo(todo: newTodo)
                
                self.todos = RealmHelper.getTodos(sorted: self.sortMethod, nameContains: nil)
            }
        }
        
        newTodoAlertController.addAction(confirmAction)
        newTodoAlertController.addAction(cancelAction)
        
        newTodoAlertController.addTextField { textfield in
            textfield.placeholder = "Finish the Fitsapp Swift assignment"
        }
        
        self.present(newTodoAlertController, animated: true, completion: nil)
    }
    
    func toggleSortMethod() {
        self.sortMethod = self.sortMethod == .byDate ? .byPriority : .byDate
        
        todos = RealmHelper.getTodos(sorted: sortMethod, nameContains: nil)
    }
    
    func setupPriorityButtonAttributes(cell: TodoItemTableViewCell, priority: Int) {
        switch(priority) {
        case 0:
            cell.todoPriorityButton.setTitle("No Prio", for: .normal) //TODO: Refactor to have different state by priority?
            cell.todoPriorityButton.backgroundColor = .black
        case 1:
            cell.todoPriorityButton.setTitle("Low", for: .normal)
            cell.todoPriorityButton.backgroundColor = .green
        case 2:
            cell.todoPriorityButton.setTitle("Med", for: .normal)
            cell.todoPriorityButton.backgroundColor = .orange
        case 3:
            cell.todoPriorityButton.setTitle("High", for: .normal)
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
        updatedTodo.modificationDate = sender.todoItem.modificationDate
        updatedTodo.priority = Todo.TodoPriority(rawValue: newPriority)!
        
        RealmHelper.updateTodo(todoToBeUpdated: sender.todoItem, updatedTodo: updatedTodo)
        
        todos = RealmHelper.getTodos(sorted: sortMethod, nameContains: nil)
    }
}

extension TodoListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for todoSearchController: UISearchController) {
        filteredTodos = RealmHelper.getTodos(sorted: sortMethod, nameContains: todoSearchController.searchBar.text)
    }
}
















