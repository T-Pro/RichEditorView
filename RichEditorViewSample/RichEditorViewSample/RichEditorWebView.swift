//
//  RichEditorWebView.swift
//  RichEditorView
//
//  Created by C. Bess on 9/18/19.
//

import WebKit

public class RichEditorWebView: WKWebView, WKScriptMessageHandler {
    
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
            if let body = message.body as? [String: String],
               let userID = body["userID"],
               let userName = body["userName"] {
                print("Anchor clicked with userID: \(userID), userName: \(userName)")
                // Handle the click action here
            }
        }
    }

}
