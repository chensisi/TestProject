//
//  HistoryController.swift
//  TestProject
//
//  Created by 陈思思 on 2020/12/29.
//  Copyright © 2020 陈思思. All rights reserved.
//

import UIKit

class HistoryController: ViewController {
    var textView:UITextView!
    override func viewDidLoad(){
        self.view.backgroundColor = UIColor.white
        
        self.textView = UITextView(frame: CGRect(x: 0, y: 88, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-88))
        self.textView.textColor = UIColor.black
        self.textView.font = UIFont.systemFont(ofSize: 14)
        self.textView.textAlignment = .center
        self.textView.isEditable = false;
        self.view.addSubview(self.textView)
        
        let cacheDate = ViewController.readUrlPlistFiles()
        self.textView.text = cacheDate
        
    }

}
