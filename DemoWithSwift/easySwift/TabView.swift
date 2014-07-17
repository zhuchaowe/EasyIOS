//
//  TabView.swift
//  easySwift
//
//  Created by 朱潮 on 14-7-17.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

import UIKit

class TabView: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        IconFont.loadFontList()
//        
//        var array:NSArray = [["name":"FontAwesome",
//                        "icon":"fa_user"],
//                            ["name":"fontcustom",
//                                "icon":"addressBook"],
//                            ["name":"Ionicons",
//                                "icon":"androidAlarm"],
//                            ["name":"Zocial-Regular",
//                                    "icon":"disqus"]]
//    
//        var i = 0
//        for item in self.tabBar.items {
//            var dict = array.objectAtIndex(i) as NSDictionary
//            var showFont = dict.objectForKey("name") as String
//            var icon = dict.objectForKey("icon") as String
//            
//            var image = IconFont.imageWithIcon(IconFont.icon(icon, fromFont: showFont), fontName: showFont, iconColor: UIColor.blackColor(), iconSize: 30)
//            item.title = showFont
//            item.image = image
//            var item2:UITabBarItem = item as UITabBarItem
//            item2 = UITabBarItem(title: showFont, image: image, selectedImage: image)
//            i++
//        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
