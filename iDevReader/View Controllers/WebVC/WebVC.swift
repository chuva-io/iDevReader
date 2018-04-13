//
//  WebVC.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 3/27/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController {
    
    let url: URL
    
    @IBOutlet fileprivate weak var webView: WKWebView!
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest(url: url))
    }
    
}
