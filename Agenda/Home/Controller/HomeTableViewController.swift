//
//  HomeTableViewController.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit
import CoreData
import SafariServices

class HomeTableViewController: UITableViewController, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    
    //MARK: - Variáveis
    
    let searchController = UISearchController(searchResultsController: nil)
    var gerenciadorDeResultados: NSFetchedResultsController<Aluno>?
    var contexto: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    var alunoViewController:AlunoViewController?
    let mensagem = Mensagem()
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuraSearch()
        self.recuperaAluno()
    }
    
    // MARK: - Métodos
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editar" {
            alunoViewController = segue.destination as? AlunoViewController
        }
    }
    func configuraSearch() {
        self.searchController.searchBar.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
    }
    
    func recuperaAluno(_ filtro:String = ""){
        let pesquisaAluno: NSFetchRequest<Aluno> = Aluno.fetchRequest()
        let ordenaPorNome = NSSortDescriptor(key: "nome", ascending: true)
        pesquisaAluno.sortDescriptors = [ordenaPorNome]
        
        if verificaFiltro(filtro) {
            pesquisaAluno.predicate = filtraAluno(filtro)
        }
        
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaAluno, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
                gerenciadorDeResultados?.delegate = self
        do {
            try gerenciadorDeResultados?.performFetch()
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func filtraAluno(_ filtro:String) -> NSPredicate {
        return NSPredicate(format: "nome CONTAINS %@", filtro)
    }
    
    func verificaFiltro(_ filtro:String) -> Bool {
        if filtro.isEmpty {
            return false
        }
        return true
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            //implementar metodo
            break
        default:
            tableView.reloadData()
        }
    }
    
    //MARK: - Actions
    
    @objc func abrirActionSheet(_ longPress:UILongPressGestureRecognizer) {
        if longPress.state == .began {
            guard let alunoSelecionado = gerenciadorDeResultados?.fetchedObjects?[(longPress.view?.tag)!] else { return }
            let menu = MenuOpcoesAlunos().configuraMenuOpcoesAluno { (opcao) in
                switch opcao{
                case .sms:
                    if let componenteMensagem = self.mensagem.configuraSMS(alunoSelecionado){
                        componenteMensagem.messageComposeDelegate = self.mensagem
                        self.present(componenteMensagem, animated: true, completion: nil)
                    }
                    break
                case .ligacao:
                    guard let numeroAluno = alunoSelecionado.telefone else { return }
                    if let urlFone = URL(string: "tel://\(numeroAluno)"), UIApplication.shared.canOpenURL(urlFone){
                        UIApplication.shared.open(urlFone, options: [:], completionHandler: nil)
                    }
                    break
                case .waze:
                    if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
                        guard let enderecoDoAluno = alunoSelecionado.endereco else { return }
                        Localizacao().converteEnderecoEmCoordenadas(endereco: enderecoDoAluno) { (localizacaoEncontrada) in
                            let latitude = String(describing: localizacaoEncontrada.location!.coordinate.latitude)
                            let longitude = String(describing: localizacaoEncontrada.location!.coordinate.longitude)
                            let urlWaze: String = "waze://?ll=\(latitude),\(longitude)&navigate=yes"
                            UIApplication.shared.open(URL(string: urlWaze)!, options: [:], completionHandler: nil)
                        }
                    }
                    break
                case .mapa:
                    let mapa = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapa") as! MapaViewController
                    mapa.aluno = alunoSelecionado
                    self.navigationController?.pushViewController(mapa, animated: true)
                    break
                case .abrirPaginaWeb:
                    if let urlDoAluno = alunoSelecionado.site {
                        var urlFormatada = urlDoAluno
                        
                        if !urlFormatada.hasPrefix("http://"){
                            urlFormatada = String(format: "http://%@", urlFormatada)
                        }
                        guard let url = URL(string: urlFormatada) else {return}
                        let safariViewController = SFSafariViewController(url: url)
                        self.present(safariViewController, animated: true, completion: nil)
                    }
                    break
                }
            }
            self.present(menu, animated: true, completion: nil)
        }

    }
    
    @IBAction func buttonCalculaMedia(_ sender: UIBarButtonItem) {
        guard let listaDeAlunos = gerenciadorDeResultados?.fetchedObjects else { return }
        CalculaMediaAPI().calculaMediaGeralDosAlunos(alunos: listaDeAlunos, sucesso: { (dicionario) in
            if let alerta = Notificacoes().exibeNotificacaoDeMediaDosAlunos(dicionarioDeMedia: dicionario){
                self.present(alerta, animated: true, completion: nil)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func buttonLocalizacaoAtual(_ sender: UIBarButtonItem) {
        let mapa = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapa") as! MapaViewController
        
        navigationController?.pushViewController(mapa, animated: true)
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let contadorDeAlunos = gerenciadorDeResultados?.fetchedObjects?.count else{return 0}
        return contadorDeAlunos
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula-aluno", for: indexPath) as! HomeTableViewCell
        cell.tag = indexPath.row
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(abrirActionSheet))
        
        guard let aluno = gerenciadorDeResultados?.fetchedObjects![indexPath.row] else { return cell }
        
        cell.configuraCelula(aluno)
        cell.addGestureRecognizer(longPress)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            AutenticacaoLocal().autorizaUsuario { (autenticado) in
                if autenticado {
                    DispatchQueue.main.async {
                        guard let alunoSelecionado = self.gerenciadorDeResultados?.fetchedObjects?[indexPath.row] else { return }
                        self.contexto.delete(alunoSelecionado)
                        do {
                            try self.contexto.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let alunoSelecionado = gerenciadorDeResultados?.fetchedObjects![indexPath.row] else { return }
        alunoViewController?.aluno = alunoSelecionado
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let nomeAluno =  searchBar.text else { return }
        recuperaAluno(nomeAluno)
        tableView.reloadData()
    }
    
}
