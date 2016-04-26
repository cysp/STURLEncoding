//: Playground - noun: a place where people can play

import Cocoa

import STURLEncoding


let encoded = STURLEncoding.encode(string: "hello/and,things=foo;hi")
STURLEncoding.decode(string: encoded)



let components = try STURLQueryStringEncoding.components(string: "foo=bar&foo=baz&bar=quux")
components.allKeys()
components["foo"]
components.stringForKey("foo")
components.stringsForKey("foo")
components.stringForKey("bar")
components.stringsForKey("bar")
components.allKeys().flatMap { key in
    [key] + components.stringsForKey(key)!
}


let components2 = try STURLQueryStringEncoding.components(string: "foo")
components2.allKeys().flatMap { key in
    [key] + components2.stringsForKey(key)!
}


let mutablecomponents = STMutableURLQueryStringComponents()
mutablecomponents.dictionaryRepresentationWithOptions([])
mutablecomponents.addString("a", forKey: "a")
mutablecomponents.dictionaryRepresentationWithOptions([])
mutablecomponents.addString("b", forKey: "a")
mutablecomponents.dictionaryRepresentationWithOptions([])

STURLQueryStringEncoding.queryString(components: mutablecomponents)
mutablecomponents.setString("z", forKey: "a")
STURLQueryStringEncoding.queryString(components: mutablecomponents)
mutablecomponents.setString("a", forKey: "z")
STURLQueryStringEncoding.queryString(components: mutablecomponents)
