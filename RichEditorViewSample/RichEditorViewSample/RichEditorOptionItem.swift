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

    case clear
    case undo
    case redo
    case bold
    case italic
    case strike
    case underline
    case orderedList
    case unorderedList
    case link
    
    public static let all: [RichEditorDefaultOption] = [
        .clear,
        .undo, .redo, .bold, .italic,
        .strike, .underline,
        .orderedList, unorderedList, .link
    ]

    // MARK: RichEditorOption

    public var image: UIImage? {
        var name = ""
        switch self {
        case .clear: name = "clear"
        case .undo: name = "undo"
        case .redo: name = "redo"
        case .bold: name = "bold"
        case .italic: name = "italic"
        case .strike: name = "strike"
        case .underline: name = "underline"
        case .orderedList: name = "ordered_list"
        case .unorderedList: name = "unordered_list"
        case .link: name = "link"
        }
        
        let bundle = Bundle(for: RichEditorToolbar.self)
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
    
    public var selectedImage: UIImage? {
            var name = ""
            switch self {
            case .clear: name = "clear"
            case .undo: name = "undo"
            case .redo: name = "redo"
            case .bold: name = "boldSelected"
            case .italic: name = "italicSelected"
            case .strike: name = "strikeSelected"
            case .underline: name = "underlineSelected"
            case .orderedList: name = "ordered_list"
            case .unorderedList: name = "unordered_list"
            case .link: name = "linkSelected"
            }

            let bundle = Bundle(for: RichEditorToolbar.self)
            return UIImage(named: name, in: bundle, compatibleWith: nil)
        }
    
    public var title: String {
        switch self {
        case .clear: return NSLocalizedString("clear", comment: "")
        case .undo: return NSLocalizedString("undo", comment: "")
        case .redo: return NSLocalizedString("redo", comment: "")
        case .bold: return NSLocalizedString("bold", comment: "")
        case .italic: return NSLocalizedString("italic", comment: "")
        case .strike: return NSLocalizedString("strike", comment: "")
        case .underline: return NSLocalizedString("underline", comment: "")
        case .orderedList: return NSLocalizedString("orderedList", comment: "")
        case .unorderedList: return NSLocalizedString("unorderedList", comment: "")
        case .link: return NSLocalizedString("link", comment: "")
        }
    }
    
    public func action(_ toolbar: RichEditorToolbar) {
        switch self {
        case .clear: toolbar.editor?.removeFormat()
        case .undo: toolbar.editor?.undo()
        case .redo: toolbar.editor?.redo()
        case .bold: toolbar.editor?.bold()
        case .italic: toolbar.editor?.italic()
        case .strike: toolbar.editor?.strikethrough()
        case .underline: toolbar.editor?.underline()
        case .orderedList: toolbar.editor?.orderedList()
        case .unorderedList: toolbar.editor?.unorderedList()
        case .link: toolbar.delegate?.richEditorToolbarInsertLink?(toolbar)
        }
    }
}


/*
 
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
