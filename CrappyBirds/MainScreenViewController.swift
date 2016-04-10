//
//  MainScreenViewController.swift
//  CrappyBirds
//
//  Created by caoyuxin on 4/9/16.
//

import UIKit
import RealmSwift

class MainScreenViewController: UIViewController {
    
    @IBOutlet weak var mainScreenTitle: UILabel!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        mainScreenTitle.text = "Hello \((realm.objects(Account).first?.username)!)"
    }

    @IBAction func startGameButtonPressed(sender: UIButton) {
        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GameViewController")
        presentViewController(nextViewController!, animated:true, completion:nil)
    }

    @IBAction func logoutButtonPressed(sender: UIButton) {
        deleteCurrentAccountFromRealm()
        let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginPageViewController")
        presentViewController(nextViewController!, animated:true, completion:nil)
    }
    
    func deleteCurrentAccountFromRealm() {
        try! realm.write({
            realm.deleteAll()
        })
    }

}
