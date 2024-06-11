//
//  RichEditorWebView.swift
//  RichEditorView
//
//  Created by C. Bess on 9/18/19.
//

import UIKit
import WebKit

protocol RichEditorWebViewDelegate: AnyObject {
    func richEditorWebView(_ webView: RichEditorWebView, didReceiveButtonValue buttonValue: String)
}

public class RichEditorWebView: WKWebView, WKScriptMessageHandler {
    
    var richEditorDelegate: RichEditorWebViewDelegate?
    public var accessoryView: UIView?
    
    public override var inputAccessoryView: UIView? {
        return accessoryView
    }
    
    public init() {
        
        let contentController = WKUserContentController()
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        super.init(frame: .zero, configuration: config)
        
        contentController.add(self, name: "anchorClickHandler")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "anchorClickHandler" {
            if let buttonValue = message.body as? String {
//                print("Button clicked with value: \(buttonValue)")
                richEditorDelegate?.richEditorWebView(self, didReceiveButtonValue: buttonValue)
            }
        }
    }

}
