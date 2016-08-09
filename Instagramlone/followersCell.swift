//
//  followersCell.swift
//  Instagramlone
//
//  Created by kevin le on 6/3/16.
//  Copyright © 2016 kevin le. All rights reserved.
//

import UIKit
import Parse

class followersCell: UITableViewCell {

    
    @IBOutlet weak var imgAva: UIImageView!
    
    @IBOutlet weak var lbUsername: UILabel!
    
    @IBOutlet weak var lbbtFollowing: UIButton!
    
    @IBOutlet weak var lblFullname: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        let width = UIScreen.mainScreen().bounds.width
        
        imgAva.frame = CGRectMake(width / 25 , width / 25, width / 6.25, width / 6.25)
        //around avatar
        imgAva.layer.cornerRadius = imgAva.frame.size.width / 2
        imgAva.clipsToBounds = true
        
        lbUsername.frame = CGRectMake(imgAva.frame.origin.x + imgAva.frame.size.width + 10, imgAva.frame.origin.y + imgAva.frame.size.height / 8, (width - (imgAva.frame.origin.x + imgAva.frame.size.width + 10)) * 0.6 - 10, 25)
        lblFullname.frame = CGRectMake(imgAva.frame.origin.x + imgAva.frame.size.width + 10, lbUsername.frame.origin.y + 25, (width - (imgAva.frame.origin.x + imgAva.frame.size.width + 10)) * 0.6 - 10, 20)
        
        // set situation at imgAva center
        lbbtFollowing.frame = CGRectMake(imgAva.frame.origin.x + imgAva.frame.size.width + 20 + lbUsername.frame.size.width, imgAva.frame.origin.y + imgAva.frame.size.height / 2 - 15, (width - (imgAva.frame.origin.x + imgAva.frame.size.width + 10)) * 0.4 - (width / 25), 30)
        
               
    }
    
    @IBAction func btFollowing(sender: AnyObject) {
    
        lbbtFollowing.titleForState(UIControlState.Normal)
        let title = lbbtFollowing.titleLabel?.text
        
        // spitting title of button to get "FOLLOW" string
        let splitTitle = title?.componentsSeparatedByString(" ")
        //print(splitTitle![1])
        
        if splitTitle![1] == "FOLLOW" {
            let object = PFObject(className: "follow")
            object["followers"] = PFUser.currentUser()?.username
            object["followings"] = lbUsername.text
            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                if error == nil {
                    
                    //set color following button when followed
                    self.lbbtFollowing.setFAText(prefixText: "",icon: FAType.FACheck, postfixText: " FOLLOWING", size: 10, forState: UIControlState.Normal)
                    self.lbbtFollowing.setFATitleColor(UIColor.whiteColor())
                    self.lbbtFollowing.backgroundColor = UtilitiesFunc().hexStringToUIColor("#70C050")
                    self.lbbtFollowing.layer.borderColor = UtilitiesFunc().hexStringToUIColor("#70C050").CGColor
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("reloadHomeVC", object: nil)
                    
                }else{
                    print(error?.localizedDescription)
                }
            })
        //if title is "Following", cancel following
        }else {
            let deleteFollowing = PFQuery(className: "follow")
            deleteFollowing.whereKey("followers", equalTo: PFUser.currentUser()!.username!)
            deleteFollowing.whereKey("followings", equalTo: lbUsername.text!)
            deleteFollowing.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) in
                if error == nil {
                    for object in objects! {
                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) in
                            if success {
                                self.lbbtFollowing.setFAText(prefixText: "", icon: FAType.FAPlus, postfixText: " FOLLOW", size: 10, forState: UIControlState.Normal)
                                //set color following button when unfollow
                                let utilitiesFunc = UtilitiesFunc()
                                self.lbbtFollowing.setFATitleColor(utilitiesFunc.hexStringToUIColor("#3897f0"))
                                self.lbbtFollowing.backgroundColor = UIColor.whiteColor()
                                self.lbbtFollowing.layer.cornerRadius = 5
                                self.lbbtFollowing.layer.borderWidth = 1
                                self.lbbtFollowing.layer.borderColor = utilitiesFunc.hexStringToUIColor("#3897f0").CGColor
                                
                                //A noice to reload HOmeVC
                                NSNotificationCenter.defaultCenter().postNotificationName("reloadHomeVC", object: nil)
                            }
                        })
                    }
                }else{
                    print(error?.localizedDescription)
                }
            })
        }
        
    }  
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
