//
//  homeVC.swift
//  Instagramlone
//
//  Created by kevin le on 4/25/16.
//  Copyright © 2016 kevin le. All rights reserved.
//

import UIKit
import Parse

//private let reuseIdentifier = "Cell"

class homeVC: UICollectionViewController {
    
    var refresher : UIRefreshControl!
    
    var page : Int = 10
    
    var uuidArray = [String]()
    
    var picArray = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .whiteColor()
        
        //set tile name on navigation
        self.navigationItem.title = PFUser.currentUser()?.username?.uppercaseString

        // pull to refresh page
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: "refreshAction", forControlEvents: UIControlEvents.ValueChanged)
        collectionView?.addSubview(refresher)
        
        // make space between each collection items
        let flow = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        let width = UIScreen.mainScreen().bounds.size.width - 2
        flow.itemSize = CGSizeMake(width/3, width/3)
        flow.minimumInteritemSpacing = 1
        flow.minimumLineSpacing = 1
        
        
        //load post func
        loadPosts()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reload:", name: "reloadHomeVC", object: nil)
    }
    
    
    // refreshing func
    func refreshAction (){
        //reload data
        collectionView?.reloadData()
        
        // stop refreher animating
        refresher.endRefreshing()
    }
    
    func reload(notification : NSNotification){
        collectionView?.reloadData()
    }
    
    //load post by current user
    
    func loadPosts(){
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        query.limit = page
        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error : NSError?) -> Void in
            if error == nil {
                
                //clean up
                self.uuidArray.removeAll(keepCapacity: false)
                self.picArray.removeAll(keepCapacity: false)
                
                //find objects to relate our request
                for object in objects! {
                    
                    //add data to array
                    self.uuidArray.append(object.valueForKey("uuid") as! String)
                    self.picArray.append(object.valueForKey("pic") as! PFFile)
                }
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return picArray.count
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! pictureCell
        
        picArray[indexPath.row].getDataInBackgroundWithBlock { (imgData : NSData?, error: NSError?) -> Void in
            if error == nil{
                cell.imgPicture.image = UIImage(data: imgData!)
            }
        }
        
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        //define header
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! headerView
        
        
        //around avatar
        header.imgAva.layer.cornerRadius = header.imgAva.frame.size.width / 2
        header.imgAva.clipsToBounds = true
        
        //get current user data from Parse
        header.lbFullname.text = (PFUser.currentUser()?.objectForKey("fullname") as! String).uppercaseString
        header.txtWeb.text = PFUser.currentUser()?.objectForKey("website") as? String
        header.txtWeb.sizeToFit()
        header.lbBio.text = PFUser.currentUser()?.objectForKey("bio") as? String
        header.lbBio.sizeToFit()
        
        let avaQ = PFUser.currentUser()?.objectForKey("ava") as! PFFile
        avaQ.getDataInBackgroundWithBlock { (imgData:NSData?, error:NSError?) -> Void in
            if (error == nil){
                header.imgAva.image = UIImage(data:imgData!)
            }
        }
        
        header.btEdit.setTitle("Edit Your Profile", forState: UIControlState.Normal)
        
        //count post
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        posts.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            if error == nil {
                header.posts.text = "\(count)"
            }
        }
        
        //count followers
        let followers = PFQuery(className: "follow")
        followers.whereKey("followings", equalTo: PFUser.currentUser()!.username!)
        followers.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            if error == nil {
                header.followers.text = String(count)
            }
        }
        
        //count followings
        let followings = PFQuery(className: "follow")
        followings.whereKey("followers", equalTo: PFUser.currentUser()!.username!)
        followings.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            if error == nil {
                header.followings.text = String(count)
            }
        }
        
        //implement tap gesture
        // Tap posts
        let postsTap = UITapGestureRecognizer(target: self, action: "postsTap")
        postsTap.numberOfTapsRequired = 1
        header.posts.userInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        
        //tap followers
        let followersTap = UITapGestureRecognizer(target: self, action: "followersTap")
        followersTap.numberOfTapsRequired = 1
        header.followers.userInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        //tap following
        let followingTap = UITapGestureRecognizer(target: self, action: "followingTap")
        followingTap.numberOfTapsRequired = 1
        header.followings.userInteractionEnabled = true
        header.followings.addGestureRecognizer(followingTap)
        
        return header
        
    }
    
    func postsTap(){
        if !picArray.isEmpty {
            //when tap on Posts, scrolling to posts
            let index = NSIndexPath(forItem: 0, inSection: 0)
            self.collectionView?.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.Top, animated: true)
        }
    }
    
    func followersTap(){
        
        
        user = PFUser.currentUser()!.username!
        show = "followers"
        
        // make referrence to followersVC
        let followers = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
        self.navigationController?.pushViewController(followers, animated: true)
        
    }
    
    func followingTap(){
        user = PFUser.currentUser()!.username!
        show = "following"
        
        // make referrence to followersVC
        let following = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
        self.navigationController?.pushViewController(following, animated: true)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
/*
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }




*/
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
