//
//  signInVC.swift
//  Instagramlone
//
//  Created by kevin le on 3/31/16.
//  Copyright © 2016 kevin le. All rights reserved.
//

import UIKit
import Parse

class signInVC: UIViewController {

    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var btSignIn: UIButton!
    @IBOutlet weak var btSignUp: UIButton!
    @IBOutlet weak var btResetPass: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbTitle.frame = CGRectMake(10, 80, self.view.frame.size.width - 20, 50)
        usernameTxt.frame = CGRectMake(10, lbTitle.frame.origin.y + 70, self.view.frame.size.width - 20, 30)
        passwordTxt.frame = CGRectMake(10, usernameTxt.frame.origin.y + 40, self.view.frame.size.width - 20, 30)
        
        btResetPass.frame = CGRectMake(10, passwordTxt.frame.origin.y + 30, self.view.frame.size.width - 20, 30)
        btSignIn.frame = CGRectMake(20, btResetPass.frame.origin.y + 40, self.view.frame.size.width / 4, 30)
        btSignUp.frame = CGRectMake(self.view.frame.size.width - (self.view.frame.size.width / 4 + 20), btSignIn.frame.origin.y, self.view.frame.size.width / 4, 30)
        // Do any additional setup after loading the view.
    }


    
    @IBAction func btSignIn_Click(sender: AnyObject) {
        //hide keyboard
        self.view.endEditing(true)
        
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty{
            // show an alert message
            let alert = UIAlertController(title: "Please", message: "Fill all fields", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        //login functions
        PFUser.logInWithUsernameInBackground(usernameTxt.text!, password: passwordTxt.text!){
            (user:PFUser?, error:NSError?) -> Void in
            if error == nil {
                
                //remember user of save in App memory did user
                NSUserDefaults.standardUserDefaults().setObject(user!.username, forKey: "username")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                
                // call login func from AppDelegate.swift class
                let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.login()
            }else{
                
                if error?.localizedDescription == "Invalid username/password."{
                    // show an alert message
                    let alert = UIAlertController(title: "Notification", message: "Your username or pass are invalid", preferredStyle: UIAlertControllerStyle.Alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                    alert.addAction(ok)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
                print(error?.localizedDescription)
                
            }
        }
        
    }
    
    @IBAction func btSignUp_Click(sender: AnyObject) {
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
