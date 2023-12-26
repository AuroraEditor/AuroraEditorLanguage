//
//  PlainTextLanguageHandler.swift
//  
//
//  Created by Nanashi Li on 2023/12/13.
//

import tree_sitter
import AuroraEditorSupportedLanguages
import SwiftTreeSitter

/// `PlainTextLanguageHandler` is a struct that conforms to `LanguageHandlerRegistry`.
/// It manages Plain Text language specifics within the context of Tree-sitter parsing.
/// Key responsibilities include registering the Plain Text language in the `LanguageRegistry`
/// and providing methods to retrieve the corresponding Tree-sitter language and queries.
public struct PlainTextLanguageHandler: LanguageHandlerRegistery {
    
    /// A shared instance of `LanguageRegistry` used for registering languages.
    var languageRegistery: LanguageRegistry = .shared

    /// A shared instance of `TreeSitterModel` used to retrieve Tree-sitter queries.
    private let treeSitterModel: TreeSitterModel = .shared

    public init() {}

    /// Retrieves the Tree-sitter language pointer for Plain Text.
    /// - Returns: An `UnsafeMutablePointer` to `TSLanguage` specifically for Plain Text, if available.
    /// In the case of Plain Text, this method returns `nil` as there is no dedicated Tree-sitter language.
    func getTreeSitterLanguage() -> UnsafeMutablePointer<TSLanguage>? {
        return nil
    }

    /// Registers the Plain Text language with the `LanguageRegistry`.
    /// This method configures Plain Text language specifics, such as its identifier and file extensions.
    public func registerLanguage(){
        languageRegistery.register(language: .plainText,
                                    handler: self,
                                    config: getLanguage())
    }

    /// Retrieves the language configuration for Plain Text.
    /// - Returns: A `CodeLanguage` instance configured for Plain Text.
    public func getLanguage() -> CodeLanguage {
        CodeLanguage(id: .plainText,
                     tsName: "PlainText",
                     extensions: ["txt"])
    }

    /// Retrieves a `Query` object for the Plain Text language.
    /// This method utilizes `TreeSitterModel` to fetch the appropriate query for Plain Text.
    /// - Parameter language: The `TreeSitterLanguage` enum value for Plain Text.
    /// - Returns: An optional `Query` instance if available for Plain Text; otherwise, `nil`.
    func queryFor(_ language: TreeSitterLanguage) -> Query? {
        treeSitterModel.queryFor(.plainText)
    }
}
