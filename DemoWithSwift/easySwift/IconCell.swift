//
//  IconCell.swift
//  easySwift
//
//  Created by 朱潮 on 14-7-17.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

import UIKit

class IconCell: UICollectionViewCell {

    var iconMainView:EzUILabel!
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        iconMainView = EzUILabel(frame: CGRectMake(0, 0, 50, 50))
        iconMainView.textAlignment = NSTextAlignment.Center
        self.addSubview(iconMainView)
    }
    
}
