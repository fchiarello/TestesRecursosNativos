//
//  MapaViewController.swift
//  Agenda
//
//  Created by Fellipe Ricciardi Chiarello on 10/10/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import MapKit

class MapaViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapa: MKMapView!
    
    // MARK: - Variaveis
    
    var aluno: Aluno?
    lazy var localizacao = Localizacao()
    lazy var gerenciadorLocalizacao = CLLocationManager()
    
    // MARK: - View Lyfe Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = getTitulo()
        verificaAutorizacaoDoUsuario()
        localizacaoInicial()
        mapa.delegate = localizacao
        gerenciadorLocalizacao.delegate = self
    }
    
    // MARK: - Metodos
    
    func getTitulo() -> String {
        return "Localizar Alunos"
    }
    
    func verificaAutorizacaoDoUsuario() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus(){
            case .authorizedWhenInUse:
                let botao = Localizacao().configuraBotaoLocalizacaoAtual(mapa: mapa)
                mapa.addSubview(botao)
                gerenciadorLocalizacao.startUpdatingLocation()
                
                break
            case .notDetermined:
                gerenciadorLocalizacao.requestWhenInUseAuthorization()
                break
            case .denied:
                
                break
            default:
                break
            }
            
        }
    }
    
    func localizarAluno() {
        if let aluno = aluno {
            Localizacao().converteEnderecoEmCoordenadas(endereco: aluno.endereco!) { (localizacaoEncontrada) in
                let pino = Localizacao().configuraPino(titulo: aluno.nome!, localizacao: localizacaoEncontrada, cor: nil, icone: nil)
                
                self.mapa.addAnnotation(pino)
                self.mapa.showAnnotations(self.mapa.annotations, animated: true)
            }
        }
    }
    
    func localizacaoInicial() {
        Localizacao().converteEnderecoEmCoordenadas(endereco: "Caelum - São Paulo") { (localizacaoEncontrada) in
//            let pino = self.configuraPino(titulo: "Caelum", localizacao: localizacaoEncontrada)
            let pino = Localizacao().configuraPino(titulo: "Caelum", localizacao: localizacaoEncontrada, cor: .black, icone: UIImage(named: "icon_caelum"))
            
            let regiao = MKCoordinateRegionMakeWithDistance(pino.coordinate, 1000, 1000)
            self.mapa.setRegion(regiao, animated: true)
            self.mapa.addAnnotation(pino)
            
            self.localizarAluno()
        }
    }
    
    // MARK: - CLLocationManager
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            let botao = Localizacao().configuraBotaoLocalizacaoAtual(mapa: mapa)
            mapa.addSubview(botao)
            gerenciadorLocalizacao.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }

    
}
