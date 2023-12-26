//
//  TreeSitterModel.swift
//
//  Created by Nanashi Li on 2023/12/13.
//

import Foundation
import SwiftTreeSitter

/// `TreeSitterModel` is a class that provides functionalities for managing and retrieving queries
/// for different programming languages using the Tree-sitter parsing system. It acts as a bridge
/// between a given language and its associated Tree-sitter queries, handling query caching and
/// language configuration retrieval.
public class TreeSitterModel {

    /// The singleton/shared instance of `TreeSitterModel`.
    /// It provides a global access point to the `TreeSitterModel` functionalities.
    public static let shared: TreeSitterModel = .init()

    /// A cache that stores the queries associated with different programming languages.
    private var queryCache: [CodeLanguage: Query] = [:]

    /// A reference to the shared `LanguageRegistry` instance, used to retrieve language configurations.
    private let registery: LanguageRegistry = .shared

    /// Retrieves a `Query` object for a given `TreeSitterLanguage`.
    /// - Parameter language: The `TreeSitterLanguage` for which the query is to be retrieved.
    /// - Returns: An optional `Query` instance if it exists for the given language; otherwise, `nil`.
    public func query(for language: TreeSitterLanguage) -> Query? {
        return queryFor(language)
    }

    /// A private method to fetch a `Query` object for the specified `TreeSitterLanguage`.
    /// This method handles the logic for combining query data based on language dependencies
    /// and additional query files.
    /// - Parameter language: The `TreeSitterLanguage` for which the query is to be fetched.
    /// - Returns: An optional `Query` instance if available; otherwise, `nil`.
    public func queryFor(_ language: TreeSitterLanguage) -> Query? {
        guard let codeLanguage = registery.getLanguageConfiguration(for: language),
              let tsLanguage = codeLanguage.language,
              let url = codeLanguage.queryURL else {
            return nil
        }

        // Combine parent query data if available
        if let parentURL = codeLanguage.parentQueryURL,
           let data = combinedQueryData(for: [url, parentURL]) {
            return try? Query(language: tsLanguage, data: data)
        }

        // Handle additional highlights if available
        if let additionalHighlights = codeLanguage.additionalHighlights {
            var additionalURLs = additionalHighlights.compactMap { codeLanguage.queryURL(for: $0) }
            additionalURLs.append(url)
            guard let data = combinedQueryData(for: additionalURLs) else { return nil }
            return try? Query(language: tsLanguage, data: data)
        }

        // Default case: create a query with the primary URL
        return try? tsLanguage.query(contentsOf: url)
    }

    /// Combines the query data from multiple file URLs into a single `Data` object.
    /// This method is used to concatenate query files when a language depends on another language
    /// or has additional query files.
    /// - Parameter fileURLs: An array of `URL` objects representing the file paths of the query files.
    /// - Returns: An optional `Data` object containing the combined query data; `nil` if no data is available.
    private func combinedQueryData(for fileURLs: [URL]) -> Data? {
        var combinedData = Data()

        for url in fileURLs {
            do {
                let data = try Data(contentsOf: url)
                combinedData.append(data)
                combinedData.append("\n".data(using: .utf8) ?? Data())
            } catch {
                print("Error reading file at \(url): \(error)")
                return nil
            }
        }

        return combinedData.isEmpty ? nil : combinedData
    }

    private init() {}
}
