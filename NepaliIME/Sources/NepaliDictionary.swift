// filepath: NepaliIME/Sources/NepaliDictionary.swift
// NepaliDictionary.swift - Nepali phonetic dictionary for word lookup
// Contains a built-in dictionary of common Nepali words with their Devanagari equivalents

import Foundation

/// NepaliDictionary provides word lookup functionality
/// Maps Latin phonetic spellings to Nepali Devanagari text
class NepaliDictionary {
    
    // MARK: - Dictionary Data
    
    /// Main dictionary mapping Latin to Devanagari
    /// Key: lowercase Latin spelling
    /// Value: Nepali Devanagari text
    private var dictionary: [String: String] = [
        // Greetings
        "namaste": "नमस्ते",
        "hello": "नमस्ते",
        "hi": "नमस्ते",
        
        // Pronouns
        "mero": "मेरो",
        "timro": "तिम्रो",
        "timi": "तिमी",
        "hamro": "हाम्रो",
        "uniharu": "उनीहरू",
        "yo": "यो",
        "ta": "त",
        "tao": "तपाईं",
        "hami": "हामी",
        
        // Common words
        "nepal": "नेपाल",
        "nepali": "नेपाली",
        "bidesh": "विदेश",
        "ghar": "घर",
        "khana": "खाना",
        "pani": "पानी",
        "sathi": "साथी",
        "ramro": "राम्रो",
        "naramro": "नराम्रो",
        "kasto": "कस्तो",
        "kaha": "कहाँ",
        "kati": "कति",
        "kuna": "कुन",
        "ke": "के",
        "ra": "र",
        "hau": "हाँ",
        "chain": "चैन",
        "sukha": "सुख",
        "dukha": "दुःख",
        
        // Education
        "shikshya": "शिक्षा",
        "vidyalaya": "विद्यालय",
        "shikshak": "शिक्षक",
        "shikshika": "शिक्षिका",
        "bidyarthi": "विद्यार्थी",
        "pustak": "पुस्तक",
        "kagaj": "कागज",
        "kalam": "कलम",
        
        // Family
        "ba": "बा",
        "ama": "आमा",
        "daju": "दाजु",
        "bai": "बै",
        "bhai": "भाई",
        "bahini": "बहिनी",
        "chhora": "छोरा",
        "chhori": "छोरी",
        "kutu": "कुटु",
        "babura": "बाबु",
        "maih": "माई",
        
        // Numbers
        "ek": "एक",
        "dui": "दुई",
        "tin": "तीन",
        "char": "चार",
        "paach": "पाँच",
        "chha": "छ",
        "sat": "सात",
        "aath": "आठ",
        "nau": "नौ",
        "das": "दश",
        
        // Days
        "aaitab": "आइतबार",
        "sombar": "सोमबार",
        "mangalbar": "मङ्गलबार",
        "budhabar": "बुधबार",
        "bihibar": "बिहिबार",
        "shukarbar": "शुक्रबार",
        "shanibar": "शनिबार",
        
        // Time
        "bajra": "बजर",
        "minute": "मिनेट",
        "ghanta": "घण्टा",
        "din": "दिन",
        "raat": "रात",
        "bihana": "बिहान",
        "dopahar": "दोपहर",
        "shaam": "शाम",
        
        // Common verbs
        "huncha": "हुन्छ",
        "cha": "छ",
        "chaein": "छैन",
        "jancha": "जान्छ",
        "aaucha": "आउँछ",
        "janchha": "जान्छ",
        "bolcha": "बोल्छ",
        "sake": "सके",
        "sakdina": "सक्दैन",
        "garne": "गर्ने",
        "gare": "गरे",
        "garim": "गरिए",
        
        // Food
        "roti": "रोटी",
        "chapati": "चपाती",
        "dal": "दाल",
        "bhat": "भात",
        "tarkari": "तरकारी",
        "achar": "अचार",
        "mitho": "मीठो",
        "khaana": "खाना",
        
        // Places
        "shahar": "शहर",
        "gaun": "गाउँ",
        "road": "रोड",
        "bazar": "बजार",
        "pasalmandu": "पासलमान्डु",
        "kathmandu": "काठमाडौं",
        "lalitpur": "ललितपुर",
        "bhaktapur": "भक्तपुर",
        
        // Nature
        "jhoola": "झूला",
        "pashu": "पशु",
        "kukura": "कुकुर",
        "bukh": "बुख",
        "rukh": "रूख",
        "phool": "फूल",
        "patta": "पत्ता",
        "bag": "बगान",
        "bagh": "बाघ",
        "chitu": "चितु",
        "murgi": "मुर्गी",
        
        // Body parts
        "sir": "शिर",
        "muko": "मुख",
        "aankha": "आँखा",
        "naka": "नाक",
        "kan": "कान",
        "hat": "हात",
        "pair": "पैर",
        "pet": "पेट",
        
        // Colors
        "lal": "लाल",
        "kaalo": "कालो",
        "saphed": "सेतो",
        "haru": "हरू",
        "neel": "नीलो",
        "hario": "हरियो",
        
        // Misc
        "dhanyabaad": "धन्यवाद",
        "dhanyabad": "धन्यबाद",
        "sorry": "माफ गर्नुहोस्",
        "pardon": "माफ गर्नुहोस्",
        "subhkamana": "शुभकामना",
        "shubhkaamna": "शुभकामना",
        "swasthya": "स्वास्थ्य",
        "sano": "सानो",
        "thulo": "ठूलो",
        "tarjuma": "तर्जुमा",
        "anuvad": "अनुवाद"
    ]
    
    // MARK: - Initialization
    
    init() {
        NSLog("NepaliDictionary: Initialized with \(dictionary.count) entries")
    }
    
    // MARK: - Lookup Methods
    
    /// Look up a word in the dictionary
    /// - Parameter word: The Latin spelling to look up
    /// - Returns: Array of matching Devanagari strings (may include partial matches)
    func lookup(word: String) -> [String] {
        let lowercaseWord = word.lowercased()
        
        // Exact match
        if let exactMatch = dictionary[lowercaseWord] {
            return [exactMatch]
        }
        
        // Prefix matches (for autocomplete)
        var prefixMatches: [String] = []
        for (key, value) in dictionary {
            if key.hasPrefix(lowercaseWord) && key != lowercaseWord {
                prefixMatches.append(value)
            }
        }
        
        return prefixMatches
    }
    
    /// Check if a word exists in the dictionary
    /// - Parameter word: The Latin spelling to check
    /// - Returns: true if the word exists
    func contains(word: String) -> Bool {
        return dictionary[word.lowercased()] != nil
    }
    
    /// Get all words that start with a given prefix
    /// - Parameter prefix: The prefix to search for
    /// - Returns: Array of tuples containing (Latin, Devanagari)
    func wordsStartingWith(prefix: String) -> [(latin: String, devanagari: String)] {
        let lowercasePrefix = prefix.lowercased()
        var results: [(latin: String, devanagari: String)] = []
        
        for (key, value) in dictionary {
            if key.hasPrefix(lowercasePrefix) {
                results.append((latin: key, devanagari: value))
            }
        }
        
        return results
    }
    
    /// Add a new word to the dictionary (for runtime extension)
    /// - Parameters:
    ///   - latin: Latin spelling
    ///   - devanagari: Devanagari text
    func addWord(latin: String, devanagari: String) {
        dictionary[latin.lowercased()] = devanagari
    }
    
    /// Get the count of words in the dictionary
    var count: Int {
        return dictionary.count
    }
}