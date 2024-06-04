//
//  ViewController.swift
//  RichEditorViewSample
//
//  Created by Caesar Wirth on 4/5/15.
//  Copyright (c) 2015 Caesar Wirth. All rights reserved.
//

struct Users {
    var id: String
    var name: String
}

import UIKit

class ViewController: UIViewController {

    @IBOutlet var editorView: RichEditorView!
    @IBOutlet var htmlTextView: UITextView!
    @IBOutlet weak var mentionTableView: UITableView!
    
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        toolbar.backgroundColor = .clear
        toolbar.options = [RichEditorDefaultOption.bold, RichEditorDefaultOption.italic, RichEditorDefaultOption.strike, RichEditorDefaultOption.underline, RichEditorDefaultOption.link, RichEditorDefaultOption.orderedList, RichEditorDefaultOption.unorderedList]
        toolbar.tintColor = UIColor.white
        return toolbar
    }()
    
    var mentionUsers = [Users]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mentionTableView.alpha = 0
        editorView.delegate = self
        editorView.inputAccessoryView = toolbar
        editorView.placeholder = "Edit here"

        toolbar.delegate = self
        toolbar.editor = editorView
//        editorView.html = "<b>Jesus is God.</b> He saves by grace through faith alone. Soli Deo gloria! <a href='https://perfectGod.com'>perfectGod.com</a>"

        
        let item = RichEditorOptionItem(image: nil, title: "Clear", selectedImage: nil) { toolbar in
//            toolbar.editor?.html = ""
            self.editorView.editingEnabled = false
        }
        
        let mention = RichEditorOptionItem(image: nil, title: "@", selectedImage: nil) { toolbar in
            print("show mention list")
            self.mentionTableView.alpha = 1
        }

        var options = toolbar.options
        options.append(mention)
        options.append(item)
        toolbar.options = options
        
        addMentionUsers()
        setUpMentionTable()
    }
    
    func addMentionUsers() {
        mentionUsers.append(Users(id: "8237GD8H8RR98H879", name: "Ajith"))
        mentionUsers.append(Users(id: "3094FHJ2O4JF0JND3", name: "Khalid"))
        mentionUsers.append(Users(id: "O3IEHRFOIJF92JF2F", name: "Praveen"))
        mentionUsers.append(Users(id: "2I4UFI2J3ODIF24FO", name: "Ayyarappan"))
        mentionUsers.append(Users(id: "837GHFU23H49HF24F", name: "Karthikeyan"))
        mentionUsers.append(Users(id: "0JD092J4FJF24HF84", name: "Mohan"))
        mentionUsers.append(Users(id: "DJ2H4FH42IFH24HFF", name: "Gandhi"))
        mentionUsers.append(Users(id: "4FD872G4HF2HF9824", name: "Anand"))
        mentionUsers.append(Users(id: "139HF3I4UFBI324UH", name: "Pavithran"))
        mentionUsers.append(Users(id: "29O48HDF2H4HF84H9", name: "Chinthamani"))
    }
    
    func setUpMentionTable() {
        mentionTableView.register(UINib(nibName: "MentionTableCell", bundle: nil), forCellReuseIdentifier: "MentionTableCell")
        mentionTableView.dataSource = self
        mentionTableView.delegate = self
        
        DispatchQueue.main.async {
            self.mentionTableView.reloadData()
        }
    }
    
    // Function to add a button with specified text, value, background color, text color, and font
    /// Not in use
        func addButtonWithTextAndValue(buttonText: String, buttonValue: String, backgroundColor: String, textColor: String, font: String) {
            let addButtonScript = """
            var sel = window.getSelection();
            var range = sel.getRangeAt(0);
            var buttonNode = document.createElement('button');
            buttonNode.textContent = '\(buttonText)';
            buttonNode.value = '\(buttonValue)';
            buttonNode.style.backgroundColor = '\(backgroundColor)';
            buttonNode.style.color = '\(textColor)';
            buttonNode.style.font = '\(font)';
            buttonNode.setAttribute('onclick', "handleButtonClick('\(buttonValue)')");
            range.insertNode(buttonNode);
            
            // Insert a non-breaking space after the button
            var nbspNode = document.createTextNode('\\u00A0');
            buttonNode.parentNode.insertBefore(nbspNode, buttonNode.nextSibling);
            
            // Move the selection range to the end of the inserted non-breaking space
            range.setStartAfter(nbspNode);
            range.setEndAfter(nbspNode);
            sel.removeAllRanges();
            sel.addRange(range);
            """
            editorView.evaluateJavaScript(jsString: addButtonScript) { returnString in
                print("evaluateJavaScript returnString", returnString)
            }
        }
    
    // Function to add an anchor tag with specified href, title, and text content
    func addAnchorTagWithUserID(userID: String, userName: String, backgroundColor: String, textColor: String, fontSize: String, padding: String, cornerRadius: String) {
            let addAnchorScript = """
            var sel = window.getSelection();
            var range = sel.getRangeAt(0);
            var anchorNode = document.createElement('a');
            anchorNode.href = '\(userID)';
            anchorNode.title = '\(userName)';
            anchorNode.textContent = '\(userName)';
            anchorNode.style.backgroundColor = '\(backgroundColor)';
            anchorNode.style.color = '\(textColor)';
            anchorNode.style.fontSize = '\(fontSize)';
            anchorNode.style.padding = '\(padding)';
            anchorNode.style.borderRadius = '\(cornerRadius)';
            anchorNode.style.textDecoration = 'none'; // Remove underline
            range.insertNode(anchorNode);
            
            // Insert a non-breaking space after the anchor tag
            var nbspNode = document.createTextNode('\\u00A0');
            anchorNode.parentNode.insertBefore(nbspNode, anchorNode.nextSibling);
            
            // Move the selection range to the end of the inserted non-breaking space
            range.setStartAfter(nbspNode);
            range.setEndAfter(nbspNode);
            sel.removeAllRanges();
            sel.addRange(range);
            
            // Add event listener for keydown to handle backspace/delete
            document.addEventListener('keydown', function(event) {
                if (event.key === 'Backspace' || event.key === 'Delete') {
                    var selection = window.getSelection();
                    var range = selection.getRangeAt(0);
                    if (range.startContainer.nodeType === Node.TEXT_NODE && range.startContainer.parentNode === anchorNode) {
                        // Prevent the default backspace/delete action
                        event.preventDefault();
                        // Remove the anchor node
                        anchorNode.parentNode.removeChild(anchorNode);
                    }
                }
            }, false);
            """
            editorView.evaluateJavaScript(jsString: addAnchorScript) { returnString in
                print("evaluateJavaScript returnString", returnString)
            }
        }

    /// Not in use
    func addMentionWithUsername(username: String, userId: String, backgroundColor: String, textColor: String, padding: String) {
        let sanitizedUserId = abs(userId.hashValue)  // Ensure userId is a positive integer
        let mentionString = """
        var editor = document.getElementById('editor');
        if (editor) {
            var mention = document.createElement('input');
            mention.classList.add('mention');
            mention.type = 'button';
            mention.value = '\(username)';
            mention.setAttribute('data-id', '\(sanitizedUserId)');
            mention.style.backgroundColor = '\(backgroundColor)';  // Background color
            mention.style.color = '\(textColor)';            // Text color
            mention.style.padding = '\(padding)';         // Padding [(top & bottom), (left & right)]

            var nbsp = document.createTextNode('\\u00A0');
            editor.appendChild(mention);
            editor.appendChild(nbsp);
            var range = document.createRange();
            var sel = window.getSelection();
            range.setStartAfter(nbsp);
            range.collapse(true);
            sel.removeAllRanges();
            sel.addRange(range);
        } else {
            console.log('Editor not found');
        }
        """
        editorView.evaluateJavaScript(jsString:mentionString) { str in
            print("Mention added successfully")
        }
    }
    
    func showAlert(with title:String) {
        //Variable to store alertTextField
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add link", message: "Enter url link for \(title)", preferredStyle: .alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Example: https://www.google.com/"
            
            //Copy alertTextField in local variable to use in current block of code
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Update", style: .default) { action in
            //Prints the alertTextField's value
            print(textField.text!)
            if let linkText = textField.text {
                self.toolbar.editor?.insertLink(linkText, title: title)
            }
            alert.dismiss(animated: true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { action in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func getSelectedText(completion: @escaping (String?) -> Void) {
        let jsCode = "window.getSelection().toString();"
        editorView.evaluateJavaScript(jsString: jsCode) { text in
            print("getSelectedText", text)
            completion(text)
        }
    }
}

extension ViewController: RichEditorDelegate {

    func richEditor(_ editor: RichEditorView, heightDidChange height: Int) {
        print("content height changes:", height)
    }

    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        
        print("content: => ", content)
        
        if content.isEmpty {
            htmlTextView.text = "HTML Preview"
        } else {
            htmlTextView.text = content
        }
    }

    func richEditorTookFocus(_ editor: RichEditorView) { }
    
    func richEditorLostFocus(_ editor: RichEditorView) { }
    
    func richEditorDidLoad(_ editor: RichEditorView) { }
    
    func richEditor(_ editor: RichEditorView, shouldInteractWith url: URL) -> Bool {
        
        print("tapped url:", url)
        
        if url.isFileURL {
            print("isFileURL")
        } else {
            print("not isFileURL")
        }
        return false
    }

    func richEditor(_ editor: RichEditorView, handleCustomAction content: String) { 
        print("custom action content", content)
    }
    
}

extension ViewController: RichEditorToolbarDelegate {

    fileprivate func randomColor() -> UIColor {
        let colors = [
            UIColor.red,
            UIColor.orange,
            UIColor.yellow,
            UIColor.green,
            UIColor.blue,
            UIColor.purple
        ]

        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }

    func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextColor(color)
    }

    func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextBackgroundColor(color)
    }

    func richEditorToolbarInsertImage(_ toolbar: RichEditorToolbar) {
        toolbar.editor?.insertImage("https://gravatar.com/avatar/696cf5da599733261059de06c4d1fe22", alt: "Gravatar")
    }

    func richEditorToolbarInsertLink(_ toolbar: RichEditorToolbar) {
        getSelectedText {[weak self] selectedText in
            guard let self = self else {return}
            if let text = selectedText {
                if text.count > 0 {
                    self.showAlert(with: text)
                } else {
                    print("no selection found")
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentionUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MentionTableCell", for: indexPath) as! MentionTableCell
        cell.setData(data: mentionUsers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userName = mentionUsers[indexPath.row].name
        let userId = mentionUsers[indexPath.row].id
        
        mentionTableView.alpha = 0
                
        addAnchorTagWithUserID(userID: userId, userName: userName, backgroundColor: "#132D42", textColor: "#16B0F2", fontSize: "16px", padding: "1px 4px", cornerRadius: "2px")
        
        editorView.getHtml { str in
            print("getHtml str", str)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            print("Error converting HTML to attributed string: \(error.localizedDescription)")
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
