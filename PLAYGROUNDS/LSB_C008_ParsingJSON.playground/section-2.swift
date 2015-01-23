import UIKit

/*
//  Parsing JSON
//
//  An example of creating a typed wrapper around an
//  Objective-C API
//
//  Suggested Reading:
//  http://www.objc.io/snippets/11.html
//  http://chris.eidhof.nl/posts/json-parsing-in-swift.html
/===================================*/


typealias JSONDictionary = [String:AnyObject]

// some JSON
var json: JSONDictionary = [
  "stat": "ok",
  "blogs": [
    "blog": [
      [
        "id" : 73,
        "name" : "Bloxus test",
        "needspassword" : true,
        "url" : "http://remote.bloxus.com/"
      ],
      [
        "id" : 74,
        "name" : "Manila Test",
        "needspassword" : false,
        "url" : "http://flickrtest1.userland.com/"
      ]
    ]
  ]
]



/*------------------------------------/
//  Dictionary to NSData
/------------------------------------*/

enum SerializationResult {
  case Success(NSData)
  case Error(String)
}

func encodeJSON(input: JSONDictionary) -> SerializationResult {
  var error: NSError? = nil
  if let data = NSJSONSerialization.dataWithJSONObject(input,
    options: .allZeros, error: &error) {
      return SerializationResult.Success(data)
  } else {
    let msg = error.map { e in e.description } ?? "JSON serialization error."
    return SerializationResult.Error(msg)
  }
  
}

let serializationResult = encodeJSON(json)
switch serializationResult {
case let .Success(data):
  data
  "Success"
case let .Error(error):
  "Serialization Error: \(error)"
}



/*------------------------------------/
//  NSData into JSONDictionary
/------------------------------------*/

enum ParseResult {
  case Success(JSONDictionary)
  case Error(String)
}

func decodeJSON(data: NSData) -> ParseResult {
  var error: NSError? = nil
  if let dict = NSJSONSerialization.JSONObjectWithData(data,
    options: .allZeros, error: &error) as? JSONDictionary {
      return ParseResult.Success(dict)
  } else {
    let msg = error.map { e in e.description } ?? "JSON parse error."
    return ParseResult.Error(msg)
  }
}

switch serializationResult {
case let .Success(data):
  let parseResult = decodeJSON(data)
  switch parseResult {
  case let .Success(dict):
    dict
    "Success"
  case let .Error(error):
    "Parse Error: \(error)"
  }
case let .Error(error):
  "Serialization Error: \(error)"
}




