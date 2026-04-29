// filepath: NepaliIME/Sources/TransliterationEngine.swift
// TransliterationEngine.swift - Rule-based Latin to Devanagari transliteration
// Provides fallback conversion when dictionary lookup fails

import Foundation

/// TransliterationEngine converts Latin text to Devanagari using phonetic rules
/// This is a fallback system when no dictionary match is found
class TransliterationEngine {
    
    // MARK: - Transliteration Rules
    
    /// Mapping from Latin characters/sequences to Devanagari
    /// Order matters: longer sequences should come first for proper matching
    private let transliterationMap: [(pattern: String, replacement: String)] = [
        // Vowels - standalone forms
        ("aa", "आ"),
        ("ee", "ई"),
        ("ii", "ई"),
        ("oo", "ऊ"),
        ("uu", "ऊ"),
        ("ai", "ऐ"),
        ("au", "औ"),
        
        // Short vowels
        ("a", "अ"),
        ("i", "इ"),
        ("u", "उ"),
        ("e", "ए"),
        ("o", "ओ"),
        
        // Consonants - basic
        ("kh", "ख"),
        ("gh", "घ"),
        ("ch", "च"),
        ("chh", "छ"),
        ("jh", "झ"),
        ("th", "थ"),
        ("dh", "ध"),
        ("ph", "फ"),
        ("bh", "भ"),
        ("sh", "श"),
        ("ng", "ङ"),
        ("ny", "ञ"),
        ("nn", "ण"),
        
        // Retroflex consonants
        ("Da", "ड"),
        ("Dha", "ढ"),
        
        // Basic consonants
        ("k", "क"),
        ("g", "ग"),
        ("c", "च"),
        ("j", "ज"),
        ("t", "त"),
        ("d", "द"),
        ("n", "न"),
        ("p", "प"),
        ("b", "ब"),
        ("m", "म"),
        ("y", "य"),
        ("r", "र"),
        ("l", "ल"),
        ("v", "व"),
        ("w", "व"),
        ("s", "स"),
        ("h", "ह"),
        
        // Aspirated consonants (additional mappings)
        ("K", "ख"),
        ("G", "ग"),
        ("C", "च"),
        ("J", "ज"),
        ("T", "त"),
        ("D", "द"),
        ("P", "प"),
        ("B", "ब"),
        ("M", "म"),
        ("N", "न"),
        ("F", "फ"),
        ("Q", "क"),
        ("X", "क्स"),
        ("Z", "ज़"),
        
        // Special characters
        ("'", ""),
        ("\"", ""),
        (".", "।"),
        (",", ","),
        
        // Numbers
        ("0", "०"),
        ("1", "१"),
        ("2", "२"),
        ("3", "३"),
        ("4", "४"),
        ("5", "५"),
        ("6", "६"),
        ("7", "७"),
        ("8", "८"),
        ("9", "९"),
    ]
    
    // MARK: - Initialization
    
    init() {
        NSLog("TransliterationEngine: Initialized")
    }
    
    // MARK: - Transliteration Methods
    
    /// Transliterate a Latin string to Devanagari
    /// - Parameter input: The Latin string to convert
    /// - Returns: The Devanagari transliteration
    func transliterate(_ input: String) -> String {
        guard !input.isEmpty else { return "" }
        
        var result = ""
        var index = input.startIndex
        
        while index < input.endIndex {
            let remaining = String(input[index...])
            
            // Try to match the longest possible pattern
            var matched = false
            
            for (pattern, replacement) in transliterationMap {
                if remaining.hasPrefix(pattern) {
                    result += replacement
                    index = input.index(index, offsetBy: pattern.count)
                    matched = true
                    break
                }
            }
            
            // If no match found, copy the character as-is
            if !matched {
                let char = String(input[index])
                result += char
                index = input.index(after: index)
            }
        }
        
        return result
    }
    
    /// Transliterate a single word
    /// - Parameter word: The Latin word to convert
    /// - Returns: The Devanagari transliteration
    func transliterateWord(_ word: String) -> String {
        return transliterate(word)
    }
    
    /// Transliterate with word boundaries (applies halant for consonant clusters)
    /// - Parameter text: The Latin text to convert
    /// - Returns: The Devanagari transliteration
    func transliterateWithBoundaries(_ text: String) -> String {
        let words = text.components(separatedBy: " ")
        var results: [String] = []
        
        for word in words {
            if word.isEmpty {
                continue
            }
            results.append(transliterateWord(word.trimmingCharacters(in: .punctuationCharacters)))
        }
        
        return results.joined(separator: " ")
    }
    
    // MARK: - Utility Methods
    
    /// Check if a character is a vowel
    /// - Parameter char: Character to check
    /// - Returns: true if it's a vowel
    func isVowel(_ char: Character) -> Bool {
        let vowels = CharacterSet(charactersIn: "aeiouAEIOU")
        return vowels.contains(char.unicodeScalars.first ?? " ")
    }
    
    /// Check if a character is a consonant
    /// - Parameter char: Character to check
    /// - Returns: true if it's a consonant
    func isConsonant(_ char: Character) -> Bool {
        let consonants = CharacterSet(charactersIn: "bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ")
        return consonants.contains(char.unicodeScalars.first ?? " ")
    }
    
    /// Get the vowel sound for a character
    /// - Parameter char: Character to get vowel for
    /// - Returns: The Devanagari vowel marker
    func getVowelMarker(for char: Character) -> String? {
        let vowelMarkers: [Character: String] = [
            "a": "ा", "i": "ि", "u": "ू", "e": "े", "o": "ो",
            "A": "ा", "I": "ी", "U": "ू", "E": "े", "O": "ो"
        ]
        return vowelMarkers[char]
    }
}