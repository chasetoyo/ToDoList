//
//  TaskManager.swift
//  ToDoList
//
//  Created by cpsc on 12/5/20.
//

import Foundation

struct TaskManager {
    static var taskCollection: [Task] = []
    static var currentIndex: Int = 0
}

struct Task: Codable {
    var title = "title1"
    var category = "detail1"
    var date = Date()
}
