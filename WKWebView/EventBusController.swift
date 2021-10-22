//
//  FirstViewController.swift
//  WKWebView
//
//  Created by Manav Prakash on 06/10/21.
//

import UIKit
import WebKit
class EventBusController: UIViewController {
  var wkWebView: WKWebView!
  var loadHTMLStart: CFTimeInterval = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let contentController = WKUserContentController()
    contentController.add(self, name: "navigationCloseWebView")
    contentController.add(self, name: "dataLayerPostMessage")
    contentController.add(self, name: "clipboard")
    
    let config            = WKWebViewConfiguration()
    config.userContentController = contentController
    wkWebView = WKWebView(frame: .zero, configuration: config)
    wkWebView.navigationDelegate = self
    wkWebView.scrollView.isScrollEnabled = false
    
    wkWebView.frame = view.bounds
    wkWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(wkWebView)
    loadHTMLStart = CACurrentMediaTime()
    wkWebView.load(URLRequest(url: URL(string: "https://7b7sj.csb.app/")!))
    // Do any additional setup after loading the view.
  }
  
  
  
}

extension EventBusController: WKNavigationDelegate, WKScriptMessageHandler {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    updateResult()
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
      self.evaluateJavaScript()
      
    }
  }
  
  private func updateResult() {
    let delta = CACurrentMediaTime() - loadHTMLStart
    print(delta)
    loadHTMLStart = CACurrentMediaTime()
  }
  
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    print(message)
    print(message.name)
    print(message.body)
  }
  
  func evaluateJavaScript() {
    let js =  "window.webkit.messageHandlers.dataLayerOnMessage.showToastMessage()"
    print("js : \(js)")
    
    wkWebView.evaluateJavaScript(js) { (result, error) in
      
      print("evaluateJavaScript result :: \(String(describing: result))")
      print("evaluateJavaScript error :: \(String(describing: error))")
      
    }
    
  }
}
