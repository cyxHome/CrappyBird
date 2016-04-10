//
//  MainPageViewController.swift
//  CrappyBirds
//
//  Created by caoyuxin on 4/7/16.
//

import UIKit
import RealmSwift
import MobileCoreServices
import Firebase


class LoginPageViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var locationLat: UILabel!
    @IBOutlet weak var locationLng: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let realm = try! Realm()
    var alert = UIAlertController()
    let accountsRef = Firebase(url: "https://crappybird2049.firebaseio.com/accounts")
    
    // none sense location
    var coordinate : CLLocationCoordinate2D?
    var locationManager: CLLocationManager!
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // wait 10 seconds so the location services can becomes stable.
        let loc = locations[locations.count-1]
        coordinate = loc.coordinate
        let lat = coordinate!.latitude as Double
        let lng = coordinate!.longitude as Double
        locationLat.text = "your latitude: \(lat)"
        locationLng.text = "your longitude: \(lng)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        username.addTarget(self, action: #selector(LoginPageViewController.checkAndEnableLoginButton), forControlEvents: UIControlEvents.EditingChanged)
        password.addTarget(self, action: #selector(LoginPageViewController.checkAndEnableLoginButton), forControlEvents: UIControlEvents.EditingChanged)
        loginButton.hidden = true
        loginButton.layer.cornerRadius = 15
        self.hideKeyboardWhenTappedAround()
    }
    
    func checkAndEnableLoginButton() {
        if username.text?.characters.count > 0 && password.text?.characters.count > 0 {
            loginButton.hidden = false
        }
        else {
            loginButton.hidden = true
        }
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        let username = self.username.text!
        let password = self.password.text!
        self.username.text = ""
        self.password.text = ""
        accountsRef.childByAppendingPath(username).observeSingleEventOfType(.Value, withBlock: { snap in
            if snap.value is NSNull {
                // username doesn't exist
                self.signupSucceed(username, password: password)
            }
            else {
                // the username has been taken
                if snap.value.objectForKey("password") as! String == password {
                    self.loginSucceed(username, password: password);
                    let title = "Success"
                    let msg = "You just login to your account: \(username) \n Welcome back!"
                    let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainScreenNavigationViewController")
                    self.showAlert(title, msg: msg, nextViewController: nextViewController)
                }
                else {
                    let title = "Sorry"
                    let msg = "The username exists, please enter right password"
                    self.showAlert(title, msg: msg, nextViewController: nil)
                }
            }
        })

    }
    
    func loginSucceed(username: String, password: String) {
        storeUserInfoIntoRealm(username, password: password)
    }
    
    // store the username and password to Firebase and realm
    func signupSucceed(username: String, password: String) {
        storeUserInfoIntoRealm(username, password: password)
        createUserAccountInFirebase(username, password: password)
    }
    
    // create account in Firebase and jump to main screen
    func createUserAccountInFirebase(username: String, password: String) {
        accountsRef.childByAppendingPath(username).childByAppendingPath("password").setValue(password, withCompletionBlock: { error, result in
            let title = "Success"
            let msg = "You just create an account: \(username) \n please keep your password safe."
            let nextViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainScreenNavigationViewController")
            self.showAlert(title, msg: msg, nextViewController: nextViewController!)
        })
    }
    
    func storeUserInfoIntoRealm(username: String, password: String) {
        let account = Account()
        account.username = username
        account.password = password
        try! realm.write({ 
            realm.add(account, update: true)
        })
    }
    
    func checkTheUsernameIsTaken() -> Bool {
        if (realm.objects(Account).filter("username == '\(self.username.text!)'").count > 0) {
            return true
        }
        else {
            return false
        }
    }
    
    func showAlert(title: String, msg: String, nextViewController: UIViewController?) {
        alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            if let next = nextViewController {
                self.presentViewController(next, animated:true, completion:nil)
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

}
