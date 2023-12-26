//
//  GoLanguageHandler.swift
//  
//
//  Created by Nanashi Li on 2023/12/12.
//

import tree_sitter
import AuroraEditorSupportedLanguages
import SwiftTreeSitter

/// `GoLanguageHandler` is a struct conforming to `LanguageHandlerRegistry`.
/// It is tasked with managing Go language specifics within the Tree-sitter parsing system.
/// The handler's primary functions include registering Go in the `LanguageRegistry`
/// and providing methods to retrieve the Tree-sitter language and queries for Go.
public struct GoLanguageHandler: LanguageHandlerRegistery {

    /// A shared instance of `LanguageRegistry` used for the purpose of registering languages.
    var languageRegistery: LanguageRegistry = .shared

    /// A shared instance of `TreeSitterModel` for accessing Tree-sitter queries.
    private let treeSitterModel: TreeSitterModel = .shared

    public init() {}

    /// Retrieves the Tree-sitter language pointer for Go.
    /// - Returns: An `UnsafeMutablePointer` to `TSLanguage` specifically for Go, if available.
    func getTreeSitterLanguage() -> UnsafeMutablePointer<TSLanguage>? {
        return tree_sitter_go()
    }

    /// Registers Go with the `LanguageRegistry`.
    /// This method configures the Go language specifics, including its identifier, Tree-sitter name, and file extensions.
    public func registerLanguage(){
        languageRegistery.register(language: .go,
                                   handler: self,
                                   config: CodeLanguage(id: .go,
                                                        tsName: "go",
                                                        extensions: ["go"]))
    }

    /// Retrieves a `Query` object for the Go language.
    /// This method utilizes `TreeSitterModel` to source the appropriate query for Go.
    /// - Parameter language: The `TreeSitterLanguage` enum value for Go.
    /// - Returns: An optional `Query` instance for Go if available; otherwise, `nil`.
    func queryFor(_ language: TreeSitterLanguage) -> Query? {
        treeSitterModel.queryFor(.go)
    }
}
