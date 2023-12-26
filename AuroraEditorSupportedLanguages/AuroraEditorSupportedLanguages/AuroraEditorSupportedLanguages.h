//
//  AuroraEditorSupportedLanguages.h
//  AuroraEditorSupportedLanguages
//
//  Created by Nanashi Li on 2023/12/10.
//
#ifndef AuroraEditorSupportedLanguages_h
#define AuroraEditorSupportedLanguages_h

#import <Foundation/Foundation.h>

//! Project version number for AuroraEditorSupportedLanguages.
FOUNDATION_EXPORT double AuroraEditorSupportedLanguagesVersionNumber;

//! Project version string for AuroraEditorSupportedLanguages.
FOUNDATION_EXPORT const unsigned char AuroraEditorSupportedLanguagesVersionString[];

typedef struct TSLanguage TSLanguage;

#ifdef __cplusplus
extern "C" {
#endif

// Macro for declaring tree-sitter language functions
#define DECLARE_LANGUAGE_FUNC(lang) extern TSLanguage *tree_sitter_##lang();

// A collection of pointers to supported tree-sitter languages
// Languages are grouped and sorted for better readability and maintainability

// C-based languages
DECLARE_LANGUAGE_FUNC(c)
DECLARE_LANGUAGE_FUNC(cpp)
DECLARE_LANGUAGE_FUNC(c_sharp)

// Web technologies
DECLARE_LANGUAGE_FUNC(css)
DECLARE_LANGUAGE_FUNC(javascript)

// Other languages (please keep in alphabetical order)
DECLARE_LANGUAGE_FUNC(bash)
DECLARE_LANGUAGE_FUNC(go)
DECLARE_LANGUAGE_FUNC(java)
DECLARE_LANGUAGE_FUNC(ocaml)
DECLARE_LANGUAGE_FUNC(php)
DECLARE_LANGUAGE_FUNC(ruby)

#ifdef __cplusplus
}
#endif

#endif /* AuroraEditorSupportedLanguages_h */
