//
//  AddSchedViewController.swift
//  
//
//  Created by Natalie on 3/18/18.
//

import UIKit

class AddSchedViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    var courseName: String?
    
    
    @IBAction func editedTextField(_ sender: Any) {
        courseName = textField.text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
