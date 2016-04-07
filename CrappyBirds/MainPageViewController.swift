//
//  MainPageViewController.swift
//  CrappyBirds
//
//  Created by caoyuxin on 4/7/16.
//  Copyright © 2016 Daniel Hauagge. All rights reserved.
//

import UIKit


class MainPageViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var checkRankButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        password.delegate = self
        startGameButton.enabled = false
        checkRankButton.enabled = false

        // Do any additional setup after loading the view.
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if username.text?.characters.count > 0 && password.text?.characters.count > 0 {
            startGameButton.enabled = true
            checkRankButton.enabled = true
        }
        else {
            startGameButton.enabled = false
            checkRankButton.enabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startGameButtonPressed(sender: UIButton) {
        
    }
    
    @IBAction func checkRankButtonPressed(sender: AnyObject) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
