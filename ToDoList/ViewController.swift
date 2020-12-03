//
//  ViewController.swift
//  ToDoList
//
//  Created by cpsc on 12/3/20.
//

//Scrollable view of task list (so UITableView or UICollectionView, unless you want to build your own)
//Task list should be sortable by two predefined options - title and due date
//Detail view - popup, tab, etc. of the details.
//Details should include editable task title, due date, and notes


import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myarray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(myarray[indexPath.item])
        return cell
    }
    
    @IBOutlet var list: UITableView!
    @IBOutlet var mainView: UIView!

    
    let myarray = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list.dataSource = self
        list.delegate = self
    }

}

