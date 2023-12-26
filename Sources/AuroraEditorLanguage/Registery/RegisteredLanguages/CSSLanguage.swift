//
//  CSSLanguageHandler.swift
//  
//
//  Created by Nanashi Li on 2023/12/12.
//

import tree_sitter
import AuroraEditorSupportedLanguages
import SwiftTreeSitter

/// `CSSLanguageHandler` is a struct that implements `LanguageHandlerRegistry`.
/// It is specifically designed to handle CSS language aspects within the Tree-sitter parsing framework.
/// The handler's main responsibilities include registering CSS in the `LanguageRegistry`,
/// and providing mechanisms for retrieving the Tree-sitter language and queries pertinent to CSS.
public struct CSSLanguageHandler: LanguageHandlerRegistery {

    /// A shared instance of `LanguageRegistry` for the registration of languages.
    var languageRegistery: LanguageRegistry = .shared

    /// A shared instance of `TreeSitterModel` used for retrieving Tree-sitter queries.
    private let treeSitterModel: TreeSitterModel = .shared

    public init() {}

    /// Retrieves the Tree-sitter language pointer for CSS.
    /// - Returns: An `UnsafeMutablePointer` to `TSLanguage` specifically for CSS, if available.
    func getTreeSitterLanguage() -> UnsafeMutablePointer<TSLanguage>? {
        return tree_sitter_css()
    }

    /// Registers CSS with the `LanguageRegistry`.
    /// This method sets up the CSS language configuration, including its identifier, Tree-sitter name, and file extensions.
    public func registerLanguage(){
        languageRegistery.register(language: .css,
                                   handler: self,
                                   config: CodeLanguage(id: .css,
                                                        tsName: "css",
                                                        extensions: ["css"]))
    }

    /// Retrieves a `Query` object for the CSS language.
    /// Utilizes `TreeSitterModel` to obtain the suitable query for CSS.
    /// - Parameter language: The `TreeSitterLanguage` enum value for CSS.
    /// - Returns: An optional `Query` instance for CSS if available; otherwise, `nil`.
    func queryFor(_ language: TreeSitterLanguage) -> Query? {
        treeSitterModel.queryFor(.css)
    }
}
