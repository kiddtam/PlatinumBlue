//
//  ViewController.swift
//  PlatinumBlue
//
//  Created by 林涛 on 15/12/7.
//  Copyright © 2015年 林涛. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let bule = PlatinumBlue(urlStr: "http://beyondvincent.com/atom.xml")
        bule.parse { (feedInfo : FeedInfo?, feedItems :[FeedItem]?, error : NSError?) -> Void in
            print("\(feedInfo?.description())")
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

