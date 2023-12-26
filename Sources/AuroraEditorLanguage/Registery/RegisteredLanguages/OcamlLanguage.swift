//
//  OcamlLanguageHandler.swift
//  
//
//  Created by Nanashi Li on 2023/12/12.
//

import tree_sitter
import AuroraEditorSupportedLanguages
import SwiftTreeSitter

/// `OcamlLanguageHandler` is a struct that implements `LanguageHandlerRegistry`.
/// Its primary role is to handle OCaml language specifics within the Tree-sitter parsing framework.
/// This includes registering OCaml in the `LanguageRegistry` and providing mechanisms
/// to retrieve the corresponding Tree-sitter language and queries.
public struct OcamlLanguageHandler: LanguageHandlerRegistery {

    /// A shared instance of `LanguageRegistry` for registering languages.
    var languageRegistery: LanguageRegistry = .shared

    /// A shared instance of `TreeSitterModel` used for obtaining Tree-sitter queries.
    private let treeSitterModel: TreeSitterModel = .shared

    public init() {}

    /// Retrieves the Tree-sitter language pointer for OCaml.
    /// - Returns: An `UnsafeMutablePointer` to `TSLanguage` for OCaml, if available.
    func getTreeSitterLanguage() -> UnsafeMutablePointer<TSLanguage>? {
        return tree_sitter_ocaml()
    }

    /// Registers the OCaml language with the `LanguageRegistry`.
    /// This method sets up the OCaml language configuration, including its identifier, Tree-sitter name, and file extensions.
    public func registerLanguage(){
        languageRegistery.register(language: .ocaml,
                                   handler: self,
                                   config: CodeLanguage(id: .ocaml,
                                                        tsName: "ocaml",
                                                        extensions: ["ml"]))
    }

    /// Retrieves a `Query` object for the OCaml language.
    /// This method uses `TreeSitterModel` to source the appropriate query for OCaml.
    /// - Parameter language: The `TreeSitterLanguage` enum value for OCaml.
    /// - Returns: An optional `Query` instance for OCaml if available; otherwise, `nil`.
    func queryFor(_ language: TreeSitterLanguage) -> Query? {
        treeSitterModel.queryFor(.ocaml)
    }
}
