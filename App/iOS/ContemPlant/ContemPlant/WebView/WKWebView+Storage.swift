//
//  WKWebView+SessionStorage.swift
//  ContemPlant
//
//  Created by Gero Embser on 16.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView {
    struct Storage {
        enum Kind {
            case session
            case local
        }
        
        private let relatedWebView: WKWebView
        let kind: Kind
        
        init(relatedTo webView: WKWebView, withStorageOf kind: Storage.Kind) {
            self.relatedWebView = webView
            self.kind = kind
        }
        
        private var jsName: String {
            switch kind {
            case .local:
                return "localStorage"
            case .session:
                return "sessionStorage"
            }
        }
        
        func get(itemForKey key: String, completion: @escaping (_ item: String?) -> Void) {
            //create the command string
            let command = "\(jsName).getItem(\"\(key)\")"
            
            //return the value out of the javascript via closure
            relatedWebView.evaluateJavaScript(command) { (result, error) in
                guard error == nil else {
                    completion(nil)
                    return
                }
                
                let returnValue = result as? String
                completion(returnValue)
            }
        }
        
        func get(itemsForKeys keys: [String], completion: @escaping (_ item: [String: String?]) -> Void ) {
            var resultDict: [String: String?] = [:]
            
            for (i, key) in keys.enumerated() {
                get(itemForKey: key) { (item) in
                    resultDict[key] = item
                    
                    if i == keys.count-1 {
                        //all items received
                        completion(resultDict)
                    }
                }
            }
        }
        
        func set(item: String, for key: String, completion: (() -> Void)?) {
            let command = "\(jsName).setItem(\"\(key)\",\"(value)\")"
            
            relatedWebView.evaluateJavaScript(command) { (_, _) in
                completion?() //just call the completion handler
            }
        }
    }
    
    var localStorage: Storage {
        return Storage(relatedTo: self, withStorageOf: .local)
    }
    var sessionStorage: Storage {
        return Storage(relatedTo: self, withStorageOf: .session)
    }
}
