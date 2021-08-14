//
//  model.swift
//  weatherApp
//
//  Created by Антон Сивцов on 20.04.2021.
//

import UIKit
import SwiftyJSON

// MARK: - City
struct City: Codable {
    // MARK: - Properties
    /// City temperature
    let temp: Double
    /// City pressure
    let pressure: Int
    /// City humidity
    let humidity: Int
    /// date
    let dt: Date
    /// Name of the city
    let name: String
    /// Weather icon
    let iconString: String
    /// icon URL
    var iconURL: URL? { URL(string: "https://openweathermap.org/img/wn/\(iconString)@2x.png") }

    // MARK: - Init
    init(json: SwiftyJSON.JSON) {
        self.dt = Date(timeIntervalSince1970: json["dt"].doubleValue)
        self.name = json["name"].stringValue
        self.temp = json["main"]["temp"].doubleValue
        self.pressure = json["main"]["pressure"].intValue
        self.humidity = json["main"]["humidity"].intValue
        self.iconString = json["weather"].arrayValue.first?["icon"].stringValue ?? ""
    }
}
