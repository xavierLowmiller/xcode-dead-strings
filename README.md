# Xcode Dead Strings

Find dead localized strings in your Xcode project

## Installing

### Brew

```sh
brew install xavierLowmiller/tap/xcode-dead-strings
```

### From Source

Clone this project and run `swift build -c release`

## Supports

- [x] Swift
  - [x] `"Regular Strings"`
  - [ ] `"""Multiline Strings"""`
  - [ ] `#"Raw Strings"#`
- [x] Objective-C(++)
- [x] Info.plist keys
- [ ] Storyboards / xibs
- [ ] .intentDefinition files

## Use cases

### List all dead Strings by file

```sh
xcode-dead-strings
```

### Create Xcode warnings for dead Strings

```sh
xcode-dead-strings --xcode-warnings
```

### Immediately delete all identified dead Strings

```sh
xcode-dead-strings --delete
```

## Options

```sh
▶ xcode-dead-strings --help

USAGE: xcode-dead-strings [<path>] [--silent] [--delete] [--xcode-warnings] [--source-path <source-path>] [--localization-path <localization-path>]

ARGUMENTS:
  <path>                  The root path of the iOS directory (default: .)

OPTIONS:
  --silent                Should output be silenced? 
  --delete                Delete dead strings from .strings files automatically 
  --xcode-warnings        Show dead strings as warnings in Xcode 
  --source-path <source-path>
                          Path containing the source files to be searched 
  --localization-path <localization-path>
                          Path containing the localization files to be searched 
  -h, --help              Show help information.
```

## Limitations ⚠️

This command line tool can only detect static strings. If you compute your localized String keys dynamically, they won't be detected by `xcode-dead-string`, so this won't work:

```swift
var key = "my_string_key"
if foo {
  key += "_1"
} else {
  key += "_2"
}
```

You can work around this by either restructuring your code to only have static Strings:

```swift
let key: String
if foo {
  key = "my_string_key_1"
} else {
  key = "my_string_key_2"
}
```

Or you can ignore the keys from `xcode-dead-strings` by adding a comment in your `Localizable.strings` file:

```swift
/* no_dead_string */
"my_string_key_1" = "...";

// no_dead_string
"my_string_key_1" = "...";
```
