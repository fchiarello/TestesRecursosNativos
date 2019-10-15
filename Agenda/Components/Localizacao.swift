//
//  Localizacao.swift
//  Agenda
//
//  Created by Fellipe Ricciardi Chiarello on 10/10/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import MapKit

class Localizacao: NSObject, MKMapViewDelegate {
    
    func converteEnderecoEmCoordenadas(endereco: String, local: @escaping(_ local:CLPlacemark) -> Void) {
        let conversor = CLGeocoder()
        conversor.geocodeAddressString(endereco) { (listaDeLocalizacoes, error) in
            if let localizacao = listaDeLocalizacoes?.first {
                local(localizacao)
            }
        }
    }
    
    func configuraPino(titulo: String, localizacao:CLPlacemark, cor:UIColor?, icone:UIImage?) -> Pino {
        let pino = Pino(coordenada: localizacao.location!.coordinate)
        pino.title = titulo
        pino.color = cor
        pino.icon = icone
        
        return pino
    }
    
    func configuraBotaoLocalizacaoAtual(mapa:MKMapView) -> MKUserTrackingButton {
        let botao = MKUserTrackingButton(mapView: mapa)
        botao.frame.origin.x = 10
        botao.frame.origin.y = 10
        return botao
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is Pino {
            let annotatioView = annotation as! Pino
            var pinoView = mapView.dequeueReusableAnnotationView(withIdentifier: annotatioView.title!) as? MKMarkerAnnotationView
            pinoView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotatioView.title!)
            
            pinoView?.annotation = annotatioView
            pinoView?.glyphImage = annotatioView.icon
            pinoView?.markerTintColor = annotatioView.color
            
            return pinoView
        }
        return nil
    }
}
