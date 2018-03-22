//
//  ViewController.swift
//  TournoiATP
//
//  Created by François LIEURY on 08/03/2018.
//  Copyright © 2018 François LIEURY. All rights reserved.
//

import UIKit

class ClassementViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
  
  @IBOutlet weak var classementTableView: UITableView!
  
  var classements : [Classement] = []
  
  var classementMatch: Groupe?
  
  var modeEnMemoireText: String = ""
  let modeEnMemoire = UserDefaults.standard
  
  @IBOutlet weak var modeMatchSelectionne: UILabel!
  
  func orderTable() {
    
    classements.sort(by: {$0.point > $1.point})
    classementTableView.reloadData()
    
  }
  
  // MARK: Créer la TableView Classement
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return classements.count
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = classementTableView.dequeueReusableCell(withIdentifier: "cellClassementJoueur", for: indexPath)
    let classement = classements[indexPath.row]
    
    cell.textLabel?.text = classement.nom!
    cell.detailTextLabel?.text = "\(classement.point) PTS"
    
    return cell
    
  }
  
  // Aller chercher CoreData
  func getData() {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    do {
    classements = try context.fetch(Classement.fetchRequest())
    } catch {
      print("Fetching Failed")
    }

  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
    return 44
    
  }
  
  // MARK: Ajouter un nouveau joueur
  @IBOutlet weak var ajouterJoueurItemOutlet: UIBarButtonItem!
  
  @IBAction func ajouterJoueurItemAction(_ sender: UIBarButtonItem) {
    
    if isEditing {
      ajoutJoueur()
      sender.image = #imageLiteral(resourceName: "ajoutAdd_40")
      isEditing = false
      annulerSuppressionLabelOutlet.isHidden = true
      boutonAnnulerSuppressionOutlet.isHidden = true
      
    } else {
      ajoutJoueurTermine()
      sender.image = #imageLiteral(resourceName: "undo_40")
      isEditing = true
      annulerSuppressionLabelOutlet.isHidden = true
      boutonAnnulerSuppressionOutlet.isHidden = true
      
    }
  }
  
  /*
   
 */
  
  func ajoutJoueur(){
    
    nomAjouterOutlet.isHidden = true
    pointAjouterOutlet.isHidden = true
    valideButtonOutlet.isHidden = true
    
  }
  
  func ajoutJoueurTermine(){
    
    nomAjouterOutlet.isHidden = false
    pointAjouterOutlet.isHidden = false
    valideButtonOutlet.isHidden = false
    
  }
  
  // MARK: Ajouter des élèves et des points
  @IBOutlet weak var nomAjouterOutlet: UITextField!
  @IBOutlet weak var pointAjouterOutlet: UITextField!
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    if textField.tag == 1 {
      let invalidCharacters = CharacterSet(charactersIn: "-0123456789").inverted
      
      return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
    }
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    
    valideButtonActionStatu()
    
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    valideButtonActionStatu()
    
  }
  
  @IBOutlet weak var valideButtonOutlet: UIButton!
  @IBAction func valideButtonAction(_ sender: UIButton) {
    
    insertNouveauEleve()
    orderTable()
    
  }
  
  func insertNouveauEleve() {
    
    //MARK: Test CoreData
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let classements = Classement(context: context)
    classements.nom = nomAjouterOutlet.text!
    classements.point = Int16(pointAjouterOutlet.text!)!
    
    // Save DataCore
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
    nomAjouterOutlet.text = ""
    pointAjouterOutlet.text = ""
    valideButtonOutlet.isEnabled = false
    view.endEditing(true)
    
    // get the data frome CoreData
    
    getData()
    
    // Reload the TableView
    
    classementTableView.reloadData()
    
  }
  
  // Empêche d'ajouter un élève ou des points "nul" > Rend actif le bouton.
  private func valideButtonActionStatu() {
    
    let text = nomAjouterOutlet.text ?? ""
    let point = pointAjouterOutlet.text ?? ""
    valideButtonOutlet.isEnabled = !text.isEmpty
    valideButtonOutlet.isEnabled = !point.isEmpty
    
  }
  
  // Fermer le clavier après avoir inscrit un nom et des points >>> CLIQUER SUR LE BOUTON « RETOUR »
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    nomAjouterOutlet.resignFirstResponder()
    pointAjouterOutlet.resignFirstResponder()
    
    return true
    
  }
  
  // 2ème façon de fermer le clavier après avoir inscrit son prénom... >>> TOUCHER L’ECRAN EN DEHORS DU CLAVIER
  override func touchesBegan(_ touches: Set<UITouch>,with event: UIEvent?) {
    
    nomAjouterOutlet.resignFirstResponder()
    pointAjouterOutlet.resignFirstResponder()
    
  }
  
  @IBOutlet weak var editItemBoutonSupOutlet: UIBarButtonItem!
  
  @IBAction func editItemBoutonSupAction(_ sender: UIBarButtonItem) {
    
    if isEditing {
      
      sender.image = #imageLiteral(resourceName: "poubelle_fermee_40")
      isEditing = false
      modifier()
      valideButtonEnregistrementAction()
      annulerSuppressionLabelOutlet.isHidden = true
      boutonAnnulerSuppressionOutlet.isHidden = true
      
    } else {
      
      sender.image = #imageLiteral(resourceName: "poubelle_fermee_40")
      isEditing = true
      modifier()
      valideButtonEnregistrementAction()
      annulerSuppressionLabelOutlet.isHidden = true
      boutonAnnulerSuppressionOutlet.isHidden = true
    }
  }
  
  func modifier() {
    
    self.classementTableView.isEditing = !self.classementTableView.isEditing
    
  }
  
  
  // Supprimer des élèves
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    
    let gagnantSlectionne = cellGagnantOutlet.text ?? ""
    let perdantSlectionne = cellPerdantOutlet.text ?? ""
    
    if (gagnantSlectionne.isEmpty) || (perdantSlectionne.isEmpty) {
      editItemBoutonSupOutlet.isEnabled = true
      
      return true
      
    } else if (!gagnantSlectionne.isEmpty) || (!perdantSlectionne.isEmpty) {
      editItemBoutonSupOutlet.isEnabled = false
      
      return false
      
    }
    return true
  }
  
  var pointsEleveSupprime = 0
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
  
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let cell_selected = classements[indexPath.row]
    
    annulerSuppressionLabelOutlet.text = cell_selected.nom
    pointsEleveSupprime = Int(cell_selected.point)
    
    // Context CoreData
    context.delete(cell_selected)
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
      
    do {
      classements = try context.fetch(Classement.fetchRequest())
    } catch {
      print("Fetching Failed")
    }
      
    classementTableView.reloadData()
  
    orderTable()
    
    annulerSuppressionLabelOutlet.isHidden = false
    boutonAnnulerSuppressionOutlet.isHidden = false
  }
  
  
  func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    
    return "RETIRER"
    
  }
  
  // MARK: Annuler la suppression du dernière élève
  
  @IBOutlet weak var annulerSuppressionLabelOutlet: UILabel!
  
  @IBOutlet weak var boutonAnnulerSuppressionOutlet: UIButton!
  
  @IBAction func boutonAnnulerSuppressionAction(_ sender: UIButton) {
    
    annulerSuppressionDernierEleveSupprime ()
    
    annulerSuppressionLabelOutlet.isHidden = true
    boutonAnnulerSuppressionOutlet.isHidden = true
    
    orderTable()
    
  }
  
  // Annuler la suppression du dernier élève supprimé
  
  func annulerSuppressionDernierEleveSupprime () {
  
    //MARK: Test CoreData
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let classements = Classement(context: context)
    classements.nom = annulerSuppressionLabelOutlet.text!
    classements.point = Int16(pointsEleveSupprime)
    
    // Save DataCore
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
    // get the data frome CoreData
    
    getData()
    
    // Reload the TableView
    
    classementTableView.reloadData()
  
  }
  
  
  // MARK: Les actions de la TableView - Gagnant / Perdant

  @IBOutlet weak var cellGagnantOutlet: UILabel!
  @IBOutlet weak var cellPerdantOutlet: UILabel!
  
  var pointsInitiauxGagnant = 0
  var pointsInitiauxPerdant = 0
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

    let defaite = UIContextualAction(style: .destructive, title: "Défaite") { (action, view, completionHandler) in
      
      _ = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      
      let cell_selected = self.classements[indexPath.row]
      
      // Empeche de selectionner 2 joueurs en "perdant"

      let perdant = self.cellPerdantOutlet.text ?? ""
      
      if (perdant.isEmpty) {
        
        self.cellPerdantOutlet.text = cell_selected.nom
        self.pointsInitiauxPerdant = Int(cell_selected.point)
        
        self.annulerSaisiePerdantOutlet.isHidden = false
        self.valideButtonEnregistrementAction()
        
        //MARK: CoreData Delecte
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Context CoreData
        context.delete(cell_selected)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        do {
          self.classements = try context.fetch(Classement.fetchRequest())
        } catch {
          print("Fetching Failed")
        }
      
        self.classementTableView.reloadData()
        
        self.annulerSuppressionLabelOutlet.isHidden = true
        self.boutonAnnulerSuppressionOutlet.isHidden = true

        completionHandler(true)
        print("Défaite")
        
      } else if (!perdant.isEmpty) {
        
        completionHandler(false)
        
      }
      
    }
    
    matchCombienPoint()
    
    defaite.backgroundColor = .orange
    defaite.image = #imageLiteral(resourceName: "defaite_30")
    
    return UISwipeActionsConfiguration(actions: [defaite])
    
  }
  
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let victoire = UIContextualAction(style: .destructive, title: "Victoire") { (action, view, completionHandler) in
      
      //MARK: Test CoreData
      _ = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      
      let cell_selected = self.classements[indexPath.row]
      
      // Empeche de selectionner 2 joueurs en "gagnant"
      
      let gagnant = self.cellGagnantOutlet.text ?? ""
      
      if (gagnant.isEmpty) {

      self.cellGagnantOutlet.text = cell_selected.nom
      self.pointsInitiauxGagnant = Int(cell_selected.point)
      
      self.annulerSaisieGagnantOutlet.isHidden = false
      self.valideButtonEnregistrementAction()
        
      //MARK: CoreData Delecte
        
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
      // Context CoreData
      context.delete(cell_selected)
      (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
      do {
        self.classements = try context.fetch(Classement.fetchRequest())
      } catch {
        print("Fetching Failed")
      }
        
      self.classementTableView.reloadData()
        
      self.annulerSuppressionLabelOutlet.isHidden = true
      self.boutonAnnulerSuppressionOutlet.isHidden = true

        
      completionHandler(true)
      print("Victoire")
        
      } else if (!gagnant.isEmpty) {
        
        completionHandler(false)
        
      }
    }
    
    matchCombienPoint()
    
    victoire.backgroundColor = .green
    victoire.image = #imageLiteral(resourceName: "victoire_30")
    
    return UISwipeActionsConfiguration(actions: [victoire])
    
  }
  
  
  //MARK: Inscrire le score avec le PickerView
  
  @IBOutlet weak var scoreGagnantLabelOutlet: UILabel!
  @IBOutlet weak var selectionScoreGagnantOutlet: UIPickerView!
  
  @IBOutlet weak var scorePerdantLabelOutlet: UILabel!
  @IBOutlet weak var selectionScorePerdantOutlet: UIPickerView!
  

  var scorePicker = Array(0...11)

  func matchCombienPoint() {
    
      scorePicker = Array(0...Int(pointFinMatchSelectionne))
      selectionScoreGagnantOutlet.delegate = self
      selectionScorePerdantOutlet.delegate  = self
      selectionScoreGagnantOutlet.dataSource  = self
      selectionScorePerdantOutlet.dataSource  = self
    
  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    
    return 1
    
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
    if pickerView.tag == 1 {
      
      return scorePicker.count
    }
    
    if pickerView.tag == 2 {
      
      return scorePicker.count
    }
    return 0
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
    if pickerView.tag == 1 {
      return String(describing: scorePicker[row])
    }
    if pickerView.tag == 2 {
      return String(describing: scorePicker[row])
    }
    
    return nil
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    if pickerView.tag == 1 {
      scoreGagnantLabelOutlet.text = String(describing: scorePicker[row])
      valideButtonEnregistrementAction()
    }
    if pickerView.tag == 2 {
      scorePerdantLabelOutlet.text = String(describing: scorePicker[row])
      valideButtonEnregistrementAction()
    }
  }
  
  func remettrePickerGagnant() {
  self.view.endEditing(false)
  selectionScoreGagnantOutlet.selectRow(0, inComponent: 0, animated: true)
  selectionScoreGagnantOutlet.reloadAllComponents()
  }
  
  func remettrePickerPerdant() {
    self.view.endEditing(false)
    selectionScorePerdantOutlet.selectRow(0, inComponent: 0, animated: true)
    selectionScorePerdantOutlet.reloadAllComponents()
  }
  
  // Affichage Gagnant, Score et Gagnant
  @IBOutlet weak var gagnantLabelOutlet: UILabel!
  
  @IBOutlet weak var perdantLabelOutlet: UILabel!
  
  @IBOutlet weak var scoreLabelOutlet: UILabel!
  
  // MARK: Enregistrer un résultat
  
  @IBOutlet weak var annulerSaisieGagnantOutlet: UIButton!
  
  @IBAction func annulerSaisieGagnantAction(_ sender: UIButton) {
    
    //MARK: Test CoreData
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let classements = Classement(context: context)
    classements.nom = cellGagnantOutlet.text!
    classements.point = Int16(pointsInitiauxGagnant)
    
    // Save DataCore
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
    // get the data frome CoreData
    
    getData()
    
    // Reload the TableView
    
    classementTableView.reloadData()
    
    editItemBoutonSupOutlet.isEnabled = true
    annulerSaisieGagnantOutlet.isHidden = true
    
    scoreGagnantLabelOutlet.text = ""
    cellGagnantOutlet.text = ""

    valideButtonEnregistrementAction()
    remettrePickerGagnant()
    orderTable()
    
  }
  
  @IBOutlet weak var annulerSaisiePerdantOutlet: UIButton!
  
  @IBAction func annulerSaisiePerdantAction(_ sender: UIButton) {
    
    //MARK: Test CoreData
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let classements = Classement(context: context)
    classements.nom = cellPerdantOutlet.text!
    classements.point = Int16(pointsInitiauxPerdant)
    
    // Save DataCore
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
    // get the data frome CoreData
    
    getData()
    
    // Reload the TableView
    
    classementTableView.reloadData()
    
    editItemBoutonSupOutlet.isEnabled = true
    annulerSaisiePerdantOutlet.isHidden = true
    
    scorePerdantLabelOutlet.text = ""
    cellPerdantOutlet.text = ""
    
    valideButtonEnregistrementAction()
    remettrePickerPerdant()
    orderTable()
    
  }
  
  //MARK: Empêche d'ajouter un résultat sans joueur et sans résultat
  
  func valideButtonEnregistrementAction() {
    let gagnant = cellGagnantOutlet.text ?? ""
    let perdant = cellPerdantOutlet.text ?? ""
    let scoreGagnantEmpty = scoreGagnantLabelOutlet.text ?? ""
    let scorePerdantEmpty = scorePerdantLabelOutlet.text ?? ""
    
    if (gagnant.isEmpty) || (perdant.isEmpty) || (scoreGagnantEmpty.isEmpty) || (scorePerdantEmpty.isEmpty) || (classementTableView.isEditing){
      enregistrerResultatOutlet.isHidden = true
      } else if (!gagnant.isEmpty) && (!perdant.isEmpty) && (!scoreGagnantEmpty.isEmpty) && (!scorePerdantEmpty.isEmpty) && (!classementTableView.isEditing){
      enregistrerResultatOutlet.isHidden = false
    }
  }
  
  @IBOutlet weak var enregistrerResultatOutlet: UIButton!
  
  @IBAction func enregistrerResultatOutlet(_ sender: UIButton) {
    
    if fenetreConfirmationSwitchOutlet.isOn == true {
      fenetreConfirmation()
    } else {
      enregistrerResultat()
    }
  }
  
  func enregistrerResultat() {
    
    annulerSuppressionLabelOutlet.isHidden = true
    boutonAnnulerSuppressionOutlet.isHidden = true
    
    editItemBoutonSupOutlet.isEnabled = true
    
    tournoiMode()
    
    insertResultatGagnant()
    insertResultatPerdant()
    
    orderTable()
    
    annulerSaisieGagnantOutlet.isHidden = true
    annulerSaisiePerdantOutlet.isHidden = true
    
    enregistrerResultatOutlet.isHidden = true
    
    cellGagnantOutlet.text = ""
    cellPerdantOutlet.text = ""
    
    scoreGagnantLabelOutlet.text = ""
    scorePerdantLabelOutlet.text = ""
    
    remettrePickerGagnant()
    remettrePickerPerdant()
    
    affichageParametreFermee()
    
  }
  
  var pointVictoire: Int = 0
  var pointDefaite: Int = 0
  
  func tournoiMode(){
    
    let scoreGagnant: Int = Int(scoreGagnantLabelOutlet.text!)!
    let scorePerdant: Int = Int(scorePerdantLabelOutlet.text!)!
    
    // Mode VDN
    if segmentModeTournoiOutlet.selectedSegmentIndex == 0 {
          if  scoreGagnant > scorePerdant {
          pointVictoire = Int(stepperVictoireVDNOutlet.value)
          pointDefaite = Int(stepperDefaiteVDNOutlet.value)
          }
          if scoreGagnant < scorePerdant {
          pointVictoire = Int(stepperDefaiteVDNOutlet.value)
          pointDefaite = Int(stepperVictoireVDNOutlet.value)
          }
          if scoreGagnant == scorePerdant {
          pointVictoire = Int(stepperMatchNulVDNOutlet.value)
          pointDefaite = Int(stepperMatchNulVDNOutlet.value)
          }
      }
    
    // Mode TPC
    if segmentModeTournoiOutlet.selectedSegmentIndex == 1 {
          pointVictoire = Int(scoreGagnantLabelOutlet.text!)!
          pointDefaite = Int(scorePerdantLabelOutlet.text!)!
      }
    
    // Mode ATP
    if segmentModeTournoiOutlet.selectedSegmentIndex == 2 {
      let differencePoints = (pointsInitiauxGagnant - pointsInitiauxPerdant)
      
      if  scoreGagnant > scorePerdant {
    switch differencePoints {
      case -99999 ... -11:
        pointVictoire = 6
        pointDefaite = -6
      case -10 ... -6:
        pointVictoire = 5
        pointDefaite = -5
      case -5 ... -1:
        pointVictoire = 4
        pointDefaite = -4
      case 0 ... 4:
        pointVictoire = 3
        pointDefaite = -3
      case 5 ... 9:
        pointVictoire = 2
        pointDefaite = -2
      case 10 ... 99999:
        pointVictoire = 1
        pointDefaite = -1
      default:
        break
        }
      }
      if scoreGagnant < scorePerdant {
        switch differencePoints {
        case -99999 ... -11:
          pointVictoire = -1
          pointDefaite = 1
        case -10 ... -6:
          pointVictoire = -2
          pointDefaite = 2
        case -5 ... -1:
          pointVictoire = -3
          pointDefaite = 3
        case 0 ... 4:
          pointVictoire = -4
          pointDefaite = 4
        case 5 ... 9:
          pointVictoire = -5
          pointDefaite = 5
        case 10 ... 99999:
          pointVictoire = -6
          pointDefaite = 6
        default:
          break
        }
      }
      if scoreGagnant == scorePerdant {
        pointVictoire = 1
        pointDefaite = 1
      }
    }
  }

  func insertResultatGagnant() {
    
    //MARK: Test CoreData
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let classements = Classement(context: context)
    classements.nom = cellGagnantOutlet.text!
    classements.point = Int16(pointsInitiauxGagnant + pointVictoire)
    
    // Save DataCore
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
    // get the data frome CoreData
    
    getData()
    
    // Reload the TableView
    
    classementTableView.reloadData()

  }
  
  func insertResultatPerdant() {
      
      //MARK: Test CoreData
      
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      
      let classements = Classement(context: context)
      classements.nom = cellPerdantOutlet.text!
      classements.point = Int16(pointsInitiauxPerdant + pointDefaite)
      
      // Save DataCore
      
      (UIApplication.shared.delegate as! AppDelegate).saveContext()
      
      // get the data frome CoreData
      
      getData()
      
      // Reload the TableView
      
      classementTableView.reloadData()

  }
 
  
  //MARK: Fenetre de confirmation
  
  @IBOutlet weak var fenetreConfirmationLabelOutlet: UILabel!
  
  @IBOutlet weak var fenetreConfirmationSwitchOutlet: UISwitch!
  
  @IBAction func fenetreConfirmationSwitchAction(_ sender: UISwitch) {
    if (sender.isOn == true) {
      print("Demande de confirmation")
    } else {
      print("Pas de demande de confirmation")
    }
  }
  
  var fenetreInfoLabalMode = ""

  func segmentControlText(){
    if segmentModeTournoiOutlet.selectedSegmentIndex == 0 {
      fenetreInfoLabalMode = "VDN"
      modeMatchSelectionne.text = "Vous êtes en mode : VDN"

    }
    if segmentModeTournoiOutlet.selectedSegmentIndex == 1 {
      fenetreInfoLabalMode = "TPC"
      modeMatchSelectionne.text = "Vous êtes en mode : TPC"

    }
    if segmentModeTournoiOutlet.selectedSegmentIndex == 2 {
      fenetreInfoLabalMode = "ATP"
      modeMatchSelectionne.text = "Vous êtes en mode : ATP"

    }

  }
  
  func fenetreConfirmation() {
    
    // Envoi de l'alerte du message
    segmentControlText()
    
    tournoiMode()
    
    let dialogMessage = UIAlertController(title: "CONFIRMEZ-VOUS?", message: "Mode de tournoi : \(fenetreInfoLabalMode)\nLe gagnant : \(String(describing: cellGagnantOutlet.text!)) - \(pointsInitiauxGagnant) PTS\nLe perdant : \(String(describing: cellPerdantOutlet.text!)) - \(pointsInitiauxPerdant) PTS\nLe score : \(String(describing: scoreGagnantLabelOutlet.text!)) à \(String(describing: scorePerdantLabelOutlet.text!))\n\(String(describing: cellGagnantOutlet.text!)) : \(pointsInitiauxGagnant) + \(pointVictoire) = \(pointsInitiauxGagnant + pointVictoire)\n\(String(describing: cellPerdantOutlet.text!)) : \(pointsInitiauxPerdant) + \(pointDefaite) = \(pointsInitiauxPerdant + pointDefaite)", preferredStyle: .alert)
    
    // Créer un bouton OK avec le gestionnaire d'actions
    let ok = UIAlertAction(title: "OUI", style: .default, handler: { (action) -> Void in
      print("Bouton OUI appuyé")
      self.enregistrerResultat()
    })
    
    // Créer un bouton ANNULER avec le gestionnaire d'actions
    let cancel = UIAlertAction(title: "NON", style: .cancel) { (action) -> Void in
      print("Bouton NON appuyé")
    }
    
    //Ajouter le bouton OK et Annuler au message de la boîte de dialogue
    dialogMessage.addAction(ok)
    dialogMessage.addAction(cancel)
    
    // Présenter un message de dialogue à l'utilisateur
    self.present(dialogMessage, animated: true, completion: nil)
  }

  
  
  //MARK: Bouton affichage Parametre tournoi
  
  @IBOutlet weak var boutonAffichageParametreTournoiOutlet: UIBarButtonItem!
  
  @IBAction func boutonAffichageParametreTournoiAction(_ sender: UIBarButtonItem) {
    
    if isEditing {
      sender.image = #imageLiteral(resourceName: "installing-updates-40")
      affichageParametreFermee()
      isEditing = false

    } else {
      sender.image = #imageLiteral(resourceName: "installing-updates-40")
      affichageParametreOuvert()
      isEditing = true

    }
  }
  
  func affichageParametreOuvert() {
    
    if segmentModeTournoiOutlet.selectedSegmentIndex == 1 || segmentModeTournoiOutlet.selectedSegmentIndex == 2 {
      pointVictoireVDNOutlet.isHidden = true
      pointMatchNulVDNOutlet.isHidden = true
      pointDefaiteVDNOutlet.isHidden = true
      
      stepperVictoireVDNOutlet.isHidden = true
      stepperMatchNulVDNOutlet.isHidden = true
      stepperDefaiteVDNOutlet.isHidden = true
      
      affichageTextVictoireOutlet.isHidden = true
      affichageTextMatchNulOutlet.isHidden = true
      affichageTextDefaiteOutlet.isHidden = true
      
      validerParametreVDNOutlet.isHidden = true
    } else if segmentModeTournoiOutlet.selectedSegmentIndex == 0 {
      
      pointVictoireVDNOutlet.isHidden = false
      pointMatchNulVDNOutlet.isHidden = false
      pointDefaiteVDNOutlet.isHidden = false
      
      stepperVictoireVDNOutlet.isHidden = false
      stepperMatchNulVDNOutlet.isHidden = false
      stepperDefaiteVDNOutlet.isHidden = false
      
      affichageTextVictoireOutlet.isHidden = false
      affichageTextMatchNulOutlet.isHidden = false
      affichageTextDefaiteOutlet.isHidden = false
      
      validerParametreVDNOutlet.isHidden = false
    }
    
    matchEnLabelOutlet.isHidden = false
    pointFinMatchLabelOutlet.isHidden = false
    stepperPointFinMatchOutlet.isHidden = false
    validerPointFinMatchOutlet.isHidden = false
    
    fenetreConfirmationLabelOutlet.isHidden = false
    fenetreConfirmationSwitchOutlet.isHidden = false
    
    segmentModeTournoiOutlet.isHidden = false
    
  }
  
  func affichageParametreFermee() {
    
    if segmentModeTournoiOutlet.selectedSegmentIndex == 1 ||  segmentModeTournoiOutlet.selectedSegmentIndex == 2 {
      pointVictoireVDNOutlet.isHidden = true
      pointMatchNulVDNOutlet.isHidden = true
      pointDefaiteVDNOutlet.isHidden = true
      
      stepperVictoireVDNOutlet.isHidden = true
      stepperMatchNulVDNOutlet.isHidden = true
      stepperDefaiteVDNOutlet.isHidden = true
      
      affichageTextVictoireOutlet.isHidden = true
      affichageTextMatchNulOutlet.isHidden = true
      affichageTextDefaiteOutlet.isHidden = true
      
      validerParametreVDNOutlet.isHidden = true
    } else if segmentModeTournoiOutlet.selectedSegmentIndex == 0 {
      
      pointVictoireVDNOutlet.isHidden = true
      pointMatchNulVDNOutlet.isHidden = true
      pointDefaiteVDNOutlet.isHidden = true
      
      stepperVictoireVDNOutlet.isHidden = true
      stepperMatchNulVDNOutlet.isHidden = true
      stepperDefaiteVDNOutlet.isHidden = true
      
      affichageTextVictoireOutlet.isHidden = true
      affichageTextMatchNulOutlet.isHidden = true
      affichageTextDefaiteOutlet.isHidden = true
      
      validerParametreVDNOutlet.isHidden = true
    }
    
    matchEnLabelOutlet.isHidden = true
    pointFinMatchLabelOutlet.isHidden = true
    stepperPointFinMatchOutlet.isHidden = true
    validerPointFinMatchOutlet.isHidden = true
    
    fenetreConfirmationLabelOutlet.isHidden = true
    fenetreConfirmationSwitchOutlet.isHidden = true
    
    segmentModeTournoiOutlet.isHidden = true
    
  }
  
  //MARK: Nombre de point pour gagner le match
  
  var pointFinMatchSelectionne = 11
  
  @IBOutlet weak var matchEnLabelOutlet: UILabel!
  
  @IBOutlet weak var pointFinMatchLabelOutlet: UILabel!
  
  @IBOutlet weak var stepperPointFinMatchOutlet: UIStepper!
  
  @IBAction func stepperPointFinMatchAction(_ sender: UIStepper) {
    
    pointFinMatchSelectionne = Int(sender.value)
    pointFinMatchLabelOutlet.text = "\(pointFinMatchSelectionne)"
    
    // En mémoire Stepper
    pointEnMemoire.setValue(pointFinMatchSelectionne, forKey: "pointFinMatchSelectionne")
    pointEnMemoire.synchronize()
    
  }
  
  @IBOutlet weak var validerPointFinMatchOutlet: UIButton!
  
  @IBAction func validerPointFinMatchAction(_ sender: UIButton) {
    
    matchCombienPoint()
    
    matchEnLabelOutlet.isHidden = true
    pointFinMatchLabelOutlet.isHidden = true
    stepperPointFinMatchOutlet.isHidden = true
    validerPointFinMatchOutlet.isHidden = true
    
  }
  
  //MARK: Parametre Mode de Tournoi
  
  @IBOutlet weak var segmentModeTournoiOutlet: UISegmentedControl!
  
  @IBAction func segmentModeTournoiAction(_ sender: UISegmentedControl) {
    
    //modeMatchSelectionne.isHidden = false
    
    switch segmentModeTournoiOutlet.selectedSegmentIndex {
    case 0:
      pointVictoireVDNOutlet.isHidden = false
      pointMatchNulVDNOutlet.isHidden = false
      pointDefaiteVDNOutlet.isHidden = false
      stepperVictoireVDNOutlet.isHidden = false
      stepperMatchNulVDNOutlet.isHidden = false
      stepperDefaiteVDNOutlet.isHidden = false
      affichageTextVictoireOutlet.isHidden = false
      affichageTextMatchNulOutlet.isHidden = false
      affichageTextDefaiteOutlet.isHidden = false
      validerParametreVDNOutlet.isHidden = false
      modeMatchSelectionne.text = "Vous êtes en mode : VDN"


    case 1:
      pointVictoireVDNOutlet.isHidden = true
      pointMatchNulVDNOutlet.isHidden = true
      pointDefaiteVDNOutlet.isHidden = true
      stepperVictoireVDNOutlet.isHidden = true
      stepperMatchNulVDNOutlet.isHidden = true
      stepperDefaiteVDNOutlet.isHidden = true
      affichageTextVictoireOutlet.isHidden = true
      affichageTextMatchNulOutlet.isHidden = true
      affichageTextDefaiteOutlet.isHidden = true
      validerParametreVDNOutlet.isHidden = true
      modeMatchSelectionne.text = "Vous êtes en mode : TPC"

    
      let infoAlert = UIAlertController(title: "TPC\nTous les points comptes", message: "Les joueurs gagnent le nombre de point marqué", preferredStyle: .alert)
      
      let okAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil )
      
      infoAlert.addAction(okAlert)
      self.present(infoAlert, animated: true, completion: nil)
      
      
    case 2:
      pointVictoireVDNOutlet.isHidden = true
      pointMatchNulVDNOutlet.isHidden = true
      pointDefaiteVDNOutlet.isHidden = true
      stepperVictoireVDNOutlet.isHidden = true
      stepperMatchNulVDNOutlet.isHidden = true
      stepperDefaiteVDNOutlet.isHidden = true
      affichageTextVictoireOutlet.isHidden = true
      affichageTextMatchNulOutlet.isHidden = true
      affichageTextDefaiteOutlet.isHidden = true
      validerParametreVDNOutlet.isHidden = true
      modeMatchSelectionne.text = "Vous êtes en mode : ATP"

      
      
      let infoAlert = UIAlertController(title: "ATP", message: "", preferredStyle: .alert)
      
      let image = UIImage(named: "explicationATP")
      infoAlert.addImage(image: image!)
      
      let okAlert = UIAlertAction(title: "OK", style: .cancel, handler: nil )
      
      infoAlert.addAction(okAlert)
      self.present(infoAlert, animated: true, completion: nil)
 
    default: break
      
    }
    
    UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "modeGestion")
    
  }
  
  //MARK : Parametre VDN
  
  // Garder en mémoire
  let pointEnMemoire = UserDefaults.standard
  
  @IBOutlet weak var affichageTextVictoireOutlet: UILabel!
  
  @IBOutlet weak var affichageTextMatchNulOutlet: UILabel!
  
  @IBOutlet weak var affichageTextDefaiteOutlet: UILabel!
  
  
  @IBOutlet weak var pointVictoireVDNOutlet: UILabel!
  
  @IBOutlet weak var pointMatchNulVDNOutlet: UILabel!
  
  @IBOutlet weak var pointDefaiteVDNOutlet: UILabel!
  
  
  @IBOutlet weak var stepperVictoireVDNOutlet: UIStepper!
  
  @IBOutlet weak var stepperMatchNulVDNOutlet: UIStepper!
  
  @IBOutlet weak var stepperDefaiteVDNOutlet: UIStepper!
  
  // Nombre de point pour la victoire par défaut
  // En mémoire Stepper
  var pointVictoireVDNSelectionne = 3
  
  @IBAction func stepperVictoireVDNAction(_ sender: UIStepper) {
    
    pointVictoireVDNSelectionne = Int(sender.value)
    pointVictoireVDNOutlet.text = "\(pointVictoireVDNSelectionne)"
    
    // En mémoire Stepper
    pointEnMemoire.setValue(pointVictoireVDNSelectionne, forKey: "pointVictoireVDNSelectionne")
    pointEnMemoire.synchronize()
    
  }
  
  var pointMatchNulVDNSelectionne = 2

  @IBAction func stepperMatchNulVDNAction(_ sender: UIStepper) {
    
    pointMatchNulVDNSelectionne = Int(sender.value)
    pointMatchNulVDNOutlet.text = "\(pointMatchNulVDNSelectionne)"
    
    // En mémoire Stepper
    pointEnMemoire.setValue(pointMatchNulVDNSelectionne, forKey: "pointMatchNulVDNSelectionne")
    pointEnMemoire.synchronize()
    
  }
  
  var pointDefaiteVDNSelectionne = 1
  
  @IBAction func stepperDefaiteVDNAction(_ sender: UIStepper) {
    
    pointDefaiteVDNSelectionne = Int(sender.value)
    pointDefaiteVDNOutlet.text = "\(pointDefaiteVDNSelectionne)"
    
    // En mémoire Stepper
    pointEnMemoire.setValue(pointDefaiteVDNSelectionne, forKey: "pointDefaiteVDNSelectionne")
    pointEnMemoire.synchronize()
  }
  
  
  @IBOutlet weak var validerParametreVDNOutlet: UIButton!
  
  
  @IBAction func validerParametreVDNAction(_ sender: UIButton) {
    
    pointVictoireVDNOutlet.isHidden = true
    pointMatchNulVDNOutlet.isHidden = true
    pointDefaiteVDNOutlet.isHidden = true
    stepperVictoireVDNOutlet.isHidden = true
    stepperMatchNulVDNOutlet.isHidden = true
    stepperDefaiteVDNOutlet.isHidden = true
    affichageTextVictoireOutlet.isHidden = true
    affichageTextMatchNulOutlet.isHidden = true
    affichageTextDefaiteOutlet.isHidden = true
    validerParametreVDNOutlet.isHidden = true
    
    segmentModeTournoiOutlet.isHidden = true
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    cellGagnantOutlet.text = ""
    cellPerdantOutlet.text = ""
    
    cellGagnantOutlet.layer.cornerRadius = 5
    cellPerdantOutlet.layer.cornerRadius = 5
    
    scoreGagnantLabelOutlet.text = ""
    scorePerdantLabelOutlet.text = ""
    
    nomAjouterOutlet.isHidden = true
    pointAjouterOutlet.isHidden = true
    
    valideButtonOutlet.isHidden = true
    
    selectionScoreGagnantOutlet.delegate = self
    selectionScorePerdantOutlet.delegate = self

    selectionScoreGagnantOutlet.tag = 1
    selectionScorePerdantOutlet.tag = 2
    
    classementTableView.delegate = self
    classementTableView.dataSource = self
    
    orderTable()
    
    nomAjouterOutlet.delegate = self
    pointAjouterOutlet.delegate = self
    
    pointAjouterOutlet.tag = 1

    valideButtonActionStatu()

    matchEnLabelOutlet.isHidden = true
    
    pointFinMatchLabelOutlet.isHidden = true
    stepperPointFinMatchOutlet.isHidden = true
    validerPointFinMatchOutlet.isHidden = true
    
    segmentModeTournoiOutlet.isHidden = true
    
    affichageTextVictoireOutlet.isHidden = true
    affichageTextMatchNulOutlet.isHidden = true
    affichageTextDefaiteOutlet.isHidden = true
    
    pointVictoireVDNOutlet.isHidden = true
    pointMatchNulVDNOutlet.isHidden = true
    pointDefaiteVDNOutlet.isHidden = true
    
    stepperVictoireVDNOutlet.isHidden = true
    stepperMatchNulVDNOutlet.isHidden = true
    stepperDefaiteVDNOutlet.isHidden = true
    
    validerParametreVDNOutlet.isHidden = true
    
    annulerSaisieGagnantOutlet.isHidden = true
    annulerSaisiePerdantOutlet.isHidden = true
    
    enregistrerResultatOutlet.isHidden = true
    
    fenetreConfirmationLabelOutlet.isHidden = true
    fenetreConfirmationSwitchOutlet.isHidden = true
    
    annulerSuppressionLabelOutlet.isHidden = true
    boutonAnnulerSuppressionOutlet.isHidden = true

    ajouterJoueurItemOutlet.image = #imageLiteral(resourceName: "ajoutAdd_40")
    editItemBoutonSupOutlet.image = #imageLiteral(resourceName: "poubelle_fermee_40")
    
    boutonAffichageParametreTournoiOutlet.image = #imageLiteral(resourceName: "installing-updates-40")
    
    valideButtonEnregistrementAction()
    
    gagnantLabelOutlet.layer.cornerRadius = 5
    perdantLabelOutlet.layer.cornerRadius = 5
    scoreLabelOutlet.layer.cornerRadius = 5
    
    //modeMatchSelectionne.isHidden = true
        
    // Sauvegarde du Bouton Mode en Haut à droite
    
    if modeEnMemoire.value(forKey: "modeEnMemoire") != nil {
      modeEnMemoireText = modeEnMemoire.value(forKey: "modeEnMemoire") as! String
      modeMatchSelectionne.text = modeEnMemoireText
    }
    
    // En mémoire le Stepper
    
    if pointEnMemoire.value(forKey: "pointVictoireVDNSelectionne") != nil {
      pointVictoireVDNSelectionne = pointEnMemoire.value(forKey: "pointVictoireVDNSelectionne") as! Int
    }
    
    // En mémoire le Stepper
    
    if pointEnMemoire.value(forKey: "pointMatchNulVDNSelectionne") != nil {
      pointMatchNulVDNSelectionne = pointEnMemoire.value(forKey: "pointMatchNulVDNSelectionne") as! Int
    }
    
    // En mémoire le Stepper
    
    if pointEnMemoire.value(forKey: "pointDefaiteVDNSelectionne") != nil {
      pointDefaiteVDNSelectionne = pointEnMemoire.value(forKey: "pointDefaiteVDNSelectionne") as! Int
    }
    
    // En mémoire le Stepper
    
    if pointEnMemoire.value(forKey: "pointFinMatchSelectionne") != nil {
      pointFinMatchSelectionne = pointEnMemoire.value(forKey: "pointFinMatchSelectionne") as! Int
    }
    
    // Valeur de départ du Stepper en fonction de la valeur sauvegardée
    
    stepperVictoireVDNOutlet.value = Double(Int(pointVictoireVDNSelectionne))
    pointVictoireVDNOutlet.text = "\(pointVictoireVDNSelectionne)"
    
    // Valeur de départ du Stepper en fonction de la valeur sauvegardée
    
    stepperMatchNulVDNOutlet.value = Double(Int(pointMatchNulVDNSelectionne))
    pointMatchNulVDNOutlet.text = "\(pointMatchNulVDNSelectionne)"
    
    // Valeur de départ du Stepper en fonction de la valeur sauvegardée
    
    stepperDefaiteVDNOutlet.value = Double(Int(pointDefaiteVDNSelectionne))
    pointDefaiteVDNOutlet.text = "\(pointDefaiteVDNSelectionne)"
    
    // Valeur de départ du Stepper en fonction de la valeur sauvegardée
    
    stepperPointFinMatchOutlet.value = Double(Int(pointFinMatchSelectionne))
    pointFinMatchLabelOutlet.text = "\(pointFinMatchSelectionne)"
    
    // Sauvegarde des données SegmentedControl
    if let value = UserDefaults.standard.value(forKey: "modeGestion") {
      let selectedIndex = value as! Int
      segmentModeTournoiOutlet.selectedSegmentIndex = selectedIndex
    }
        
  }

  override func viewWillAppear(_ animated: Bool) {
    // Get the data frome CoreData
    getData()
    // Ordonner
    orderTable()
    // Reload the TableView
    classementTableView.reloadData()
    // Conserver les points de fin de match
    matchCombienPoint()
    // Inscrire le mode de tournoi en bas d'écran
    segmentControlText()
    modeMatchSelectionne.text = "Vous êtes en mode : \(fenetreInfoLabalMode)"
  }

}
