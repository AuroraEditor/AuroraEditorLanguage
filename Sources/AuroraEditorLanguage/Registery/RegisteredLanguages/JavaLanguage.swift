//
//  JavaLanguageHandler.swift
//  
//
//  Created by Nanashi Li on 2023/12/12.
//

import tree_sitter
import AuroraEditorSupportedLanguages
import SwiftTreeSitter

/// `JavaLanguageHandler` is a struct that implements `LanguageHandlerRegistry`.
/// It specializes in managing Java language aspects within the Tree-sitter parsing framework.
/// The handler's key roles include registering Java in the `LanguageRegistry`,
/// and providing functionality for retrieving the Tree-sitter language and queries specific to Java.
public struct JavaLanguageHandler: LanguageHandlerRegistery {

    /// A shared instance of `LanguageRegistry` for the purpose of language registration.
    var languageRegistery: LanguageRegistry = .shared

    /// A shared instance of `TreeSitterModel` used to access Tree-sitter queries.
    private let treeSitterModel: TreeSitterModel = .shared

    public init() {}

    /// Retrieves the Tree-sitter language pointer for Java.
    /// - Returns: An `UnsafeMutablePointer` to `TSLanguage` specifically designed for Java, if available.
    func getTreeSitterLanguage() -> UnsafeMutablePointer<TSLanguage>? {
        return tree_sitter_java()
    }

    /// Registers Java with the `LanguageRegistry`.
    /// This method sets up the Java language configuration, which includes its identifier, Tree-sitter name, and file extensions.
    public func registerLanguage(){
        languageRegistery.register(language: .java,
                                   handler: self,
                                   config: CodeLanguage(id: .java,
                                                        tsName: "java",
                                                        extensions: ["java", "jav"]))
    }

    /// Retrieves a `Query` object for the Java language.
    /// Utilizes `TreeSitterModel` to obtain the suitable query for Java.
    /// - Parameter language: The `TreeSitterLanguage` enum value for Java.
    /// - Returns: An optional `Query` instance for Java if available; otherwise, `nil`.
    func queryFor(_ language: TreeSitterLanguage) -> Query? {
        treeSitterModel.queryFor(.java)
    }
}
