//
//  ViewController.swift
//  WebViewTestSwift
//
//  Created by leehoseok on 2018. 3. 22..
//  Copyright © 2018년 leehoseok. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var lblLog:UILabel!
    var wkWebView:WKWebView!
    var date:Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var rect:CGRect
        var btn:UIButton
        let font = UIFont.systemFont(ofSize: 11)
        let f = UIApplication.shared.statusBarFrame.height
        let bgColor = UIColor.darkGray
        let textColor = UIColor.white
        
        rect = CGRect(x: 0, y: f+40, width: view.frame.size.width, height: view.frame.size.height - (f+40))
        let config = WKWebViewConfiguration()
        config.processPool = Singleton.sharedInstance.pp
        let wk = WKWebView.init(frame: rect, configuration: config)
        wk.uiDelegate = self
        wk.navigationDelegate = self
        self.view.addSubview(wk)
        self.wkWebView = wk
        
        rect = CGRect(x: self.view.frame.size.width - 100, y: f, width: 90, height: 30)
        let lbl = UILabel.init(frame: rect)
        lbl.backgroundColor = bgColor
        lbl.textColor = textColor
        lbl.font = font
        lbl.textAlignment = .center
        self.view.addSubview(lbl)
        self.lblLog = lbl
        
        rect = CGRect(x: 10, y: f, width: 90, height: 30)
        btn = UIButton.init(frame: rect)
        btn.titleLabel?.font = font
        btn.setTitleColor(textColor, for: .normal)
        btn.setTitle("새창", for: .normal)
        btn.backgroundColor = bgColor
        btn.addTarget(self, action: #selector(didClickButton1(_:)), for: .touchUpInside)
        self.view.addSubview(btn)
        
        rect.origin.x += rect.size.width + 10
        btn = UIButton.init(frame: rect)
        btn.titleLabel?.font = font
        btn.setTitleColor(textColor, for: .normal)
        btn.setTitle("load request", for: .normal)
        btn.backgroundColor = bgColor
        btn.addTarget(self, action: #selector(didClickButton2(_:)), for: .touchUpInside)
        self.view.addSubview(btn)
    }

    @objc func didClickButton1(_ sender: UIButton) {
        let vc = ViewController()
        let r = CGFloat(arc4random_uniform(255))/255
        let g = CGFloat(arc4random_uniform(255))/255
        let b = CGFloat(arc4random_uniform(255))/255
        
        let color = UIColor.init(red: r, green: g, blue: b, alpha: 1.0)
        vc.view.backgroundColor = color
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        
        let rect = vc.view.frame
        var rectFrom = rect
        rectFrom.origin.x += rectFrom.width
        vc.view.frame = rectFrom
        
        UIView.animate(withDuration: 0.25) {
            vc.view.frame = rect
        }
    }
    
    @objc func didClickButton2(_ sender: UIButton) {
        self.request()
    }
    
    class Singleton {
        
        static let sharedInstance : Singleton = {
            let instance = Singleton(processPool: WKProcessPool())
            return instance
        }()
        
        var pp : WKProcessPool
        
        init( processPool : WKProcessPool) {
            pp = processPool
        }
    }
    
    func request() {
        lblLog.text = "로딩중.."
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        var arr = ["http://www.naver.com"]//, "http://www.naver.com", "http://www.daum.net", "http://apple.com"]
        let n = arc4random_uniform(UInt32(arr.count))
        wkWebView.load(URLRequest(url: URL(string: arr[Int(n)])!))
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.date = Date()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let n = Date().timeIntervalSince(self.date)
        lblLog.text = String(format: "%.02fs", n)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

