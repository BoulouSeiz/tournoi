//
//  ClasseViewController.swift
//  TournoiATP
//
//  Created by François LIEURY on 16/03/2018.
//  Copyright © 2018 François LIEURY. All rights reserved.
//

import UIKit
import CoreData

class ClasseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
  
  var classes : [Groupe] = [] 
  
  //MARK: Créer TablView Classe
  
  @IBOutlet weak var classeTableViewOutlet: UITableView!

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return classes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = classeTableViewOutlet.dequeueReusableCell(withIdentifier: "cellClasse", for: indexPath)
    
    let classe = classes[indexPath.row]
    
    cell.textLabel?.text = classe.classe
    
    return cell
    
  }
  
  // Aller chercher CoreData
  func getData() {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    do {
      classes = try context.fetch(Groupe.fetchRequest())
    } catch {
      print("Fetching Failed")
    }
    
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
    return 44
    
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    
    return true
  
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    if editingStyle == .delete {
      
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      
      let cell_selected = classes[indexPath.row]
      
      annulerSuppressionLabelOutlet.text = cell_selected.classe
      
      // Context CoreData
      context.delete(cell_selected)
      (UIApplication.shared.delegate as! AppDelegate).saveContext()
      
      do {
        classes = try context.fetch(Groupe.fetchRequest())
      } catch {
        print("Fetching Failed")
      }
      
      classeTableViewOutlet.reloadData()
      
      boutonAnnulerSuppressionOutlet.isHidden = false
      annulerSuppressionLabelOutlet.isHidden = false
      
    }
  }
  
  func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    
    return "RETIRER"
    
  }
  
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let moveClasse = classes[sourceIndexPath.item]
    classes.remove(at: sourceIndexPath.item)
    classes.insert(moveClasse, at: destinationIndexPath.item)
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "matchClasse", sender: self)
  }
  
  //MARK: Supprimer une classe
  
  @IBOutlet weak var supprimerClasseOutlet: UIBarButtonItem!
  
  @IBAction func supprimerClasseAction(_ sender: UIBarButtonItem) {
    if isEditing {
      
      sender.image = #imageLiteral(resourceName: "poubelle_fermee_40")
      isEditing = false
      modifier()
      annulerSuppressionLabelOutlet.isHidden = true
      boutonAnnulerSuppressionOutlet.isHidden = true
      
    } else {
      
      sender.image = #imageLiteral(resourceName: "poubelle_fermee_40")
      isEditing = true
      modifier()
     
    }
  }
  
  func modifier() {
    
    self.classeTableViewOutlet.isEditing = !self.classeTableViewOutlet.isEditing
    
  }
  
  
  // Annuler la suppression
  
  @IBOutlet weak var annulerSuppressionLabelOutlet: UILabel!
  
  @IBOutlet weak var boutonAnnulerSuppressionOutlet: UIButton!
  
  @IBAction func boutonAnnulerSuppressionAction(_ sender: UIButton) {
    annulerSuppressionClasse ()
    boutonAnnulerSuppressionOutlet.isHidden = true
    annulerSuppressionLabelOutlet.isHidden = true
  }
  
  func annulerSuppressionClasse() {
    
    //MARK: Test CoreData
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let classe = Groupe(context: context)
    classe.classe = annulerSuppressionLabelOutlet.text!
    
    // Save DataCore
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
    // get the data frome CoreData
    
    getData()
    
    // Reload the TableView
    
    classeTableViewOutlet.reloadData()
    
    annulerSuppressionLabelOutlet.text = ""
  }
  
  
  //MARK: Ajouter une classe
  
  @IBOutlet weak var ajouterClasseOutlet: UIBarButtonItem!
  
  @IBAction func ajouterClasseAction(_ sender: UIBarButtonItem) {
    if isEditing {
      ajoutClasse()
      sender.image = #imageLiteral(resourceName: "ajoutAdd_40")
      isEditing = false
      
    } else {
      ajoutClasseTermine()
      sender.image = #imageLiteral(resourceName: "undo_40")
      isEditing = true
      
    }
  }
  
  func ajoutClasse(){
    
    ajouterClasseTextFieldOutlet.isHidden = true
    boutonValiderAjouterClasseTextFieldOutlet.isHidden = true
    
  }
  
  func ajoutClasseTermine(){
    
    ajouterClasseTextFieldOutlet.isHidden = false
    boutonValiderAjouterClasseTextFieldOutlet.isHidden = false
    
  }
  
  
  @IBOutlet weak var ajouterClasseTextFieldOutlet: UITextField!
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    
    valideButtonActionStatu()
    
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    valideButtonActionStatu()
    
  }
  
  // Empêche d'ajouter une classe "nul" > Rend actif le bouton.
  
  private func valideButtonActionStatu() {
    
    let text = ajouterClasseTextFieldOutlet.text ?? ""
    boutonValiderAjouterClasseTextFieldOutlet.isEnabled = !text.isEmpty
    
  }
  
  @IBOutlet weak var boutonValiderAjouterClasseTextFieldOutlet: UIButton!
  
  @IBAction func boutonValiderAjouterClasseTextFieldAction(_ sender: UIButton) {
    
    insertNouvelleClasse()
    
  }
  
  func insertNouvelleClasse () {
    
    //MARK: Test CoreData
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let classe = Groupe(context: context)
    classe.classe = ajouterClasseTextFieldOutlet.text!
    
    // Save DataCore
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
    ajouterClasseTextFieldOutlet.text = ""
    boutonValiderAjouterClasseTextFieldOutlet.isEnabled = false
    view.endEditing(true)
    
    // get the data frome CoreData
    
    getData()
    
    // Reload the TableView
    
    classeTableViewOutlet.reloadData()

  }

  // Fermer le clavier après avoir inscrit un nom et des points >>> CLIQUER SUR LE BOUTON « RETOUR »
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    ajouterClasseTextFieldOutlet.resignFirstResponder()
    
    return true
    
  }
  
  // 2ème façon de fermer le clavier après avoir inscrit son prénom... >>> TOUCHER L’ECRAN EN DEHORS DU CLAVIER
  override func touchesBegan(_ touches: Set<UITouch>,with event: UIEvent?) {
    
    ajouterClasseTextFieldOutlet.resignFirstResponder()
    
  }

    override func viewDidLoad() {
        super.viewDidLoad()
      
      valideButtonActionStatu()
      
      classeTableViewOutlet.delegate = self
      classeTableViewOutlet.dataSource = self
      
      ajouterClasseTextFieldOutlet.delegate = self
      
      ajouterClasseTextFieldOutlet.isHidden = true
      boutonValiderAjouterClasseTextFieldOutlet.isHidden = true

      annulerSuppressionLabelOutlet.isHidden = true
      boutonAnnulerSuppressionOutlet.isHidden = true
      
      ajouterClasseOutlet.image =  #imageLiteral(resourceName: "ajoutAdd_40")
      supprimerClasseOutlet.image = #imageLiteral(resourceName: "poubelle_fermee_40")
      
    }
  
  override func viewWillAppear(_ animated: Bool) {
    // Get the data frome CoreData
    getData()
    // Reload the TableView
    classeTableViewOutlet.reloadData()
  }
}
