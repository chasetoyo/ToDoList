//
//  AddViewController.swift
//  ToDoList
//
//  Created by cpsc on 12/5/20.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet var inputTitle: UITextField!
    @IBOutlet var inputCategory: UITextField!
    @IBOutlet var inputDate: UIDatePicker!
    
    @IBOutlet var back: UIButton!
    @IBOutlet var done: UIButton!
    
    var inputTask = Task()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTask = Task()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(EditViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @IBAction func goBack(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "main")
                
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .crossDissolve
        
        present(secondVC, animated: true, completion: nil)
    }
    
    @IBAction func saveTask(_ sender: Any) {
//      ensure that the values are updated because the user might not click off the screen before they press the back button
        editTitle(self)
        editCategory(self)
        editDate(self)
        StorageHandler.set(value: inputTask)
        goBack(self)
    }
    
    @IBAction func editTitle(_ sender: Any) {
        let theText = String(inputTitle.text!)
        inputTask.title = theText
    }
    
    @IBAction func editCategory(_ sender: Any) {
        let theText = String(inputCategory.text!)
        inputTask.category = theText
    }
    
    
    @IBAction func editDate(_ sender: Any) {
        print(inputDate.date)
        let theDate = inputDate.date
        inputTask.date = theDate
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        var shouldMoveViewUp = false
        
        if let activeTextField = inputTitle {
            
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            if bottomOfTextField > topOfKeyboard {
                shouldMoveViewUp = true
            }
        }
        
        if(shouldMoveViewUp) {
            self.view.frame.origin.y = 0 - keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @objc func didTapView() {
        self.view.endEditing(true);
    }
}

extension AddViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.inputTitle = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.inputTitle = nil
    }
}
