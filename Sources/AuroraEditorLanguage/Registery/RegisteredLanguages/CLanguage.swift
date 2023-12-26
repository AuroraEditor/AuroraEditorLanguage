//
//  CLanguageHandler.swift
//
//
//  Created by Nanashi Li on 2023/12/12.
//

import tree_sitter
import AuroraEditorSupportedLanguages
import SwiftTreeSitter

/// `CLanguageHandler` is a struct that conforms to `LanguageHandlerRegistry`.
/// It is designed to manage C language specifics within the Tree-sitter parsing framework.
/// This includes registering the C language in the `LanguageRegistry`,
/// and providing the functionality to retrieve the Tree-sitter language and queries for C.
public struct CLanguageHandler: LanguageHandlerRegistery {

    /// A shared instance of `LanguageRegistry` for the purpose of registering languages.
    var languageRegistery: LanguageRegistry = .shared

    /// A shared instance of `TreeSitterModel` used for accessing Tree-sitter queries.
    private let treeSitterModel: TreeSitterModel = .shared

    public init() {}

    /// Retrieves the Tree-sitter language pointer for C.
    /// - Returns: An `UnsafeMutablePointer` to `TSLanguage` specifically for C, if available.
    func getTreeSitterLanguage() -> UnsafeMutablePointer<TSLanguage>? {
        return tree_sitter_c()
    }

    /// Registers the C language with the `LanguageRegistry`.
    /// This method sets up the C language configuration, which includes its identifier, Tree-sitter name, and file extensions.
    public func registerLanguage(){
        languageRegistery.register(language: .c,
                                   handler: self,
                                   config: getLanguage())
    }

    /// Retrieves the language configuration for C.
    /// - Returns: A `CodeLanguage` instance configured for C.
    func getLanguage() -> CodeLanguage {
        CodeLanguage(id: .c,
                     tsName: "c",
                     extensions: ["c", "h"])
    }

    /// Retrieves a `Query` object for the C language.
    /// Utilizes `TreeSitterModel` to source the appropriate query for C.
    /// - Parameter language: The `TreeSitterLanguage` enum value for C.
    /// - Returns: An optional `Query` instance for C if available; otherwise, `nil`.
    func queryFor(_ language: TreeSitterLanguage) -> Query? {
        treeSitterModel.queryFor(.c)
    }
}
