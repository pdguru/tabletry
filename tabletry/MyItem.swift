//
//  Item.swift
//  tabletry
//
//  Created by Pramod Guruprasad on 23/10/18.
//  Copyright © 2018 Pramod Guruprasad. All rights reserved.
//

import Foundation

class MyItem {
    
    let id: Int
    let name: String
    let subtitle: String
    let image: String
    let price: Float
    let description: String
    
    init(id: Int, name: String, subtitle: String,
                 image: String, price: Float, description: String){
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.price = price
        self.image = image
        self.description = description
    }
    
}
