//
//  SampleTableCell.swift
//  RichEditorViewSample
//
//  Created by Ayyarappan K on 04/06/24.
//  Copyright © 2024 Caesar Wirth. All rights reserved.
//

import UIKit
import WebKit

class SampleTableCell: UITableViewCell {
    
    @IBOutlet weak var textVieww: UITextView!
 
    @IBOutlet weak var editorView: RichEditorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData() {
        
        let html = "<b>Thanks</b><br><i style=“font-weight: bold;“>Good work</i><br><strike style=“font-weight: bold; font-style: italic;“>Hello</strike><br><u style=“font-weight: bold; font-style: italic;“>Thanks</u><br><br>Okay<br>Fine now<br><br><a href=“837GHFU23H49HF24F” title=“Karthikeyan” style=“background-color: rgb(19, 45, 66); color: rgb(22, 176, 242); font-size: 14px; padding: 1px 2px; border-top-left-radius: 2px; border-top-right-radius: 2px; border-bottom-right-radius: 2px; border-bottom-left-radius: 2px; text-decoration: none;“>Karthikeyan</a>&nbsp;Good<br><br>"
        
       

        let attributedText = try? NSAttributedString(
            data: html.data(using: .utf8)!,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        )
        
        // Create a mutable attributed string to apply the desired formatting
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText!)
        
        // Set the text color to white
        mutableAttributedText.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: mutableAttributedText.length))
        
        // Set the font to Avenir Next Normal 15
        mutableAttributedText.addAttribute(.font, value: UIFont(name: "AvenirNext-Regular", size: 15)!, range: NSRange(location: 0, length: mutableAttributedText.length))
        
        // Set the attributed text to the UITextView
        textVieww.attributedText = mutableAttributedText
        textVieww.alpha = 0
        
        editorView.html = html
        editorView.editingEnabled = false
        editorView.delegate = self
        
    }

}


extension SampleTableCell: RichEditorDelegate {
    
    func richEditor(_ editor: RichEditorView, shouldInteractWith url: URL) -> Bool {
        print("tapped url:", url)
        
        if url.isFileURL {
            print("isFileURL")
        } else {
            print("not isFileURL")
        }
        return false
    }
}
