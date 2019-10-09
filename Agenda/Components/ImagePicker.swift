//
//  ImagePicker.swift
//  Agenda
//
//  Created by Fellipe Ricciardi Chiarello on 09/10/19.
//  Copyright © 2019 Alura. All rights reserved.
//

import UIKit

enum MenuOpcoes {
    case camera
    case biblioteca
}

protocol ImagePickerFotoSelecionada {
    func ImagePickerFotoSelecionada(_ foto: UIImage)
}


class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Atributos
    
    var delegate: ImagePickerFotoSelecionada?
    
    //MARK: Métodos
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let foto = info[UIImagePickerControllerOriginalImage] as! UIImage
        delegate?.ImagePickerFotoSelecionada(foto)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func menuOpcoes(completion:@escaping(_ opcao: MenuOpcoes) -> Void) -> UIAlertController {
        let menu = UIAlertController(title: "Atenção!!", message: "Selecione uma opção!", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Tirar Foto", style: .default) { (acao) in
            completion(.camera)
        }
        menu.addAction(camera)
        
        let biblioteca = UIAlertAction(title: "Acessar biblioteca", style: .default) { (acao) in
            completion(.biblioteca)
        }
        menu.addAction(biblioteca)
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        menu.addAction(cancelar)
        
        return menu
        
    }
    
    
    
}
