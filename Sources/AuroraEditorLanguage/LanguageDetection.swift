//
//  LanguageDetection.swift
//  
//
//  Created by Nanashi Li on 2023/12/12.
//

import Foundation
import RegexBuilder

/// An extension to `CodeLanguage` that provides functionality for detecting the programming language of files.
///
/// This extension adds capabilities to `CodeLanguage` for identifying the language from a file's URL,
/// shebang, modeline, or an identifier. It includes private static properties for indexing languages
/// by their names, extensions, and additional identifiers for quick lookup.
public extension CodeLanguage {

    private static var tsNameIndex: [String: CodeLanguage] = [:]
    private static var extensionsIndex: [String: CodeLanguage] = [:]
    private static var additionalIdentifiersIndex: [String: CodeLanguage] = [:]

    /// Detects the programming language for a given file URL, optionally using the file's prefix and suffix contents.
    ///
    /// This method attempts to identify the language by analyzing the file's extension,
    /// its shebang line, or modeline indicators. It returns a default language as a fallback if no match is found.
    ///
    /// - Parameters:
    ///   - url: The URL of the file for which to detect the language.
    ///   - prefixBuffer: An optional string representing the first few lines of the file. Used for shebang and modeline detection.
    ///   - suffixBuffer: An optional string representing the last few lines of the file. Used for modeline detection.
    /// - Returns: The detected `CodeLanguage`, or a default language if no specific language is identified.
    static func detectLanguageFrom(url: URL,
                                   prefixBuffer: String? = nil,
                                   suffixBuffer: String? = nil) -> CodeLanguage {
        // Check URL-based language detection
        if let urlLanguage = detectLanguageUsingURL(url: url) {
            return urlLanguage
        }

        // Check for shebang-based language detection
        if let prefix = prefixBuffer, let shebangLanguage = detectLanguageUsingShebang(contents: prefix.lowercased()) {
            return shebangLanguage
        }

        // Check for modeline-based language detection
        if let modelineLanguage = detectLanguageUsingModeline(prefixBuffer: prefixBuffer?.lowercased() ?? "",
                                                              suffixBuffer: suffixBuffer?.lowercased()) {
            return modelineLanguage
        }

        // Default language as a fallback
        return PlainTextLanguageHandler().getLanguage()
    }

    /// Detects the programming language from a file's URL based on its extension or filename.
    ///
    /// This method examines the file's extension and specific filenames like 'Makefile' or 'Dockerfile' to determine the language.
    /// - Parameter url: The URL of the file.
    /// - Returns: An optional `CodeLanguage` corresponding to the file's extension or filename.
    private static func detectLanguageUsingURL(url: URL) -> CodeLanguage? {
        let fileExtension = url.pathExtension.lowercased()
        let fileName = url.pathComponents.last // Keep the case sensitivity for special file types

        let fileNameOrExtension = fileExtension.isEmpty ? (fileName != nil ? fileName! : "") : fileExtension
        
        if let lang = languageRegistery.allRegisteredLanguages.first(where: { lang in lang.extensions.contains(fileNameOrExtension)}) {
            return lang
        } else {
            return nil
        }
    }

