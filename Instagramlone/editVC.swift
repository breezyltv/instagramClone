//
//  editVC.swift
//  Instagramlone
//
//  Created by kevin le on 6/7/16.
//  Copyright © 2016 kevin le. All rights reserved.
//

import UIKit
import Parse

class editVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imgAva: UIImageView!
    
    @IBOutlet weak var txtFullname: UITextField!
    
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var textWeb: UITextField!
    
    @IBOutlet weak var txtBio: UITextView!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtTel: UITextField!
    
    @IBOutlet weak var txtGender: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
   
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbIconUser: UILabel!
    
    
    var genderPicker : UIPickerView!
    let gender = ["Not Specified","Male", "Female"]
    
    var keyboard = CGRect()
    
    var userIsTaken : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create picker
        genderPicker = UIPickerView()
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.backgroundColor = UIColor.groupTableViewBackgroundColor()
        genderPicker.showsSelectionIndicator = true
        txtGender.inputView = genderPicker
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        //tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        //tap to select avatar
        // this func need adding UIImagePickerControllerDelegate and UINavigationControllerDelegate
        let avaTap = UITapGestureRecognizer(target: self, action: "loadImg:")
        avaTap.numberOfTapsRequired = 1
        imgAva.userInteractionEnabled = true
        imgAva.addGestureRecognizer(avaTap)
        
        getInformationUser()
        
        //make up
        alignment()
        
        txtUsername.addTarget(self, action: "checkUser:", forControlEvents: UIControlEvents.EditingChanged)

        txtUsername.addTarget(self, action: "endSpinner:", forControlEvents: UIControlEvents.EditingDidEnd)
    }
    
    
    func checkUser(textField : UITextField){
        print(txtUsername.text)
        // add a spinner to txtUsername while editing
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        txtUsername.rightView = activityIndicator
        txtUsername.rightViewMode = UITextFieldViewMode.Always
        
        
        if txtUsername.text?.characters.count >= 6 {
            
        activityIndicator.startAnimating()
            
        let uQuery = PFUser.query()
        uQuery?.whereKey("username", equalTo: txtUsername.text!)
        uQuery?.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) in
            if error == nil {
                if objects?.count > 0 {
                    print("is taken")
                    self.userIsTaken = true
                    self.lbIconUser.setFAColor(UIColor.grayColor())
                    self.txtUsername.textColor = UIColor.grayColor()
                    activityIndicator.stopAnimating()
                }else{
                    print("username is available")
                    self.userIsTaken = false
                    self.lbIconUser.setFAColor(UtilitiesFunc().hexStringToUIColor("#70C050"))
                    self.txtUsername.textColor = UtilitiesFunc().hexStringToUIColor("#70C050")
                    activityIndicator.stopAnimating()

                }
            }else{
                print(error?.localizedDescription)
            }
        })
        
        }else{
            self.lbIconUser.setFAColor(UIColor.grayColor())
            self.txtUsername.textColor = UIColor.grayColor()

            activityIndicator.stopAnimating()
        }
        
    }
    
    func endSpinner(textField : UITextField){
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        txtUsername.rightView = activityIndicator
        txtUsername.rightViewMode = UITextFieldViewMode.Always
        activityIndicator.stopAnimating()
    }
    
    
    func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    // when keyboard is shown
    func keyboardWillShow(notification : NSNotification){
        //define keyboard frame size
        keyboard = (notification.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue)!
        
        //move up with animation
        UIView.animateWithDuration(0.4) { () -> Void in
            self.scrollView.contentSize.height = self.view.frame.size.height + self.keyboard.height / 2
        }
        
    }
    
    func keyboardWillHide(notification : NSNotification){
        //move down with animation
        UIView.animateWithDuration(0.4) { () -> Void in
            self.scrollView.contentSize.height = 0
        }
    }
    
    func loadImg(recognizer : UIGestureRecognizer){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imgAva.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //get personal information from current user
    func getInformationUser(){
        let dataAva = PFUser.currentUser()?.objectForKey("ava") as! PFFile
        dataAva.getDataInBackgroundWithBlock({ (dataAva:NSData?, error:NSError?) in
            if error == nil {
                self.imgAva.image = UIImage(data: dataAva!)
            }else{
                print(error?.localizedDescription)
            }
        })
        
        txtUsername.text = PFUser.currentUser()?.username
        txtFullname.text = PFUser.currentUser()?.objectForKey("fullname") as? String
        txtBio.text = PFUser.currentUser()?.objectForKey("bio") as? String
        txtEmail.text = PFUser.currentUser()?.objectForKey("email") as? String
        textWeb.text = PFUser.currentUser()?.objectForKey("website") as? String
        txtTel.text = PFUser.currentUser()?.objectForKey("tel") as? String
        txtGender.text =  PFUser.currentUser()?.objectForKey("gender") as? String
        
    }
    
    func alignment() {
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        scrollView.frame = CGRectMake(0, 0, width, height)
        
        imgAva.frame = CGRectMake(width - 80 - 10, 15, 80, 80)
        imgAva.layer.cornerRadius = imgAva.frame.size.width / 2
        imgAva.clipsToBounds = true
        
        txtFullname.frame = CGRectMake(10, imgAva.frame.origin.y, width - (imgAva.frame.size.width + 35), 30)
        txtUsername.frame = CGRectMake(lbIconUser.frame.origin.x + 35, (15 + imgAva.frame.size.height) - 30, width - (imgAva.frame.size.width + 70), 30)
        lbIconUser.frame = CGRectMake(10, txtUsername.frame.origin.y , 30, 30)

        textWeb.frame = CGRectMake(10, txtUsername.frame.origin.y + 45, width - 20, 30)
        txtBio.frame = CGRectMake(10, textWeb.frame.origin.y + 45 , width - 20, 60)
        
        txtEmail.frame = CGRectMake(10, txtBio.frame.origin.y + 120, width - 20, 30)
        txtTel.frame = CGRectMake(10, txtEmail.frame.origin.y + 45, width - 20, 30)
        txtGender.frame = CGRectMake(10, txtTel.frame.origin.y + 45, width - 20, 30)
        
        lbTitle.frame = CGRectMake(10, txtEmail.frame.origin.y - 40, width - 20, 30)
        
        txtFullname.text?.capitalizedString
        
        lbIconUser.setFAIcon(FAType.FAUser, iconSize: 18)
        lbIconUser.setFAColor(UIColor.grayColor())
        
    }
    
    @IBAction func btCancel(sender: AnyObject) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btSave(sender: AnyObject) {
        if !UtilitiesFunc().isValidEmail(txtEmail.text!) {
            self.presentViewController(UtilitiesFunc().alertPopup("Incorrect Email", message: "Please fill your email correctly!"), animated: true, completion: nil)
            return
        }
        if !UtilitiesFunc().isValidURL(textWeb.text!){
            self.presentViewController(UtilitiesFunc().alertPopup("Incorrect URL", message: "Please fill your website link correctly!"), animated: true, completion: nil)
            return
        }
        
        let userData = PFUser.currentUser()
        userData?.username = txtUsername.text?.lowercaseString
        
        userData?.email = txtEmail.text?.lowercaseString
        
        if txtFullname.text!.isEmpty {
            userData?["fullname"] = ""
        }else{
            userData?["fullname"] = txtFullname.text?.lowercaseString
        }
        
        userData?["website"] = textWeb.text?.lowercaseString
        userData?["bio"] = txtBio.text?.lowercaseString
        
        if txtTel.text!.isEmpty {
            userData?["tel"] = ""
        }else{
            userData?["tel"] = txtTel.text
        }
        
        if txtGender.text!.isEmpty{
            userData?["gender"] = "Not Specified"
        }else{
            userData?["gender"] = txtGender.text
        }
        
        let avaImg = UIImageJPEGRepresentation(imgAva.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avaImg!)
        userData?["ava"] = avaFile
        
        userData?.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) in
            if success {
                //hide keyboard
                self.view.endEditing(true)
                
                //dismis this editVC
                self.dismissViewControllerAnimated(true, completion: nil)
                
                NSNotificationCenter.defaultCenter().postNotificationName("reloadHomeVC", object: nil)
            }
        })

    }
    
    //picker view method
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //picker number of items
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return gender.count
    }
    
    //picker text config
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
    
    //piker did selected some value
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtGender.text = gender[row]
        self.view.endEditing(true)
    }
}

