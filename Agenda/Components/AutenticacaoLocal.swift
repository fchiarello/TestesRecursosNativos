//
//  AutenticacaoLocal.swift
//  Agenda
//
//  Created by Fellipe Ricciardi Chiarello on 15/10/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import LocalAuthentication

class AutenticacaoLocal: NSObject {
    
    func autorizaUsuario(completion: @escaping(_ autenticado: Bool) -> Void) {
        var error:NSError?
        
        let contexto = LAContext()
        if contexto.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error){
            contexto.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Ação necessita de autenticação.") { (resposta, error) in
                completion(resposta)
            }
        }
    }
    

}
