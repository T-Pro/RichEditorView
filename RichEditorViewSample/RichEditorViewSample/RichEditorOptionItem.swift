//
//  RichEditorOptionItem.swift
//
//  Created by Caesar Wirth on 4/2/15.
//  Copyright (c) 2015 Caesar Wirth. All rights reserved.
//

import UIKit

/// A RichEditorOption object is an object that can be displayed in a RichEditorToolbar.
/// This protocol is proviced to allow for custom actions not provided in the RichEditorOptions enum.
public protocol RichEditorOption {

    /// The image to be displayed in the RichEditorToolbar.
    var image: UIImage? { get }

    /// The title of the item.
    /// If `image` is nil, this will be used for display in the RichEditorToolbar.
    var title: String { get }
    
    var selectedImage: UIImage? { get }

    /// The action to be evoked when the action is tapped
    /// - parameter editor: The RichEditorToolbar that the RichEditorOption was being displayed in when tapped.
    ///                     Contains a reference to the `editor` RichEditorView to perform actions on.
    func action(_ editor: RichEditorToolbar)
}

/// RichEditorOptionItem is a concrete implementation of RichEditorOption.
/// It can be used as a configuration object for custom objects to be shown on a RichEditorToolbar.
public struct RichEditorOptionItem: RichEditorOption {
   
    public var selectedImage: UIImage?
    
    /// The image that should be shown when displayed in the RichEditorToolbar.
    public var image: UIImage?

    /// If an `itemImage` is not specified, this is used in display
    public var title: String

    /// The action to be performed when tapped
    public var handler: ((RichEditorToolbar) -> Void)

    public init(image: UIImage?, title: String, selectedImage: UIImage?, action: @escaping ((RichEditorToolbar) -> Void)) {
        self.image = image
        self.title = title
        self.selectedImage = selectedImage
        self.handler = action
    }
    
    // MARK: RichEditorOption
    
    public func action(_ toolbar: RichEditorToolbar) {
        handler(toolbar)
    }
}

/// RichEditorOptions is an enum of standard editor actions
public enum RichEditorDefaultOption: RichEditorOption {

    
    case bold
    case underline
    case italic
    case strike
    case link
    case alignLeft
    case alignCenter
    case alignRight
    case block
    case orderedList
    case unorderedList
    
    
    public static let all: [RichEditorDefaultOption] = [
//        .clear,
        .bold, .italic,
        .strike, .underline,
        .orderedList, unorderedList, .link,
        .alignLeft, .alignCenter, .alignRight, .block
    ]

    // MARK: RichEditorOption

    public var image: UIImage? {
        var name = ""
        switch self {
        case .bold: name = "Bold"
        case .italic: name = "Italic"
        case .strike: name = "Strike"
        case .underline: name = "Underline"
        case .orderedList: name = "Numbers"
        case .unorderedList: name = "Bullets"
        case .link: name = "Link"
        case .alignLeft: name = "AlignLeft"
        case .alignCenter: name = "AlignCenter"
        case .alignRight: name = "AlignRight"
        case .block: name = "Block"
        }
        
        return UIImage(named: name)
        
//        let bundle = Bundle(for: RichEditorToolbar.self)
//        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
    
    public var selectedImage: UIImage? {
            var name = ""
            switch self {
            case .bold: name = "BoldS"
            case .italic: name = "ItalicS"
            case .strike: name = "StrikeS"
            case .underline: name = "UnderlineS"
            case .orderedList: name = "NumbersS"
            case .unorderedList: name = "BulletsS"
            case .link: name = "Link"
            case .alignLeft: name = "AlignLeft"
            case .alignCenter: name = "AlignCenter"
            case .alignRight: name = "AlignRight"
            case .block: name = "BlockS"
            }
        
        return UIImage(named: name)

//            let bundle = Bundle(for: RichEditorToolbar.self)
//            return UIImage(named: name, in: bundle, compatibleWith: nil)
        }
    
    public var title: String {
        switch self {
        case .bold: return NSLocalizedString("bold", comment: "")
        case .italic: return NSLocalizedString("italic", comment: "")
        case .strike: return NSLocalizedString("strike", comment: "")
        case .underline: return NSLocalizedString("underline", comment: "")
        case .orderedList: return NSLocalizedString("orderedList", comment: "")
        case .unorderedList: return NSLocalizedString("unorderedList", comment: "")
        case .link: return NSLocalizedString("link", comment: "")
        case .alignLeft: return NSLocalizedString("alignLeft", comment: "")
        case .alignCenter: return NSLocalizedString("alignCenter", comment: "")
        case .alignRight: return NSLocalizedString("alignRight", comment: "")
        case .block: return NSLocalizedString("block", comment: "")
        }
    }
    
    public func action(_ toolbar: RichEditorToolbar) {
        switch self {
//        case .clear: toolbar.editor?.removeFormat()
//        case .undo: toolbar.editor?.undo()
//        case .redo: toolbar.editor?.redo()
        case .bold: toolbar.editor?.bold()
        case .italic: toolbar.editor?.italic()
        case .strike: toolbar.editor?.strikethrough()
        case .underline: toolbar.editor?.underline()
        case .orderedList: toolbar.editor?.orderedList()
        case .unorderedList: toolbar.editor?.unorderedList()
        case .link: toolbar.delegate?.richEditorToolbarInsertLink?(toolbar)
        case .alignLeft:
            toolbar.editor?.alignLeft()
        case .alignCenter:
            toolbar.editor?.alignCenter()
        case .alignRight:
            toolbar.editor?.alignRight()
        case .block:
            toolbar.editor?.blockquote(backgroundColor: "#1A1C20", textColor: "#FF8934")
        }
    }
}


/*
 case clear
 case undo
 case redo
 case `subscript`
 case superscript
 case textColor
 case textBackgroundColor
 case header(Int)
 case indent
 case outdent
 case block
 case alignLeft
 case alignCenter
 case alignRight
 case image
 
 */
