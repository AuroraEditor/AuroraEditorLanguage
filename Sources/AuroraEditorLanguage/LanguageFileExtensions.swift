//
//  LanguageFileExtensions.swift
//  
//
//  Created by Nanashi Li on 2023/12/13.
//

import Foundation

/// Extension to `CodeLanguage` providing additional functionalities and utilities.
/// This includes methods for creating `CodeLanguage` instances and accessing all registered languages.
public extension CodeLanguage {

    /// A shared instance of `LanguageRegistry`.
    /// This property provides access to the central registry of supported programming languages.
    static let languageRegistery: LanguageRegistry = .shared

    /// Creates a new instance of `CodeLanguage`.
    /// This factory method initializes `CodeLanguage` with specified parameters.
    /// - Parameters:
    ///   - id: The `TreeSitterLanguage` identifier for the language.
    ///   - tsName: The Tree-sitter name for the language.
    ///   - extensions: A set of file extensions associated with the language.
    ///   - highlights: An optional set of strings representing language highlights. Defaults to `nil`.
    ///   - additionalIdentifiers: A set of additional identifiers for the language. Defaults to an empty set.
    ///   - parentURL: An optional URL for the parent language query file. Defaults to `nil`.
    /// - Returns: A `CodeLanguage` instance configured with the provided parameters.
    private static func createLanguage(id: TreeSitterLanguage, 
                                       tsName: String,
                                       extensions: Set<String>,
                                       highlights: Set<String>? = nil,
                                       additionalIdentifiers: Set<String> = [],
                                       parentURL: URL? = nil) -> CodeLanguage {
        return CodeLanguage(id: id, 
                            tsName: tsName,
                            extensions: extensions,
                            parentURL: parentURL,
                            highlights: highlights,
                            additionalIdentifiers: additionalIdentifiers)
    }

    /// Creates a new `CodeLanguage` instance from an existing configuration.
    /// This method allows for easy duplication or modification of existing `CodeLanguage` instances.
    /// - Parameter config: A `CodeLanguage` instance to base the new instance on.
    /// - Returns: A new `CodeLanguage` instance configured with the same properties as the provided `config`.
    static func createLanguage(from config: CodeLanguage) -> CodeLanguage {
        return CodeLanguage(
            id: config.id,
            tsName: config.tsName,
            extensions: config.extensions,
            parentURL: config.parentQueryURL,
            highlights: config.additionalHighlights,
            additionalIdentifiers: config.additionalIdentifiers
        )
    }

    /// Provides an array of all registered `CodeLanguage` instances.
    /// This property accesses the `languageRegistery` to retrieve all currently registered languages.
    static var allLanguages: [CodeLanguage] {
        languageRegistery.allRegisteredLanguages
    }
}
