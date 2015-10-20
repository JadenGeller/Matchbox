# Matchbox

Matchbox is designed to allow for super simple parsing of input. For example, Matchbox works well for parsing command line arguments, or for parsing a CSV file. Even though Matchbox is intended to be used a simple token parser, it is built atop (Parsley)[http://github.com/jadengeller/parsley], a recursive descent parsing library, so it is well suited even for for parsing complex regular expressions and nested structures.

Here's what it looks like to parse command line arguments with Matchbox:
```swift
struct Flag: MatchInitializable {
    let name: Character 
    
    public static var matcher: Parser<Character, Flag> {
        return dropLeft(token("-"), letter()).map(Flag.init)
    }
}

let input = TextStream("./myprogram filename -s 350 450")

// Skip the program name
input ->> sequence(
    string("./"),
    many1(letter())
)

var filename: String!
guard input ->> filename else { fatalError("Expected filename") }

// Default values must be implicitly unwrapped optionals too
var width: Int! = 0
var height: Int! = 0

var flag: Flag!
while input ->> flag {
    switch flag.identifier {
    case "s":
        guard input ->> width ->> height else { fatalError("Expected arguments after flag s") }
    default:
        fatalError("Unexpected flag \"\(flag.identifier)\"")
    }
}
```

Pretty neat, huh!
