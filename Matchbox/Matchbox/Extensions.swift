//
//  Extensions.swift
//  Parsley
//
//  Created by Jaden Geller on 10/14/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

import Parsley

extension String: MatchInitializable, MatchVerifiable {
    public static var matcher: Parser<Character, String> {
        return many1(letter()).stringify()
    }
    
    public var matcher: Parser<Character, String> {
        return string(self).replace(self)
    }
}

extension Int: MatchInitializable, MatchVerifiable {
    public static var matcher: Parser<Character, Int> {
        return appending(
            optional(within("+-").stringify(), otherwise: ""),
            many1(digit()).stringify()
        ).map { Int($0)! }
    }
    
    public var matcher: Parser<Character, Int> {
        return sequence(
            many(token("0")),
            string(String(self)),
            many(token("0"))
        ).replace(self)
    }
}

extension Double: MatchInitializable, MatchVerifiable {
    public static var matcher: Parser<Character, Double> {
        return appending(
            optional(within("+-").stringify(), otherwise: ""),
            many1(digit()).stringify(),
            optional(appending(
                character(".").stringify(),
                many1(digit()).stringify()
            ), otherwise: "")
        ).map { Double($0)! }
    }
    
    public var matcher: Parser<Character, Double> {
        var value = String(abs(self)).characters
        if value.first == "0" { value = value.dropFirst() } // Remove leading zero
        
        return sequence(
            { () -> Parser<Character, ()> in
                if self > 0 {
                    return optional(token("+")).discard()
                } else if self < 0 {
                    return token("-").discard()
                } else {
                    return optional(within("+-")).discard()
                }
            }().printAll("sign"),
            many(token("0")).printAll("leading zeros").discard(),
            sequenced(value.map(token)).printAll("value").discard(),
            many(token("0")).discard()
        ).replace(self)
    }
}

extension Float: MatchInitializable, MatchVerifiable {
    public static var matcher: Parser<Character, Float> {
        return Double.matcher.map(Float.init)
    }
    
    public var matcher: Parser<Character, Float> {
        return Double(self).matcher.map(Float.init)
    }
}