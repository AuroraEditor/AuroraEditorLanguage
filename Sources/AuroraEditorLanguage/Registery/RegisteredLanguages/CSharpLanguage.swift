//
//  CSharpLanguageHandler.swift
//  
//
//  Created by Nanashi Li on 2023/12/12.
//

import tree_sitter
import AuroraEditorSupportedLanguages
import SwiftTreeSitter

/// `CSharpLanguageHandler` is a struct conforming to `LanguageHandlerRegistry`.
/// It specializes in handling C# language specifics within the Tree-sitter parsing framework.
/// The handler's primary roles include registering C# in the `LanguageRegistry`,
/// and facilitating the retrieval of the Tree-sitter language and queries for C#.
public struct CSharpLanguageHandler: LanguageHandlerRegistery {

    /// A shared `LanguageRegistry` instance used for registering languages.
    var languageRegistery: LanguageRegistry = .shared

    /// A shared `TreeSitterModel` instance for accessing Tree-sitter queries.
    private let treeSitterModel: TreeSitterModel = .shared

    public init() {}

    /// Retrieves the Tree-sitter language pointer for C#.
    /// - Returns: An `UnsafeMutablePointer` to `TSLanguage` specifically for C#, if available.
    func getTreeSitterLanguage() -> UnsafeMutablePointer<TSLanguage>? {
        return tree_sitter_c_sharp()
    }

    /// Registers C# with the `LanguageRegistry`.
    /// This method sets up the C# language configuration, which includes its identifier, Tree-sitter name, and file extensions.
    public func registerLanguage(){
        languageRegistery.register(language: .cSharp,
                                   handler: self,
                                   config: CodeLanguage(id: .cSharp,
                                                        tsName: "c-sharp",
                                                        extensions: ["cs"]))
    }

    /// Retrieves a `Query` object for the C# language.
    /// Utilizes `TreeSitterModel` to source the appropriate query for C#.
    /// - Parameter language: The `TreeSitterLanguage` enum value for C#.
    /// - Returns: An optional `Query` instance for C# if available; otherwise, `nil`.
    func queryFor(_ language: TreeSitterLanguage) -> Query? {
        treeSitterModel.queryFor(.cSharp)
    }
}
