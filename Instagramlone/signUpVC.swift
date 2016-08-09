//
//  signUpVC.swift
//  Instagramlone
//
//  Created by kevin le on 3/31/16.
//  Copyright © 2016 kevin le. All rights reserved.
//

import UIKit
import Parse

class signUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //profile image
    @IBOutlet weak var imgAva: UIImageView!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRepeatPass: UITextField!
    @IBOutlet weak var txtFullname: UITextField!
    @IBOutlet weak var txtBio: UITextField!
    @IBOutlet weak var txtWebsite: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var btSignUp: UIButton!
    

    @IBOutlet weak var btCancel: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //reset default size
    var scrollViewHeight : CGFloat = 0
    
    // keyboard frame size
    var keyboard = CGRect()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //scrollview frame size
        scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showKeyboard:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideKeybard:", name: UIKeyboardWillHideNotification, object: nil)
        
        //declare hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyboardTap:")
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        //round ava
        imgAva.layer.cornerRadius = imgAva.frame.size.width / 2
        imgAva.clipsToBounds = true
        
        //declare select image tap
        let avaTap = UITapGestureRecognizer(target: self, action: "loadImg:")
        avaTap.numberOfTapsRequired = 1
        imgAva.userInteractionEnabled = true
        imgAva.addGestureRecognizer(avaTap)
    }
    
    //call picker to select image
    
    func loadImg(recognizer:UITapGestureRecognizer){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    //connect selected image to our ImageView
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imgAva.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //hide keyboard if tapped
    func hideKeyboardTap(recoginizer:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    //show keyboard
    func showKeyboard(notification:NSNotification){
        //define keyboard size
        keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey]!.CGRectValue)!
        
        //move up UI
        UIView.animateWithDuration(0.4){ () -> Void in
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        }
    }
    
    
    // hide keyboard
    func hideKeybard(notification:NSNotification){
        //move down UI
        UIView.animateWithDuration(0.4){ () -> Void in
            self.scrollView.frame.size.height = self.scrollViewHeight
        }
    }

    @IBAction func btSignUp_Click(sender: AnyObject) {
        
        //dismiss keyboard
        self.view.endEditing(true)
        
        //if all of fields are empty
        if txtUsername.text!.isEmpty || txtPassword.text!.isEmpty || txtRepeatPass.text!.isEmpty || txtEmail.text!.isEmpty || txtBio.text!.isEmpty || txtWebsite.text!.isEmpty || txtFullname.text!.isEmpty {
        
            // show an alert message
            let alert = UIAlertController(title: "Please", message: "Fill all fields", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        if txtPassword.text != txtRepeatPass.text {
            let alert = UIAlertController(title: "Password", message: "Do not match", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)

        }
        
        //send data to server to relate colllumns
        let user = PFUser()
        user.username = txtUsername.text?.lowercaseString
        user.email = txtEmail.text?.lowercaseString
        user.password = txtPassword.text
        user["fullname"] = txtFullname.text?.lowercaseString
        user["bio"] = txtBio.text
        user["website"] = txtWebsite.text?.lowercaseString
        
        user["tel"] = ""
        user["gender"] = ""
        
        // convert image for sending to server
        let avaData = UIImageJPEGRepresentation(imgAva.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
        
        user.signUpInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            if success {
                print("Registered")
                
                // remember logged
                NSUserDefaults.standardUserDefaults().setObject(user.username, forKey: "username")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                
                //call lofin func from AppDelegate.swift class
                let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.login()
            }else{
                print(error?.localizedDescription)
            }
        }
        
    }

    @IBAction func btCancel_Click(sender: AnyObject) {
        txtUsername.text = ""
        txtPassword.text = ""
        txtBio.text = ""
        txtRepeatPass.text = ""
        txtWebsite.text = ""
        txtFullname.text = ""
        self.view.endEditing(true)
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
