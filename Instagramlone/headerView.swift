//
//  headerView.swift
//  Instagramlone
//
//  Created by kevin le on 4/25/16.
//  Copyright © 2016 kevin le. All rights reserved.
//

import UIKit

class headerView: UICollectionReusableView {
 
    @IBOutlet weak var imgAva: UIImageView!
    @IBOutlet weak var lbFullname: UILabel!
    @IBOutlet weak var txtWeb: UITextView!
    @IBOutlet weak var lbBio: UILabel!
    
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var followings: UILabel!
    
    @IBOutlet weak var followersTitle: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var followingsTitle: UILabel!
    
    @IBOutlet weak var btEdit: UIButton!
    
    override func awakeFromNib() {
        let width = UIScreen.mainScreen().bounds.width
        
        imgAva.frame = CGRectMake(width / 16 , width / 16, width / 4, width / 4)
        
        posts.frame = CGRectMake(width / 2.5, imgAva.frame.origin.y, 50, 30)
        followers.frame = CGRectMake(width / 1.655, imgAva.frame.origin.y, 50, 30)
        followings.frame = CGRectMake(width / 1.25, imgAva.frame.origin.y, 50, 30)
        
        postTitle.center = CGPointMake(posts.center.x, posts.center.y + 20)
        followersTitle.center = CGPointMake(followers.center.x, followers.center.y + 20)
        followingsTitle.center = CGPointMake(followings.center.x, followings.center.y + 20)
        
        btEdit.frame = CGRectMake(postTitle.frame.origin.x, postTitle.frame.origin.y + 25, width - (postTitle.frame.origin.x + 10), 30)
        
        lbFullname.frame = CGRectMake(imgAva.frame.origin.x, imgAva.frame.origin.y + imgAva.frame.size.height + 10, width - 20, 30)
        lbBio.frame = CGRectMake(imgAva.frame.origin.x, lbFullname.frame.origin.y + 30, width - 20, 15)
        txtWeb.frame = CGRectMake(imgAva.frame.origin.x - 5, lbBio.frame.origin.y + 15, width - 20, 15)
        
        
    }
        
}
