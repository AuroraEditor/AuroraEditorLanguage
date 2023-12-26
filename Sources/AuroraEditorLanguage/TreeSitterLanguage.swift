//
//  TreeSitterLanguage.swift
//
//  Created by Nanashi Li on 2023/12/13
//

import Foundation

/// An enumeration of supported languages for Tree Sitter.
///
/// `TreeSitterLanguage` defines a set of programming languages that can be used with
/// the Tree Sitter parsing framework. Each case in the enum represents a specific language,
/// identified by its unique name.
///
/// The enum is used to specify and manage language-specific behaviors and configurations
/// within the Tree Sitter framework, such as parsing, syntax highlighting, and querying.
public enum TreeSitterLanguage: String {
    case bash
    case c
    case cpp
    case cSharp
    case css
    case go
    case java
    case javascript
    case ocaml
    case php
    case ruby
    case plainText
}
