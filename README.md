# Xcode Dead Strings



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

/* no_dead_string */
"my_string_key_1" = "...";
```
