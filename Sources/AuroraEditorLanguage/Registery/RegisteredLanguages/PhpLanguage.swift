//
//  PhpLanguageHandler.swift
//  
//
//  Created by Nanashi Li on 2023/12/12.
//

import tree_sitter
import AuroraEditorSupportedLanguages
import SwiftTreeSitter

/// `PhpLanguageHandler` is a struct conforming to `LanguageHandlerRegistry`.
/// It is dedicated to managing PHP language specifics within the context of Tree-sitter parsing.
/// This includes the registration of the PHP language in the `LanguageRegistry`,
/// and providing the necessary functionality to retrieve the corresponding Tree-sitter language and queries.
public struct PhpLanguageHandler: LanguageHandlerRegistery {

    /// A shared instance of `LanguageRegistry` used for the registration of languages.
    var languageRegistery: LanguageRegistry = .shared

    /// A shared instance of `TreeSitterModel` utilized for retrieving Tree-sitter queries.
    private let treeSitterModel: TreeSitterModel = .shared

    public init() {}

    /// Retrieves the Tree-sitter language pointer for PHP.
    /// - Returns: An `UnsafeMutablePointer` to `TSLanguage` specifically for PHP, if available.
    func getTreeSitterLanguage() -> UnsafeMutablePointer<TSLanguage>? {
        return tree_sitter_php()
    }

    /// Registers the PHP language with the `LanguageRegistry`.
    /// This method configures PHP language specifics, including its identifier, Tree-sitter name, file extensions, and syntax highlights.
    public func registerLanguage(){
        languageRegistery.register(language: .php,
                                   handler: self,
                                   config: CodeLanguage(id: .php,
                                                        tsName: "php",
                                                        extensions: ["php"],
                                                        highlights: ["injections"]))
    }

    /// Retrieves a `Query` object for the PHP language.
    /// This method employs `TreeSitterModel` to obtain the appropriate query for PHP.
    /// - Parameter language: The `TreeSitterLanguage` enum value for PHP.
    /// - Returns: An optional `Query` instance if available for PHP; otherwise, `nil`.
    func queryFor(_ language: TreeSitterLanguage) -> Query? {
        treeSitterModel.queryFor(.php)
    }
}
