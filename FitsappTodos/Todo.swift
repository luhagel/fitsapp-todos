//
//  Todo.swift
//  FitsappTodos
//
//  Created by Luca Hagel on 3/14/17.
//  Copyright © 2017 Luca Hagel. All rights reserved.
//

import Foundation
import RealmSwift

enum TodoPriority: Int {
  case none = 0
  case low = 1
  case medium = 2
  case high = 3
}

class Todo: Object {
  dynamic var title: String = ""
  dynamic var priority: TodoPriority = .none
  dynamic var modificationDate = NSDate()
  
  @objc enum TodoPriority: Int {
    case none = 0
    case low = 1
    case medium = 2
    case high = 3
  }
}
