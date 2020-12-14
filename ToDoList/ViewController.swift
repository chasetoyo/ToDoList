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
    
//    var dateSelected = true
    
    var containerView = UIView()
    var slideUpView = UITableView()
    let slideUpViewHeight: CGFloat = 200
    
    // our simple data source
    let slideUpViewDataSource: [Int: String] = [
      0: ("Date"),
      1: ("Category")
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // task list
        if tableView == list {
            return StorageHandler.storageCount()
        }
        //slide up menu
        else {
            return slideUpViewDataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        StorageHandler.getStorage()
        //task list
        if tableView == list {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
           
            //set title, category, date
            let item = TaskManager.taskCollection[indexPath.item]
            cell.textLabel?.text = item.title
            if TaskManager.dateSelected == true {
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd hh:mm"
                cell.detailTextLabel?.text = df.string(from: item.date)
            }
            else {
                cell.detailTextLabel?.text = item.category
            }
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SortingTableViewCell", for: indexPath) as? SortingTableViewCell
        else { fatalError("unable to deque SortingTableViewCell") }
        //set cell text
        cell.labelView.text = slideUpViewDataSource[indexPath.row]
          return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //delete if its the list cell tapped
        if tableView == list {
            print(indexPath.item)
            StorageHandler.delete(index: indexPath.item)
            
            DispatchQueue.main.async { tableView.reloadData()
            }
            sceneTransition(scene: "main")
        }
        //sort if its the slide up cell tapped
        else {
            if indexPath.item == 0 {
                sortByDate(self)
                slideUpViewTapped()
            }
            else {
                sortByCategory(self)
                slideUpViewTapped()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt
             indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //open editing view
        TaskManager.currentIndex = indexPath.item
        sceneTransition(scene: "edit")
    }
    
    @IBAction func new(_ sender: Any) {
        //open add item view controller
       sceneTransition(scene: "add")
    }
    
    
    @IBAction func sortByDate(_ sender: Any) {
        //sort by ascending date
        TaskManager.taskCollection.sort {
               $0.date < $1.date
        }
        StorageHandler.set()
        TaskManager.dateSelected = true
        list.reloadData()
    }
    
    @IBAction func sortByCategory(_ sender: Any) {
        //sort alphanumerically
        TaskManager.taskCollection.sort {
            $0.category < $1.category
        }
        TaskManager.dateSelected = false
        StorageHandler.set()
        list.reloadData()
    }
    
    //on opening
    @IBAction func buttonTapped(_ sender: UIButton) {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        containerView.frame = self.view.frame
        window?.addSubview(containerView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(slideUpViewTapped))
        containerView.addGestureRecognizer(tapGesture)
        containerView.alpha = 0

        let screenSize = UIScreen.main.bounds.size
          slideUpView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: slideUpViewHeight)
          slideUpView.separatorStyle = .none
          window?.addSubview(slideUpView)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.containerView.alpha = 0.8
            self.slideUpView.frame = CGRect(x: 0, y: screenSize.height - self.slideUpViewHeight, width: screenSize.width, height: self.slideUpViewHeight)
          }, completion: nil)
    }
    
    // On closing
    @objc func slideUpViewTapped() {
        let screenSize = UIScreen.main.bounds.size
          UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
        self.containerView.alpha = 0
        self.slideUpView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.slideUpViewHeight)
          }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list.dataSource = self
        list.delegate = self
        
        slideUpView.isScrollEnabled = true
        slideUpView.delegate = self
        slideUpView.dataSource = self
        slideUpView.register(SortingTableViewCell.self, forCellReuseIdentifier: "SortingTableViewCell")
        
        StorageHandler.getStorage()
    }
    
    func sceneTransition(scene: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: scene)
                
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .crossDissolve
        
        present(secondVC, animated: true, completion: nil)
    }

}
