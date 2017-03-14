//
//  TodoItemTableViewCell.swift
//  FitsappTodos
//
//  Created by Luca Hagel on 3/14/17.
//  Copyright © 2017 Luca Hagel. All rights reserved.
//

import UIKit

protocol TodoItemTableViewCellDelegate {
    func cyclePriority(_ sender: TodoItemTableViewCell)
}

class TodoItemTableViewCell: UITableViewCell {
    var delegate: TodoItemTableViewCellDelegate?
    var todoItem: Todo!
    
    @IBOutlet weak var todoTitleLabel: UILabel!
    @IBOutlet weak var todoDateLabel: UILabel!
    @IBOutlet weak var todoPriorityButton: UIButton!
    
    @IBAction func todoPriorityButton(_ sender: Any) {
        delegate?.cyclePriority(self)
    }
}
