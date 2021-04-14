# Xcode Dead Strings

## Options

### `--xcode-warnings`

For use as an Xcode build phase:

<img width="540" alt="Screenshot 2021-04-14 at 20 36 08" src="https://user-images.githubusercontent.com/16212751/114761642-1125a380-9d61-11eb-8105-a3ade9bf428d.png">

This will emit Xcode warnings:

<img width="256" alt="Screenshot 2021-04-14 at 20 35 23" src="https://user-images.githubusercontent.com/16212751/114761582-fa7f4c80-9d60-11eb-93a5-066d8067ce68.png">



## Limitations

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
