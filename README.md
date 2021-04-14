# Xcode Dead Strings

Find dead localized strings in your Xcode project.

## Installing

### From Source

Clone this project and run `swift build -c release`

## Supports

- [x] Swift
  - [x] `"Regular Strings"`
  - [ ] `"""Multiline Strings"""`
  - [ ] `#"Raw Strings"#`
- [x] Objective-C(++)
- [x] Info.plist keys

## Options

* `--source-path <source-path>`

The path to your source files (relative to your project directory).
Setting this can greatly improve execution speed.

* `--localization-path <localization-path>`

The path to your localizable `.strings` files (relative to your project directory).
Setting this can greatly improve execution speed.

* `--delete`

Automatically delete all dead strings from your `.strings` files

* `--xcode-warnings`

For use as an Xcode build phase:

<img width="540" alt="Screenshot 2021-04-14 at 20 36 08" src="https://user-images.githubusercontent.com/16212751/114761642-1125a380-9d61-11eb-8105-a3ade9bf428d.png">

This will emit Xcode warnings:

<img width="256" alt="Screenshot 2021-04-14 at 20 35 23" src="https://user-images.githubusercontent.com/16212751/114761582-fa7f4c80-9d60-11eb-93a5-066d8067ce68.png">

* `--silent`

Don't show any output

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
