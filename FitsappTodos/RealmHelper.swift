//
//  RealmHelper.swift
//  FitsappTodos
//
//  Created by Luca Hagel on 3/14/17.
//  Copyright © 2017 Luca Hagel. All rights reserved.
//

import Foundation
import RealmSwift

enum TodoSortMethod {
    case byDate
    case byPriority
}

class RealmHelper {
  
      static func addTodo(todo: Todo) {
            let realm = try! Realm()
            try! realm.write() {
                  realm.add(todo)
            }
      }
      
      static func removeTodo(todo: Todo) {
            let realm = try! Realm()
            try! realm.write() {
                  realm.delete(todo)
            }
      }
      
      static func updateTodo(todoToBeUpdated: Todo, updatedTodo: Todo) {
            let realm = try! Realm()
            try! realm.write() {
                  todoToBeUpdated.title = updatedTodo.title
                  todoToBeUpdated.priority = updatedTodo.priority
                  todoToBeUpdated.modificationDate = updatedTodo.modificationDate
            }
      }
      
    static func getTodos(sorted sortMethod: TodoSortMethod, nameContains: String?) -> (Results<Todo>) {
            let realm = try! Realm()
            let sortKeyPath = sortMethod == .byDate ? "modificationDate" : "priority"
            var todos = realm.objects(Todo.self).sorted(byKeyPath: sortKeyPath, ascending: false)
            if let searchString = nameContains {
                todos = todos.filter("title CONTAINS \(searchString)")
            }
            dump(todos)
            return todos
      }
}
