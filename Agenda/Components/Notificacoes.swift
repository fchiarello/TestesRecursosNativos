//
//  Notificacoes.swift
//  Agenda
//
//  Created by Fellipe Ricciardi Chiarello on 10/10/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit

class Notificacoes: NSObject {
    
    func exibeNotificacaoDeMediaDosAlunos(dicionarioDeMedia:Dictionary<String, Any>) -> UIAlertController? {
        if let media = dicionarioDeMedia["media"] as? String {
            let alerta = UIAlertController(title: "Atenção", message: "a média geral dos alunos é: \(media)", preferredStyle: .alert)
            let botao = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alerta.addAction(botao)
            
            return alerta
            
        }
        return nil
    }
}
