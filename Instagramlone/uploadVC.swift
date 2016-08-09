//
//  uploadVC.swift
//  Instagramlone
//
//  Created by kevin le on 8/8/16.
//  Copyright © 2016 kevin le. All rights reserved.
//

import UIKit

class uploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imgPic: UIImageView!
    
    @IBOutlet weak var txtTitle: UITextView!

    @IBOutlet weak var btLbPublish: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btLbPublish.enabled = false
        btLbPublish.backgroundColor = UIColor.lightGrayColor()
        
        
        //tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        //sellect a pic by tap
        let picTap = UITapGestureRecognizer(target: self, action: "sellectPic")
        picTap.numberOfTapsRequired = 1
        imgPic.userInteractionEnabled = true
        imgPic.addGestureRecognizer(picTap)
        
    }

    func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    func sellectPic(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imgPic.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //enable Publish button
        btLbPublish.enabled = true
        btLbPublish.backgroundColor = UtilitiesFunc().hexStringToUIColor("047fb8")
        
        //add Tap for zooming picture
        let zoomTap = UITapGestureRecognizer(target: self, action: "zoomPic")
        zoomTap.numberOfTapsRequired = 1
        imgPic.userInteractionEnabled = true
        imgPic.addGestureRecognizer(zoomTap)
        
        
    }
    
    func zoomPic (){
        
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
