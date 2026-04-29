# Nepali IME - macOS Input Method Editor

A Nepali phonetic Input Method Editor (IME) for macOS that converts Latin text to Nepali Devanagari script, similar to the macOS Pinyin-to-Chinese keyboard.

## Features

- **Phonetic Input**: Type Latin letters (e.g., "namaste", "mero", "nepal") and get Nepali Devanagari suggestions (नमस्ते, मेरो, नेपाल)
- **Candidate Window**: Shows suggestions as you type
- **Multiple Selection Methods**:
  - Space: Commit first candidate
  - Enter: Commit first candidate
  - Number keys 1-9: Select specific candidate
  - Escape: Clear composing buffer
  - Backspace: Remove last character
- **Fallback Transliteration**: When no dictionary match, uses rule-based transliteration
- **Built-in Dictionary**: Includes common Nepali words

## File Structure

```
Nepali keyboard/
├── NepaliIME/
│   ├── Sources/
│   │   ├── main.swift              # Application entry point
│   │   ├── AppDelegate.swift       # Application delegate
│   │   ├── InputMethodController.swift  # Main input method controller
│   │   ├── NepaliDictionary.swift  # Word lookup dictionary
│   │   ├── TransliterationEngine.swift  # Latin to Devanagari conversion
│   │   └── CandidateWindowController.swift  # Candidate selection UI
│   ├── Info.plist                  # Input method configuration
│   └── NepaliIME.entitlements      # App entitlements
├── NepaliIME.xcodeproj/
│   └── project.pbxproj            # Xcode project file
└── README.md                       # This file
```

## Requirements

- macOS 13.0 (Ventura) or later
- Xcode 15.0 or later

## Building the Project

### Using Xcode

1. Open `NepaliIME.xcodeproj` in Xcode
2. Select the "NepaliIME" scheme
3. Press Cmd+B to build, or go to Product → Build

### Using Terminal

```bash
cd "/Users/bikki/Desktop/Nepali keyboard"
xcodebuild -project NepaliIME.xcodeproj -scheme NepaliIME -configuration Debug build
```

The built application will be in:
```
~/Library/Developer/Xcode/DerivedData/NepaliIME-*/Build/Products/Debug/NepaliIME.app
```

## Installing the Input Method

### Step 1: Copy the App to Input Methods Folder

```bash
# Find the built app
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "NepaliIME.app" -type d | head -1)

# Copy to Input Methods folder
cp -R "$APP_PATH" ~/Library/Input\ Methods/
```

### Step 2: Enable the Input Method

1. Open **System Settings** (or System Preferences on older macOS)
2. Go to **Keyboard** → **Input Sources**
3. Click the **+** button to add a new input source
4. Search for "Nepali" in the search box
5. Select **Nepali IME** from the list
6. Click **Add**

### Step 3: Switch to Nepali IME

1. Click the input method icon in the menu bar (flag or keyboard icon)
2. Select **Nepali IME** from the list

## Using the Input Method

### Basic Usage

1. Switch to Nepali IME using the input method menu
2. Start typing in Latin letters
3. As you type, candidate suggestions appear
4. Press Space or Enter to commit the first candidate
5. Press number keys 1-9 to select a specific candidate

### Example Translations

| Latin Input | Nepali Output |
|-------------|---------------|
| namaste | नमस्ते |
| mero | मेरो |
| timi | तिमी |
| nepal | नेपाल |
| shikshya | शिक्षा |
| ghar | घर |
| khana | खाना |
| pani | पानी |

### Keyboard Shortcuts

- **Space**: Commit first candidate
- **Enter**: Commit first candidate
- **1-9**: Select candidate by number
- **Escape**: Clear composing buffer
- **Backspace**: Delete last character

## How It Works

### Input Method Kit (InputMethodKit)

This IME uses Apple's InputMethodKit framework, which provides:
- Communication with client applications
- Composing buffer management
- Candidate window integration
- Menu bar integration

### Dictionary Lookup

The `NepaliDictionary` class contains a built-in dictionary of common Nepali words. When you type, it:
1. Checks for exact matches in the dictionary
2. Returns prefix matches for autocomplete

### Transliteration Fallback

When no dictionary match is found, the `TransliterationEngine` provides rule-based conversion:
- Maps Latin characters to Devanagari equivalents
- Handles vowels and consonants
- Provides phonetic transliteration

### Candidate Window

The `CandidateWindowController` displays:
- Dictionary matches
- Transliteration preview
- Numbered selection options

## Troubleshooting

### Input Method Not Appearing

1. Make sure the app is copied to `~/Library/Input Methods/`
2. Log out and log back in, or restart
3. Check System Settings → Keyboard → Input Sources

### Build Errors

If you encounter build errors:
1. Make sure Xcode is up to date
2. Clean the build folder (Cmd+Shift+K)
3. Delete DerivedData and rebuild

### Candidates Not Showing

1. Check if the input method is active
2. Try typing longer words
3. Check the console for error messages

## Future Improvements

- [ ] Expand the dictionary with more words
- [ ] Add learning from user input
- [ ] Improve transliteration rules
- [ ] Add support for Romanized Nepali
- [ ] Implement keyboard shortcuts customization

## License

This project is provided as-is for educational and personal use.

## Acknowledgments

- Apple InputMethodKit Documentation
- macOS Input Method Guidelines# Nepali-keyboard
