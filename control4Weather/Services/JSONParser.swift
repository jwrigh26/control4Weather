//
//  JSONParser.swift
//  control4Weather
//
//  Created by Justin Wright on 2/10/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import Foundation

open class JSONParser {
  
  public func parseJSON(_ data: Data)  -> (Any?, Error?) {
    do {
      let fixedData = fixedJSONData(data)
      let parseResults = try JSONSerialization.jsonObject(with: fixedData, options: [])
      
      if let dictionary = parseResults as? Dictionary<String, Any?> {
        return(dictionary, nil)
      } else if let array = parseResults as? [Dictionary<String, Any?>] {
        return(array, nil)
      }else{
        return(nil, nil)
      }
      
    } catch let parseError {
      return(nil, parseError)
    }
  }
  
  fileprivate func fixedJSONData(_ data: Data) -> Data {
    guard let jsonString = String(data: data, encoding: String.Encoding.utf8) else { return data }
    let fixedString = jsonString.replacingOccurrences(of: "\\'", with: "'")
    if let fixedData = fixedString.data(using: String.Encoding.utf8) {
      return fixedData
    } else {
      return data
    }
  }
}
