//
//  LanguageHandler.swift
//
//
//  Created by Nanashi Li on 2023/12/12.
//

import tree_sitter
import SwiftTreeSitter

/// A protocol defining the requirements for registering and accessing Tree Sitter language configurations.
///
/// Conforming to `LanguageHandlerRegistry` enables a type to handle specific language configurations
/// for Tree Sitter, a parser generator tool and an incremental parsing library.
protocol LanguageHandlerRegistery {

    /// A registry for storing and retrieving language configurations.
    ///
    /// This property holds the `LanguageRegistry` instance used to register and access language configurations.
    var languageRegistery: LanguageRegistry { get set }

    /// Retrieves the Tree Sitter language configuration for the conforming handler.
    ///
    /// This method is responsible for providing access to the Tree Sitter language configuration.
    /// It returns a pointer to a `TSLanguage` object, which is the core representation of a language in Tree Sitter.
    /// - Returns: An optional `UnsafeMutablePointer<TSLanguage>` pointing to the Tree Sitter language configuration.
    ///            Returns `nil` if the language configuration is not registered or available.
    func getTreeSitterLanguage() -> UnsafeMutablePointer<TSLanguage>?

    /// Registers a new Tree Sitter language configuration.
    ///
    /// This method is used to add a new language configuration to the language registry.
    /// By registering, the language becomes available for Tree Sitter language handling operations,
    /// such as parsing or syntax highlighting.
    ///
    /// - Parameter config: A `CodeLanguage` instance representing the configuration of the language to be registered.
    func registerLanguage()

    /// Retrieves a query configuration for a specific language.
    ///
    /// This method is used to fetch a `Query` object corresponding to a given Tree Sitter language.
    /// A `Query` is used in Tree Sitter to specify patterns to search for in the syntax tree.
    ///
    /// - Parameter language: A `TreeSitterLanguage` enum value representing the specific language for which the query is requested.
    /// - Returns: An optional `Query` instance corresponding to the language. Returns `nil` if the query is not available or not defined.
    func queryFor(_ language: TreeSitterLanguage) -> Query?
}
