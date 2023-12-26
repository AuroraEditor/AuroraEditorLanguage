//
//  BashLanguageHandler.swift
//
//
//  Created by Nanashi Li on 2023/12/12.
//

import tree_sitter
import AuroraEditorSupportedLanguages
import SwiftTreeSitter

/// `BashLanguageHandler` is a struct that adheres to `LanguageHandlerRegistry`.
/// It is tailored for managing Bash scripting language specifics within the Tree-sitter parsing framework.
/// The handler's primary duties include registering Bash in the `LanguageRegistry`,
/// and facilitating the retrieval of Tree-sitter language and queries for Bash.
public struct BashLanguageHandler: LanguageHandlerRegistery {

    /// A shared instance of `LanguageRegistry` used for language registration.
    var languageRegistery: LanguageRegistry = .shared

    /// A shared instance of `TreeSitterModel` for retrieving Tree-sitter queries.
    private let treeSitterModel: TreeSitterModel = .shared

    public init() {}

    /// Retrieves the Tree-sitter language pointer for Bash.
    /// - Returns: An `UnsafeMutablePointer` to `TSLanguage` specifically for Bash, if available.
    func getTreeSitterLanguage() -> UnsafeMutablePointer<TSLanguage>? {
        return tree_sitter_bash()
    }

    /// Registers Bash with the `LanguageRegistry`.
    /// This method sets up the Bash language configuration, including its identifier, Tree-sitter name, and file extensions.
    public func registerLanguage(){
        languageRegistery.register(language: .bash,
                                   handler: self,
                                   config: CodeLanguage(id: .bash,
                                                        tsName: "bash",
                                                        extensions: ["sh", "bash"]))
    }

    /// Retrieves a `Query` object for the Bash language.
    /// Utilizes `TreeSitterModel` to source the appropriate query for Bash.
    /// - Parameter language: The `TreeSitterLanguage` enum value for Bash.
    /// - Returns: An optional `Query` instance for Bash if available; otherwise, `nil`.
    func queryFor(_ language: TreeSitterLanguage) -> Query? {
        treeSitterModel.queryFor(.bash)
    }
}
