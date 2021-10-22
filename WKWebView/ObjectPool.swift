//
//  Test.swift
//  WKWebView
//
//  Created by Manav Prakash on 06/10/21.
//

import Foundation
import WebKit
import UIKit

public protocol ObjectPoolProtocol {
  func initialize()
}

public class ObjectPool<Object: ObjectPoolProtocol> {
  
  private let creationClosure: () -> Object
  private var initializedObjects: [Object] = []
  public var numberOfInitializedObjects: Int = 5 {
    didSet {
      prepare()
    }
  }
  
  public init(creationClosure: @escaping () -> Object) {
    self.creationClosure = creationClosure
    prepare()
  }
  
  public func prepare() {
    while initializedObjects.count < numberOfInitializedObjects {
      let object = creationClosure()
      object.initialize()
      initializedObjects.append(object)
    }
  }
  
  private func createObject() -> Object {
    let object = creationClosure()
    object.initialize()
    return object
  }
  
  public func dequeue() -> Object {
    let initializedObject: Object
    if let object = initializedObjects.first {
      initializedObjects.removeFirst()
      initializedObject = object
    } else {
      initializedObject = createObject()
    }
    prepare()
    return initializedObject
  }
  
}

extension WKWebView: ObjectPoolProtocol {
  public func initialize() {
    loadHTMLString("", baseURL: nil)
  }
}

public extension ObjectPool where Object == WKWebView {
  
  static let shared = ObjectPool(creationClosure: {
    WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
  })
}
