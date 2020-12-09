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
    
    @IBOutlet var list: UITableView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var addButton: UIButton!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Count:", StorageHandler.storageCount())
        return StorageHandler.storageCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        StorageHandler.getStorage()
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = TaskManager.taskCollection[indexPath.item]
        cell.textLabel?.text = item.title
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm"
        cell.detailTextLabel?.text = df.string(from: item.date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TaskManager.currentIndex = indexPath.item
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "edit")
                
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .crossDissolve
        
        present(secondVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print(indexPath.item)
        StorageHandler.delete(index: indexPath.item)
        
        DispatchQueue.main.async { tableView.reloadData() }
    }
    
    @IBAction func new(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "add")
                
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .crossDissolve
        
        present(secondVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list.dataSource = self
        list.delegate = self
        StorageHandler.getStorage()
    }

}

