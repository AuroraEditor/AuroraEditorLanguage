//
//  CodeLanguage.swift
//
//  Created by Lukas Pistrol on 25.05.22.
//

import Foundation
import tree_sitter
import SwiftTreeSitter
import AuroraEditorSupportedLanguages
import RegexBuilder

/// `CodeLanguage` represents a programming language's configuration for use with Tree Sitter.
///
/// This struct encapsulates various properties of a programming language, such as its identifier,
/// display name, file extensions, and other relevant details. It is used to integrate a language
/// with the Tree Sitter parsing framework and to provide additional language-specific features.
public struct CodeLanguage {

    /// A shared instance of `LanguageRegistry` used for accessing language handlers.
    var languageRegistery: LanguageRegistry = .shared

    /// Initializes a new `CodeLanguage` instance.
    ///
    /// - Parameters:
    ///   - id: A `TreeSitterLanguage` enum representing the unique identifier of the language.
    ///   - tsName: A string representing the display name of the language.
    ///   - extensions: A set of strings representing file extensions associated with the language.
    ///   - parentURL: An optional URL pointing to a parent language query file. Useful for languages that inherit from others (e.g., C++ from C).
    ///   - highlights: An optional set of strings representing additional highlight file names.
    ///   - additionalIdentifiers: A set of additional identifiers for the language, used for tasks like shebang matching.
    internal init(
        id: TreeSitterLanguage,
        tsName: String,
        extensions: Set<String>,
        parentURL: URL? = nil,
        highlights: Set<String>? = nil,
        additionalIdentifiers: Set<String> = []
    ) {
        self.id = id
        self.tsName = tsName
        self.extensions = extensions
        self.parentQueryURL = parentURL
        self.additionalHighlights = highlights
        self.additionalIdentifiers = additionalIdentifiers
    }

    /// The unique identifier of the language.
    public let id: TreeSitterLanguage

    /// The display name of the language.
    public let tsName: String

    /// A set of file extensions associated with the language.
    ///
    /// This can include special file names in certain cases (e.g., `Dockerfile`, `Makefile`).
    public let extensions: Set<String>

    /// The URL of a query file for a parent language. This is used for languages that extend or inherit from others.
    public let parentQueryURL: URL?

    /// Additional highlight file names for the language.
    ///
    /// These are used for extended highlighting features, like JSX in JavaScript.
    public let additionalHighlights: Set<String>?

    /// The query URL for the language, if available.
    ///
    /// This URL points to the language's specific Tree Sitter query file.
    public var queryURL: URL? {
        queryURL()
    }

    /// The URL pointing to the language's resource bundle.
    internal var resourceURL: URL? = Bundle.module.resourceURL

    /// A set of additional identifiers for the language.
    ///
    /// These are used for matching specific language features, like shebang lines in scripts.
    public let additionalIdentifiers: Set<String>

    /// The Tree Sitter language object for the language, if available.
    ///
    /// This provides access to the Tree Sitter parsing functionality for the language.
    public var language: Language? {
        guard let tsLanguage = tsLanguage else { return nil }
        return Language(language: tsLanguage)
    }

    /// Generates a URL for a specific query file within the language's resources.
    ///
    /// - Parameter highlights: The name of the query file to look for, defaults to "highlights".
    /// - Returns: An optional URL pointing to the specified query file.
    internal func queryURL(for highlights: String = "highlights") -> URL? {
        return resourceURL?
            .appendingPathComponent("Resources/tree-sitter-\(tsName)/\(highlights).scm")
    }

    /// Retrieves the `TSLanguage` pointer from Tree Sitter for the language.
    ///
    /// This private property accesses the language's Tree Sitter configuration through its handler.
    private var tsLanguage: UnsafeMutablePointer<TSLanguage>? {
        let languageHandler = languageRegistery.getLanguageHandler(for: id)
        return languageHandler?.getTreeSitterLanguage()
    }
}

/// Extension of `CodeLanguage` to conform to `Hashable`.
///
/// This extension allows `CodeLanguage` instances to be used in collections that require hashable elements, like sets or dictionary keys.
extension CodeLanguage: Hashable {
    /// Compares two `CodeLanguage` instances for equality.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `CodeLanguage` instance.
    ///   - rhs: The right-hand side `CodeLanguage` instance.
    /// - Returns: `false` indicating that each instance is considered unique.
    public static func == (lhs: CodeLanguage, rhs: CodeLanguage) -> Bool {
        false
    }

    /// Hashes the essential components of the `CodeLanguage` by combining the language ID.
    ///
    /// - Parameter hasher: The hasher to use when combining the components of the instance.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

