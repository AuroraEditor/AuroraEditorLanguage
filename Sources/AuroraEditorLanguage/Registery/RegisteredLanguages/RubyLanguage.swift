//
//  RubyLanguageHandler.swift
//
//
//  Created by Nanashi Li on 2023/12/12.
//

import tree_sitter
import AuroraEditorSupportedLanguages
import SwiftTreeSitter

/// `RubyLanguageHandler` is a struct that conforms to `LanguageHandlerRegistry`.
/// It is responsible for managing Ruby language specifics in the context of Tree-sitter parsing.
/// This includes registering the Ruby language in the `LanguageRegistry` and providing
/// functionality to retrieve the corresponding Tree-sitter language and queries.
public struct RubyLanguageHandler: LanguageHandlerRegistery {

    /// A shared instance of `LanguageRegistry` used for registering languages.
    var languageRegistery: LanguageRegistry = .shared

    /// A shared instance of `TreeSitterModel` used to retrieve Tree-sitter queries.
    private let treeSitterModel: TreeSitterModel = .shared

    public init() {}

    /// Retrieves the Tree-sitter language pointer for Ruby.
    /// - Returns: An `UnsafeMutablePointer` to `TSLanguage` specifically for Ruby, if available.
    func getTreeSitterLanguage() -> UnsafeMutablePointer<TSLanguage>? {
        return tree_sitter_ruby()
    }

    /// Registers the Ruby language with the `LanguageRegistry`.
    /// This method configures the Ruby language specifics, such as its identifier, Tree-sitter name, and file extensions.
    public func registerLanguage(){
        languageRegistery.register(language: .ruby,
                                    handler: self,
                                    config: CodeLanguage(id: .ruby,
                                                         tsName: "ruby",
                                                         extensions: ["rb"]))
    }

    /// Retrieves a `Query` object for the Ruby language.
    /// This method utilizes `TreeSitterModel` to fetch the appropriate query for Ruby.
    /// - Parameter language: The `TreeSitterLanguage` enum value for Ruby.
    /// - Returns: An optional `Query` instance if available for Ruby; otherwise, `nil`.
    func queryFor(_ language: TreeSitterLanguage) -> Query? {
        treeSitterModel.queryFor(.ruby)
    }
}
