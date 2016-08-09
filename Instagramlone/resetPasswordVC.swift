//
//  resetPasswordVC.swift
//  Instagramlone
//
//  Created by kevin le on 3/31/16.
//  Copyright © 2016 kevin le. All rights reserved.
//

import UIKit
import Parse

class resetPasswordVC: UIViewController {

    @IBOutlet weak var txtResetEmail: UITextField!
    
    @IBOutlet weak var btReset: UIButton!
    
    @IBOutlet weak var btCancel: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btResetEmail_Click(sender: AnyObject) {
        
        //hide keyboard
        self.view.endEditing(true)
        
        if txtResetEmail.text!.isEmpty {
            // show an alert message
            let alert = UIAlertController(title: "Please", message: "Fill your email", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
        //request to reset password by emal
        PFUser.requestPasswordResetForEmailInBackground(txtResetEmail.text!){ (success:Bool, error:NSError?) -> Void in
            if success {
                //show an alert message
                let alert = UIAlertController(title: "Notification", message: "A link for reset email has sent to your email.", preferredStyle: UIAlertControllerStyle.Alert)
                
                //If pressed ok then call self.dismis.. func
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: {(UIAlertAction) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                print(error?.localizedDescription)
            }
            
        }
    }
    
    @IBAction func btCancel_Click(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
