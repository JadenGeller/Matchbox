//
//  AnyParser.swift
//  Parsley
//
//  Created by Jaden Geller on 10/13/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

import Parsley
import Spork

public class InputStream<Token>: BooleanType {
    public let state: ParseState<Token>
    public var error: ParseError?
    public let delimiter: Parser<Token, ()>
    
    public var boolValue: Bool {
        return error == nil
    }
    
    func match<Result>(parser: Parser<Token, Result>) -> Result? {
        do { return try dropLeft(delimiter, parser).parse(state) }
        catch let x as ParseError { error = x } catch { }
        return nil
    }
    
    convenience public init<Sequence: SequenceType where Sequence.Generator.Element == Token>(_ sequence: Sequence) {
        self.init(sequence, delimiter: none())
    }
    
    convenience public init<Sequence: SequenceType where Sequence.Generator.Element == Token>(sequence: Sequence) {
        self.init(sequence, delimiter: none())
    }
    
    convenience public init<Ignore, Sequence: SequenceType where Sequence.Generator.Element == Token>(_ sequence: Sequence, delimiter: Parser<Token, Ignore>) {
        self.init(ParseState(bridgedFromGenerator: sequence.generate()), delimiter: delimiter)
    }
    
    convenience public init<Ignore, Sequence: SequenceType where Sequence.Generator: ForkableGeneratorType, Sequence.Generator.Element == Token>(_ sequence: Sequence, delimiter: Parser<Token, Ignore>) {
        self.init(ParseState(forkableGenerator: sequence.generate()), delimiter: delimiter)
    }
    
    private init<Ignore>(_ state: ParseState<Token>, delimiter: Parser<Token, Ignore>) {
        self.state = state
        self.delimiter = delimiter.discard()
    }
}

/// A stream type that can be used to parse text, ignoring whitespace by default
public class TextStream: InputStream<Character> {
    
    public init<Ignore>(_ string: String, delimiter: Parser<Character, Ignore>) {
        super.init(ParseState(forkableGenerator: string.characters.generate()), delimiter: delimiter)
    }
    
    convenience init(_ string: String, ignoreWhitespace: Bool = true) {
        self.init(string, delimiter: ignoreWhitespace ? many(within(" \n")).discard() : none())
    }
}
