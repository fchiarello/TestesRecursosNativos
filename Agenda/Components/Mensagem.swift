//
//  Mensagem.swift
//  Agenda
//
//  Created by Fellipe Ricciardi Chiarello on 10/10/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit
import MessageUI

class Mensagem: NSObject, MFMessageComposeViewControllerDelegate {
    //MARK: - Metodos
    
    func configuraSMS(_ aluno: Aluno) -> MFMessageComposeViewController? {
        if MFMessageComposeViewController.canSendText() {
            let componenteMensagem = MFMessageComposeViewController()
            guard let numeroAluno = aluno.telefone else { return componenteMensagem }
            componenteMensagem.recipients = [numeroAluno]
            componenteMensagem.messageComposeDelegate = self
            
            return componenteMensagem
        }
            return nil
    }
    
    
    //MARK: - MessageComposeDelegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        
        
        controller.dismiss(animated: true, completion: nil)
    }

}
