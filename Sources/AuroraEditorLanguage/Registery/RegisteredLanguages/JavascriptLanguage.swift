//
//  JavascriptLanguageHandler.swift
//  
//
//  Created by Nanashi Li on 2023/12/12.
//

import tree_sitter
import AuroraEditorSupportedLanguages
import SwiftTreeSitter

/// `JavascriptLanguageHandler` is a struct adhering to `LanguageHandlerRegistry`.
/// It focuses on managing JavaScript language specifics in the context of Tree-sitter parsing.
/// The handler's responsibilities include registering JavaScript in the `LanguageRegistry`,
/// along with facilitating the retrieval of the Tree-sitter language and queries for JavaScript.
public struct JavascriptLanguageHandler: LanguageHandlerRegistery {

    /// A shared `LanguageRegistry` instance for language registration.
    var languageRegistery: LanguageRegistry = .shared

    /// A shared `TreeSitterModel` instance used for Tree-sitter queries retrieval.
    private let treeSitterModel: TreeSitterModel = .shared

    public init() {}

    /// Retrieves the Tree-sitter language pointer for JavaScript.
    /// - Returns: An `UnsafeMutablePointer` to `TSLanguage` specifically for JavaScript, if available.
    func getTreeSitterLanguage() -> UnsafeMutablePointer<TSLanguage>? {
        return tree_sitter_javascript()
    }

    /// Registers JavaScript with the `LanguageRegistry`.
    /// This method sets up the JavaScript language configuration, detailing its identifier, Tree-sitter name, file extensions, highlights, and additional identifiers related to environments like Node.js and Deno.
    public func registerLanguage(){
        languageRegistery.register(language: .javascript,
                                   handler: self,
                                   config: CodeLanguage(id: .javascript,
                                                        tsName: "javascript",
                                                        extensions: ["js", "cjs", "mjs"],
                                                        highlights: ["injections"],
                                                        additionalIdentifiers: ["node", "deno"]))
    }

    /// Retrieves a `Query` object for the JavaScript language.
    /// Utilizes `TreeSitterModel` to obtain the appropriate query for JavaScript.
    /// - Parameter language: The `TreeSitterLanguage` enum value for JavaScript.
    /// - Returns: An optional `Query` instance for JavaScript if available; otherwise, `nil`.
    func queryFor(_ language: TreeSitterLanguage) -> Query? {
        treeSitterModel.queryFor(.javascript)
    }
}
