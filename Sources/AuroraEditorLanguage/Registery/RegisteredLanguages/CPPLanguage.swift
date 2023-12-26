//
//  CPPLanguageHandler.swift
//
//
//  Created by Nanashi Li on 2023/12/12.
//

import tree_sitter
import AuroraEditorSupportedLanguages
import SwiftTreeSitter

/// `CPPLanguageHandler` is a struct that adheres to `LanguageHandlerRegistry`.
/// It is designed to manage C++ language specifics within the Tree-sitter parsing framework.
/// This includes registering C++ in the `LanguageRegistry`,
/// and facilitating the retrieval of Tree-sitter language and queries for C++.
public struct CPPLanguageHandler: LanguageHandlerRegistery {

    /// A shared instance of `LanguageRegistry` used for registering languages.
    var languageRegistery: LanguageRegistry = .shared

    /// A shared instance of `TreeSitterModel` for retrieving Tree-sitter queries.
    private let treeSitterModel: TreeSitterModel = .shared

    public init() {}

    /// Retrieves the Tree-sitter language pointer for C++.
    /// - Returns: An `UnsafeMutablePointer` to `TSLanguage` specifically for C++, if available.
    func getTreeSitterLanguage() -> UnsafeMutablePointer<TSLanguage>? {
        return tree_sitter_cpp()
    }

    /// Registers C++ with the `LanguageRegistry`.
    /// This method sets up the C++ language configuration, including its identifier, Tree-sitter name, file extensions, parent language URL, and highlights.
    public func registerLanguage(){
        languageRegistery.register(language: .cpp,
                                   handler: self,
                                   config: CodeLanguage(id: .cpp,
                                                        tsName: "cpp",
                                                        extensions: ["cc", "cpp", "c++", "hpp", "h"],
                                                        parentURL: CLanguageHandler().getLanguage().queryURL(),
                                                        highlights: ["injections"]))
    }

    /// Retrieves a `Query` object for the C++ language.
    /// Utilizes `TreeSitterModel` to source the appropriate query for C++.
    /// - Parameter language: The `TreeSitterLanguage` enum value for C++.
    /// - Returns: An optional `Query` instance for C++ if available; otherwise, `nil`.
    func queryFor(_ language: TreeSitterLanguage) -> Query? {
        treeSitterModel.queryFor(.cpp)
    }
}
