//
//  ViewController.swift
//  TestProject
//
//  Created by sisi on 2020/12/26.
//  Copyright © 2020 sisi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var timer:Timer!
    var tView:UITextView!
    var saveUrlDataInfo:NSMutableArray!
    private var dataContent: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveUrlDataInfo = NSMutableArray()
        self.tView = UITextView(frame: CGRect(x: 0, y: 88, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-88))
        self.tView.textColor = UIColor.black
        self.tView.font = UIFont.systemFont(ofSize: 14)
        self.tView.textAlignment = .center
        self.tView.isEditable = false;
        self.view.addSubview(self.tView)
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-115, y: UIScreen.main.bounds.height-70, width: 100, height: 50))

        btn.setTitle("历史记录", for: .normal)
        btn.backgroundColor = UIColor.red
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.view.addSubview(btn)
        self.timer = Timer.scheduledTimer(timeInterval: 5,target:self,selector:#selector(tickDown),userInfo:nil,repeats:true)
        let cacheDate = ViewController.readLastPlistFiles()
        if cacheDate != "" {
            self.tView.text = cacheDate
        } else {
            self.tView.text = self.dataContent
        }

    }
    @objc func btnClick(sender: UIButton) {
        let historyvc = HistoryController()
        self.navigationController!.pushViewController(historyvc, animated:true)
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
         
    }
    override func viewWillDisappear(_ animated: Bool){
        let defaults = UserDefaults.standard
        defaults.set(self.saveUrlDataInfo, forKey: "saveUrlDataInfo")
        guard let timer1 = self.timer
        else{ return }
        timer1.invalidate()
    }
    @objc func tickDown()
    {
        NetworkManager().fetchDate{(newStr) in
            self.dataContent = newStr
            let domainUrlString = "https://api.github.com/"
            self.saveUrlPlistFiles(dataStr: domainUrlString)
            self.saveLastRequstPlistFiles(dataStr: newStr)
        }
        

        print(self.dataContent as Any)
    }
    class func creatNewFiles(name:String, fileBaseUrl:NSURL) -> String{
        let manager = FileManager.default
        let file = (fileBaseUrl.appendingPathComponent(name) ?? nil)!
        
        let exist = manager.fileExists(atPath: file.path)
        if !exist {
            let createFilesSuccess = manager.createFile(atPath: file.path, contents: nil, attributes: nil)
            print("文件创建结果: \(createFilesSuccess)")
        }
        return String(file.absoluteString)
    }
    
  
    class func readTheFlies(name:String , fileBaseUrl:NSURL) ->NSString{
        let file = (fileBaseUrl.appendingPathComponent(name) ?? nil)!
        let readHandler = try! FileHandle(forReadingFrom:file)
        let data = readHandler.readDataToEndOfFile()
        let readString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        return readString!
    }

    private func saveUrlPlistFiles(dataStr:String){
            // 储存的沙盒路径
            let manager = FileManager.default
            let urlForCatch = manager.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
            let url = urlForCatch.first! as NSURL
            let fileName = "UrlDataCache.plist"
            // 创建文件
            let filesPath = ViewController.creatNewFiles(name: fileName, fileBaseUrl: url)
            // 储存数据
            let defaults = UserDefaults.standard
            let str = defaults.object(forKey:"saveUrlDataInfo")
            if str != nil {
                self.saveUrlDataInfo.add(str as Any)
                self.saveUrlDataInfo.add(dataStr)
                defaults.set(nil, forKey: "saveUrlDataInfo")
            }else{
                self.saveUrlDataInfo.add(dataStr)
            }
            // 写入文件
            self.saveUrlDataInfo.write(to: NSURL(string: filesPath)! as URL, atomically: true)
           
        }
    private func saveLastRequstPlistFiles(dataStr:String){
            // 储存的沙盒路径
            let manager = FileManager.default
            let urlForCatch = manager.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
            let url = urlForCatch.first! as NSURL
            let fileName = "LastReqDataCache.plist"
            // 创建文件
            let filesPath = ViewController.creatNewFiles(name: fileName, fileBaseUrl: url)
            // 储存数据
            let saveDataInfo = NSMutableArray()
            saveDataInfo.add(dataStr)
            // 写入文件
            saveDataInfo.write(to: NSURL(string: filesPath)! as URL, atomically: true)
           
        }
   class func readPlistFiles()-> String{
        let manager = FileManager.default
        let urlForCatch = manager.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        let url = urlForCatch.first! as NSURL
        let fileName = "DataCache.plist"
        // 读取文件
        let readDataInfo = ViewController.readTheFlies(name: fileName, fileBaseUrl: url)
        print(readDataInfo)
        return readDataInfo as String
    }

    class func readUrlPlistFiles()-> String{
        let manager = FileManager.default
        let urlForCatch = manager.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        let url = urlForCatch.first! as NSURL
        let fileName = "UrlDataCache.plist"
        // 读取文件
        let readDataInfo = ViewController.readTheFlies(name: fileName, fileBaseUrl: url)
        print(readDataInfo)
        return readDataInfo as String
    }
    class func readLastPlistFiles()-> String{
        let manager = FileManager.default
        let urlForCatch = manager.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        let url = urlForCatch.first! as NSURL
        let fileName = "LastReqDataCache.plist"
        // 读取文件
        let readDataInfo = ViewController.readTheFlies(name: fileName, fileBaseUrl: url)
        print(readDataInfo)
        return readDataInfo as String
    }
}

