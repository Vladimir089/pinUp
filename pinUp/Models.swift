//
//  Models.swift
//  pinUp
//
//  Created by Владимир Кацап on 05.08.2024.
//

import Foundation


struct Plant: Codable {
    var image: Data
    var name: String
    var variety: String
    var period: String
    
    var temp: String
    var humidity: String
    var soil: String
    
    var history: [PlantHistory]
    
    init(image: Data, name: String, variety: String, period: String, temp: String, humidity: String, soil: String, history: [PlantHistory]) {
        self.image = image
        self.name = name
        self.variety = variety
        self.period = period
        self.temp = temp
        self.humidity = humidity
        self.soil = soil
        self.history = history
    }
}


struct PlantHistory: Codable {
    var date: Date
    var action: String
    var indexImage: Int
    
    init(date: Date, action: String, indexImage: Int) {
        self.date = date
        self.action = action
        self.indexImage = indexImage
    }
}




//Машины

struct Equipment: Codable {
    var image: Data
    var name: String
    var price: Int
    var status: String
    
    init(image: Data, name: String, price: Int, status: String) {
        self.image = image
        self.name = name
        self.price = price
        self.status = status
    }
}



