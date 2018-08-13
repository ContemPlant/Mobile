//
//  JdenticonWebView.swift
//  ContemPlant
//
//  Created by Gero Embser on 20.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import Foundation
import UIKit
import WebKit


class JdenticonWebView: WKWebView {
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.isUserInteractionEnabled = false
    }
    
    func loadJdenticon(forValue value: String) {
        let path = Bundle.main.path(forResource: "jdenticon", ofType: "html")!
        var html = (try! NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)) as String

        html = html.replacingOccurrences(of: "<<<<<<<<<<<PLACEHOLDER>>>>>>>>>>>>", with: value)
        
        let baseUrl = URL(fileURLWithPath: Bundle.main.bundlePath, isDirectory: true)
        loadHTMLString(html as String, baseURL: baseUrl)
    }
}
