//
//  Foundation.swift
//  easySwift
//
//  Created by 朱潮 on 14-7-17.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

import UIKit

class FoundationScene: Scene {

    @IBOutlet  var collectionView: SceneCollectionView!
    var dict:NSDictionary!
    var showFont:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        showFont = foundationIcons

        self.collectionView.registerClass(IconCell.classForCoder(), forCellWithReuseIdentifier: "IconCell")
        self.collectionView.backgroundColor = UIColor(string: "#E9E9E9");
        var fontDict:NSDictionary = NSDictionary.objectFromData(NSData.fromResource("fontIconConfig.json")) as NSDictionary
        var json:NSString = fontDict.objectForKey(showFont).objectForKey("json") as NSString
        dict = NSDictionary.objectFromData(NSData.fromResource(json)) as NSDictionary
        self.collectionView.dataArray = NSMutableArray(array: dict.allKeys)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int{
        return self.collectionView.dataArray.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int{
        return 1
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell!{
        var cell:IconCell = collectionView.dequeueReusableCellWithReuseIdentifier("IconCell", forIndexPath: indexPath) as IconCell
        var key = self.collectionView.dataArray.objectAtIndex(indexPath.row) as String
        var icon = dict.objectForKey(key) as String
        IconFont.label(cell.iconMainView, fontName: showFont, setIcon: icon, size: 50.0, color: UIColor.blackColor(), sizeToFit:true)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize{
        return CGSizeMake(50, 65)
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!){
        var key = self.collectionView.dataArray.objectAtIndex(indexPath.row) as String
        DialogUtil.showDlgAlert(key)
    }

}
