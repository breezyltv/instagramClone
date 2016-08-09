//
//  followersVC.swift
//  Instagramlone
//
//  Created by kevin le on 6/3/16.
//  Copyright © 2016 kevin le. All rights reserved.
//

import UIKit
import Parse

var show = String()
var user = String()


class followersVC: UITableViewController {
    
    var usernameArray = [String]()
    var avaArray = [PFFile]()
    var fullnamArray = [String]()
    
    var followArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = show.capitalizedString
        
        if show == "followers" {
            loadFollowers()
        }
        if show == "following" {
            loadFollowing()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func loadFollowers(){
        
//        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
//        self.tableView.backgroundView = activityIndicatorView
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("followings", equalTo: user)
        followQuery.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                
                
                self.followArray.removeAll(keepCapacity: false)
                
                //get username of followers
                for object in objects! {
                    self.followArray.append(object.valueForKey("followers") as! String)
                }
                
                // get avatar of followers
                let userQuery = PFUser.query()
                userQuery?.whereKey("username", containedIn: self.followArray)
                userQuery?.addDescendingOrder("createdAt")
                userQuery?.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                    
                    if error == nil {
                        //clean up
                        self.usernameArray.removeAll(keepCapacity: false)
                        self.avaArray.removeAll(keepCapacity: false)
                        self.fullnamArray.removeAll(keepCapacity: false)
                        
                        for object in objects! {
                            self.usernameArray.append(object.objectForKey("username") as! String)
                            self.fullnamArray.append(object.objectForKey("fullname") as! String)
                            self.avaArray.append(object.objectForKey("ava") as! PFFile)
                        }
                        self.tableView.reloadData()

                    }else{
                        print(error?.localizedDescription)
                    }
                    
                })
            }else{
                print(error?.localizedDescription)
            }
        }
    }
    
    func loadFollowing(){
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("followers", equalTo: user)
        followQuery.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                self.followArray.removeAll(keepCapacity: false)
                //get username of followers
                for object in objects! {
                    self.followArray.append(object.valueForKey("followings") as! String)
                }
                
                // get avatar of followers
                let userQuery = PFUser.query()
                userQuery?.whereKey("username", containedIn: self.followArray)
                userQuery?.addDescendingOrder("createdAt")
                userQuery?.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                    
                    if error == nil {
                        self.usernameArray.removeAll(keepCapacity: false)
                        self.avaArray.removeAll(keepCapacity: false)
                        self.fullnamArray.removeAll(keepCapacity: false)
                        
                        for object in objects! {
                            self.usernameArray.append(object.objectForKey("username") as! String)
                            self.fullnamArray.append(object.objectForKey("fullname") as! String)
                            self.avaArray.append(object.objectForKey("ava") as! PFFile)
                        }
                        self.tableView.reloadData()
                    }else{
                        print(error?.localizedDescription)
                    }
                    
                })
            }else{
                print(error?.localizedDescription)
            }

        }
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return followArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //define cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! followersCell
        
        // set row height in cell
        self.tableView.rowHeight = self.view.frame.size.width / 5
        
        cell.lbUsername.text = usernameArray[indexPath.row]
        cell.lblFullname.text = fullnamArray[indexPath.row].capitalizedString
        
        avaArray[indexPath.row].getDataInBackgroundWithBlock { (avaData:NSData?, error:NSError?) -> Void in
            if error == nil{
                cell.imgAva.image = UIImage(data: avaData!)
            }else{
                print(error?.localizedDescription)
            }
        }
        
        
        //if user is following in followers, set title button is "Following" or if not set title is "Follow"
        let query = PFQuery(className: "follow")
        query.whereKey("followers", equalTo: PFUser.currentUser()!.username!)
        query.whereKey("followings", equalTo: cell.lbUsername.text!)
        query.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            if error == nil {
                if count == 0 {
    
                    //set custom color using by hex string color func
                    //cell.lbbtFollowing.setTitle("\u{002B} FOLLOW", forState: UIControlState.Normal)
                    cell.lbbtFollowing.setFAText(prefixText: "", icon: FAType.FAPlus, postfixText: " FOLLOW", size: 10, forState: UIControlState.Normal)
                    cell.lbbtFollowing.backgroundColor = UIColor.clearColor()
                    cell.lbbtFollowing.layer.cornerRadius = 5
                    cell.lbbtFollowing.layer.borderWidth = 1
                    cell.lbbtFollowing.layer.borderColor = UtilitiesFunc().hexStringToUIColor("#3897f0").CGColor
                    cell.lbbtFollowing.setTitleColor(UtilitiesFunc().hexStringToUIColor("#3897f0"), forState: UIControlState.Normal)

                }else{
                    //set color followed button
                    cell.lbbtFollowing.setFAText(prefixText: "",icon: FAType.FACheck, postfixText: " FOLLOWING", size: 10, forState: UIControlState.Normal)
                    cell.lbbtFollowing.setFATitleColor(UIColor.whiteColor())
                    cell.lbbtFollowing.layer.cornerRadius = 5
                    cell.lbbtFollowing.backgroundColor = UtilitiesFunc().hexStringToUIColor("#70C050")
                    cell.lbbtFollowing.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                    cell.lbbtFollowing.layer.borderColor = UtilitiesFunc().hexStringToUIColor("#70C050").CGColor
                }
            }
        }
        
        return cell
    }
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
