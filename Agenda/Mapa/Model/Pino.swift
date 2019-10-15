//
//  Pino.swift
//  Agenda
//
//  Created by Fellipe Ricciardi Chiarello on 15/10/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import MapKit

class Pino: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    var title: String?
    var icon: UIImage?
    var color: UIColor?
    
    init(coordenada:CLLocationCoordinate2D) {
        self.coordinate = coordenada
        
    }
    
    
}
