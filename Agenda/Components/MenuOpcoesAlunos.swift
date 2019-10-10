//
//  MenuOpcoesAlunos.swift
//  Agenda
//
//  Created by Fellipe Ricciardi Chiarello on 10/10/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit

enum acoesActionSheet {
    case sms
    case ligacao
    case waze
    case mapa
}

class MenuOpcoesAlunos: NSObject {
    
    func configuraMenuOpcoesAluno(completion:@escaping(_ opcao: acoesActionSheet) -> Void) -> UIAlertController{
        let menu = UIAlertController(title: "Antenção", message: "Selecione uma opção.", preferredStyle: .actionSheet)
        
        let sms = UIAlertAction(title: "Enviar SMS", style: .default) { (acao) in
            completion(.sms)
        }
        menu.addAction(sms)
        
        let ligacao = UIAlertAction(title: "Ligar", style: .default) { (acao) in
            completion(.ligacao)
        }
        menu.addAction(ligacao)
        
        let waze = UIAlertAction(title: "Abrir Waze", style: .default) { (acao) in
            completion(.waze)
        }
        menu.addAction(waze)
        
        let mapa = UIAlertAction(title: "Abrir Mapa", style: .default) { (acao) in
            completion(.mapa)
        }
        menu.addAction(mapa)
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        menu.addAction(cancelar)
        
        return menu
    }
    
    
    
}
