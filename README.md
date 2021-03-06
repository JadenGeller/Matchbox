# Matchbox

Matchbox is designed to allow for super simple parsing of input. For example, Matchbox works well for parsing command line arguments, or for parsing a CSV file. Even though Matchbox is intended to be used a simple token parser, it is built atop (Parsley)[http://github.com/jadengeller/parsley], a recursive descent parsing library, so it is well suited even for for parsing complex regular expressions and nested structures.

Here's what it looks like to parse command line arguments with Matchbox:
```swift
// The user input we're going to parse
let input = TextStream("./myprogram filename -s 350 450")

// Skip the program name
input ->> sequence(
    string("./"),
    many1(letter())
)

// Parse the filename
var filename: String!
guard input ->> filename else { fatalError("Expected filename") }

// Default values must be implicitly unwrapped optionals too
var width: Int! = 0
var height: Int! = 0

// Parse the flags
var flag: Flag!
while input ->> flag {
    switch flag.identifier {
    case "s":
        // Parse the width and height after the size flag
        guard input ->> width ->> height else { fatalError("Expected arguments after flag s") }
    default:
        fatalError("Unexpected flag \"\(flag.identifier)\"")
    }
}
```
where `Flag` is defined as
```swift
struct Flag: MatchInitializable {
    let name: Character 
    
    public static var matcher: Parser<Character, Flag> {
        return dropLeft(token("-"), letter()).map(Flag.init)
    }
}
```
You can build your own `MatchInitializable` (set the value of a variable by parsing it) and `MarchVerifiable` (assert that the value of the variable is correct) types by building `Parsley` parsers. Pretty neat, huh!

Note that Matchbox's default `TextStream` ignores whitespace, but this can be changed by adding `ignoresWhitespace: false` to the initializer. Futher, note that `TextStream` is actually a subclass of `InputStream<Token>`, which can be used to parse arbitrary types of `SequenceType`s.