    /// Detects the programming language from a file's shebang line.
    ///
    /// This method parses the shebang line of a file (e.g., `#!/usr/bin/env python`) to determine the language.
    /// - Parameter contents: The contents of the first few lines of the file, used to locate the shebang line.
    /// - Returns: An optional `CodeLanguage` identified from the shebang line.
    private static func detectLanguageUsingShebang(contents: String) -> CodeLanguage? {
        // Extract the first line
        guard let firstLine = contents.split(separator: "\n").first,
              firstLine.starts(with: "#!") else {
            return nil
        }

        // Regular expression patterns
        let shebangPattern = "^#!\\s*[/\\w]+\\s*"
        let scriptPattern = "\\b\\w+\\b"

        do {
            // Regex for shebang line
            let shebangRegex = try NSRegularExpression(pattern: shebangPattern)
            let scriptRegex = try NSRegularExpression(pattern: scriptPattern)

            let range = NSRange(firstLine.startIndex..<firstLine.endIndex, in: firstLine)
            let shebangRange = shebangRegex.rangeOfFirstMatch(in: String(firstLine), options: [], range: range)

            if shebangRange.location != NSNotFound {
                let scriptRange = scriptRegex.rangeOfFirstMatch(in: String(firstLine), options: [], range: range)
                if scriptRange.location != NSNotFound {
                    let startIndex = firstLine.index(firstLine.startIndex, offsetBy: scriptRange.location)
                    let endIndex = firstLine.index(startIndex, offsetBy: scriptRange.length)
                    let script = String(firstLine[startIndex..<endIndex])
                    return languageFromIdentifier(script)
                }
            }
        } catch {
            // Handle regex compilation error
            print("Regex compilation error: \(error)")
            return nil
        }

        return nil
    }

    /// Detects the programming language from a file's modeline.
    ///
    /// This method searches for modeline patterns in the file's prefix or suffix to determine the language.
    /// Supports modelines used in editors like Vim or Emacs.
    ///
    /// - Parameters:
    ///   - prefixBuffer: The first few lines of the file.
    ///   - suffixBuffer: The last few lines of the file.
    /// - Returns: An optional `CodeLanguage` identified from the modeline.
    private static func detectLanguageUsingModeline(prefixBuffer: String, suffixBuffer: String?) -> CodeLanguage? {
        // Compiled regex patterns
        let emacsLinePattern = "-\\*-.*-\\*-"
        let emacsLanguagePattern = "mode:\\s*(\\w+)"
        let vimLinePattern = "(//|/\\*)\\s*vim:.*"
        let vimLanguagePattern = "ft=(\\w+)"

        func detectModeline(in string: String) -> CodeLanguage? {
            guard !string.isEmpty else { return nil }

            let emacsLineRegex = try! NSRegularExpression(pattern: emacsLinePattern, options: [])
            let emacsLanguageRegex = try! NSRegularExpression(pattern: emacsLanguagePattern, options: [])
            let vimLineRegex = try! NSRegularExpression(pattern: vimLinePattern, options: [])
            let vimLanguageRegex = try! NSRegularExpression(pattern: vimLanguagePattern, options: [])

            let nsString = string as NSString

            if let emacsLineMatch = emacsLineRegex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: nsString.length)),
               let emacsLanguageMatch = emacsLanguageRegex.firstMatch(in: string, options: [], range: emacsLineMatch.range) {
                let emacsLanguage = nsString.substring(with: emacsLanguageMatch.range(at: 1))
                return languageFromIdentifier(emacsLanguage)
            } else if let vimLineMatch = vimLineRegex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: nsString.length)),
                      let vimLanguageMatch = vimLanguageRegex.firstMatch(in: string, options: [], range: vimLineMatch.range) {
                let vimLanguage = nsString.substring(with: vimLanguageMatch.range(at: 1))
                return languageFromIdentifier(vimLanguage)
            } else {
                return nil
            }
        }

        if let detectedLanguage = detectModeline(in: prefixBuffer) {
            return detectedLanguage
        }

        return detectModeline(in: suffixBuffer ?? "")
    }

    /// Retrieves a `CodeLanguage` from a given identifier.
    ///
    /// This method searches the indexed languages by their names, extensions, and additional identifiers.
    /// - Parameter identifier: A string identifier to match against known languages.
    /// - Returns: An optional `CodeLanguage` matching the identifier.
    private static func languageFromIdentifier(_ identifier: String) -> CodeLanguage? {
        if let byTsName = tsNameIndex[identifier] {
            return byTsName
        }
        if let byExtension = extensionsIndex[identifier] {
            return byExtension
        }
        return additionalIdentifiersIndex[identifier]
    }
}
