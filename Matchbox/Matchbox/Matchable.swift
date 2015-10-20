//
//  Literate.swift
//  Parsley
//
//  Created by Jaden Geller on 10/14/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

// MARK: Protocols

import Parsley

/// A type whose value can be initialized via a matcher.
public protocol MatchInitializable {
    typealias Token
    static var matcher: Parser<Token, Self> { get }
}

/// A type whose value can be verified via a matcher.
public protocol MatchVerifiable {
    typealias Token
    var matcher: Parser<Token, Self> { get }
}

// MARK: Operators

infix operator ->> { associativity left }

/**
    Matches a token of type `Result` from the input stream and assigns it to `inout result`.

    Parameter stream: The input stream from which to parse.
    Parameter result: The `var` of type `Result` that ought will be assigned to with the parsed value.

    Returns: The parsed stream for easy chaining of matchers.
*/
public func ->><Result: MatchInitializable>(stream: InputStream<Result.Token>, inout result: Result!) -> InputStream<Result.Token> {
    result = stream.match(Result.matcher)
    return stream
}

/**
    Matches a token of type `Result` from the input stream and discards it.

    Parameter stream: The input stream from which to parse.
    Parameter type: The type of result to match.

    Returns: The parsed stream for easy chaining of matchers.
*/
public func ->><Result: MatchInitializable>(stream: InputStream<Result.Token>, type: Result.Type) -> InputStream<Result.Token> {
    stream.match(Result.matcher)
    return stream
}

/**
    Matches the specific token `expected` from the input stream.

    Parameter stream: The input stream from which to parse.
    Parameter exprected: The value which must be parsed for the matcher to succeed.

    Returns: The parsed stream for easy chaining of matchers.
*/
public func ->><Expected: MatchVerifiable>(stream: InputStream<Expected.Token>, expected: Expected) -> InputStream<Expected.Token> {
    stream.match(expected.matcher)
    return stream
}

// MARK: Parsers

/**
    Creates a parser that will parse a value of type `Result`.

    Parameter type: The type of result to match.
*/
public func type<Result: MatchInitializable>(type: Result.Type) -> Parser<Result.Token, Result> {
    return Result.matcher
}

