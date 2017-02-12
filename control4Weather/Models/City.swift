//
//  City.swift
//  control4Weather
//
//  Created by Justin Wright on 2/10/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import Foundation

struct City {
  let country: String
  let id: String
  let location: Location
  let name: String
  let state: String
  let stateAbbreviation: String
  
  init(country: String, id: Int, location: Location, name: String, state: String, stateAbbreviation: String){
    self.country = country
    self.id = "\(id)"
    self.location = location
    self.name = name
    self.state = state
    self.stateAbbreviation = stateAbbreviation
  }
}

struct Location {
  let lattitude: Double
  let longitude: Double
}
