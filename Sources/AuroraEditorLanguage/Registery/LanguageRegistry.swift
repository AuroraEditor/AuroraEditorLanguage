//
//  LanguageRegistry.swift
//  
//
//  Created by Nanashi Li on 2023/12/12.
//

import tree_sitter
import SwiftTreeSitter
import Foundation

/// `LanguageRegistry` is a class designed to manage language handlers.
///
/// This class acts as a central repository for registering and retrieving language handlers.
/// It maps `TreeSitterLanguage` enums to corresponding `LanguageHandlerRegistery` instances using a dictionary.
/// Additionally, it sends notifications through `NotificationCenter` whenever a new language is registered.
///
/// - Example Usage:
///     To monitor new language registrations, add an observer in `NotificationCenter`.
///     Example code for adding an observer:
///     ```
///     NotificationCenter.default.addObserver(
///         self,
///         selector: #selector(handleLanguageRegisteredNotification(_:)),
///         name: .languageRegistered,
///         object: nil
///     )
///     ```
///
///     For handling notifications when a new language is registered:
///     ```
///     @objc func handleLanguageRegisteredNotification(_ notification: Notification) {
///         if let languageID = notification.userInfo?["languageID"] as? LanguageID {
///             // Implement actions for new language registration here
///         }
///     }
///     ```
public class LanguageRegistry {

    /// A shared instance of `LanguageRegistry` for global access.
    public static let shared = LanguageRegistry()

    /// A private dictionary mapping `TreeSitterLanguage` to `LanguageHandlerRegistery`.
    private var registry: [TreeSitterLanguage: LanguageHandlerRegistery] = [:]

    /// A private dictionary storing `CodeLanguage` configurations mapped by `TreeSitterLanguage`.
    private var languages: [TreeSitterLanguage: CodeLanguage] = [:]

    /// A public dictionary containing queries for each registered language.
    public var languageQueries: [TreeSitterLanguage: Query?] = [:]

    /// Provides a list of all registered `CodeLanguage` instances.
    public var allRegisteredLanguages: [CodeLanguage] {
        return Array(languages.values)
    }

    /// Registers a new language along with its handler and configuration.
    ///
    /// This method adds a new language to the registry, mapping the language's unique identifier to its handler and configuration.
    /// It also posts a notification indicating a new language registration.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the language (`TreeSitterLanguage`).
    ///   - handler: The `LanguageHandlerRegistery` instance managing the language.
    ///   - config: The `CodeLanguage` configuration of the language.
    func register(language id: TreeSitterLanguage,
                  handler: LanguageHandlerRegistery,
                  config: CodeLanguage) {
        registry[id] = handler
        languages[id] = config
        languageQueries[id] = query(for: id)

        NotificationCenter.default.post(name: .languageRegistered,
                                        object: nil,
                                        userInfo: ["languageID": id])
    }

    /// Retrieves the configuration for a specified language.
    ///
    /// - Parameter id: The unique identifier of the language (`TreeSitterLanguage`).
    /// - Returns: An optional `CodeLanguage` instance representing the language's configuration, if available.
    func getLanguageConfiguration(for id: TreeSitterLanguage) -> CodeLanguage? {
        return languages[id]
    }

    /// Retrieves a query for a specified language.
    ///
    /// - Parameter language: The `TreeSitterLanguage` for which the query is needed.
    /// - Returns: An optional `Query` instance for the language, if available.
    public func query(for language: TreeSitterLanguage) -> Query? {
        return languageQueries[language] ?? nil
    }

    /// Retrieves the handler for a specified language.
    ///
    /// - Parameter id: The unique identifier of the language (`TreeSitterLanguage`).
    /// - Returns: An optional `LanguageHandlerRegistery` instance managing the language, if available.
    func getLanguageHandler(for id: TreeSitterLanguage) -> LanguageHandlerRegistery? {
        return registry[id]
    }
}
