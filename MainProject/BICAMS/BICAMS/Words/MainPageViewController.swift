//
//  ViewController.swift
//  SiriDemo
//
//  Created by Balázs Bojrán on 2017. 04. 12..
//  Copyright © 2017. Balázs Bojrán. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

let database = CKContainer.default().publicCloudDatabase

let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

var patient: Patient?

var listOfWords = [
    "Állat": ["aligátor", "antilop", "arapapagáj", "bernáthegyi", "bagoly", "bivaly", "boa", "cet", "cinege", "cickány", "cápa", "csalogány", "csimpánz", "csuka", "denevér", "delfin", "elefánt", "egér", "énekesmadár", "farkas", "füstifecske", "feketerigó", "flamingó", "gepárd", "galamb", "gekkó", "gyík", "giliszta", "hal", "hattyú", "házimacska", "holló", "iguána", "jégmadár", "jávorszarvas", "kanári", "kolibri", "kaméleon", "leopárd", "lazac", "ló", "lepke", "leopárd", "medve", "mókus", "mamut", "majom", "makákó", "krokodil", "nádirigó", "nyúl", "nyest", "nyuszt", "oroszlán", "ocelot", "oposszum", "orángután", "óriáskígyó", "ökörszem", "ökör", "őz", "ponty", "pisztráng", "pacsirta", "pillangó", "ponty", "pele", "pók", "rétisas", "róka", "sün(disznó)", "sólyom", "sas", "sikló", "szöcske", "szarvas", "szalamandra", "tücsök", "tigris", "tőkehal", "tyúk", "uhu", "uszkár", "üregi nyúl", "vörösbegy", "vakond", "vízisikló", "zebra", "zerge", "zsiráf"
    ],
    "Tömegközlekedési eszköz": ["Busz", "Villamos", "Troli", "Hév", "Vonat", "Repülő", "Komp", "Hajó"],
    "Bútor": ["Szék", "Asztal", "Éjjeliszekrény", "Komód", "Polc", "Konyhapult", "TV állvány", "Dohányzóasztal"],
    "Gyümölcs": ["Alma", "Narancs", "Mandarin", "Körte", "Cseresznye", "Meggy", "Málna", "Ribizli", "Banán", "Sárgabarack", "Őszibarack", "Szilva"]
]

class MainPageViewController: UIViewController {
    
    @IBOutlet weak var selectPatientButton: UIButton!
    
    @IBOutlet weak var addNewPatientButton: UIButton!
    
    var fetchedResultsController: NSFetchedResultsController<Word>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        populateWords()
    }
    
    @IBAction func navigateToHomePage(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func populateWords() {
        
        var words = Array<Word>()
        
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "category", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext!,
            sectionNameKeyPath: "category",
            cacheName: nil
        )
        
        try? fetchedResultsController?.performFetch()
        
        if let fetchedWords = fetchedResultsController?.fetchedObjects {
            
            if fetchedWords.count <= 0 {
                
                for item in listOfWords {
                    
                    for w in item.value {
                        
                        let newWord = Word(context: managedObjectContext!)
                        
                        newWord.data = w
                        newWord.category = item.key
                        
                        words.append(newWord)
                    }
                }
                
                try? managedObjectContext?.save()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "selectPatientSegue" {
            
            segue.destination.navigationItem.title = "Betegek"
            
        } else {
            
            if let senderButton = (sender as? UIButton) {
                
                segue.destination.navigationItem.title = senderButton.currentTitle
            }
        }
    }
}

