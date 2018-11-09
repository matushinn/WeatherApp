//
//  City.swift
//  WeatherApp
//
//  Created by 大江祥太郎 on 2018/11/04.
//  Copyright © 2018年 shotaro. All rights reserved.
//

import Foundation
import SwiftyJSON

class City {
    let id: String
    let title: String
    
    init(city: JSON) {
        id = city["id"].stringValue
        title = city["title"].stringValue
    }
}
