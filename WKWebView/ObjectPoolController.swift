//
//  SecondViewController.swift
//  WKWebView
//
//  Created by Manav Prakash on 06/10/21.
//

import UIKit
import WebKit
class ObjectPoolController: UIViewController {
  var wkWebView: WKWebView!
  var loadHTMLStart: CFTimeInterval = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    wkWebView = ObjectPool.shared.dequeue()
    wkWebView.navigationDelegate = self
    wkWebView.uiDelegate = self
    wkWebView.scrollView.isScrollEnabled = false
    
    wkWebView.frame = view.bounds
    wkWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(wkWebView)
    loadHTMLStart = CACurrentMediaTime()
    wkWebView.load(URLRequest(url: URL(string: "https://www.1mg.com/online-doctor-consultation?source=Android&city=Faridabad")!))
    // Do any additional setup after loading the view.
  }
  
  
  
}

extension ObjectPoolController: WKNavigationDelegate, WKUIDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    updateResult()
  }
  
  private func updateResult() {
    let delta = CACurrentMediaTime() - loadHTMLStart
    print(delta)
    loadHTMLStart = CACurrentMediaTime()
  }
}


