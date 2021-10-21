//
//  ViewController.swift
//  Screens
//
//  Created by Сергей Васильков on 25.09.2021.
//

import UIKit

class RootViewController: UITableViewController {
    
    
    @IBOutlet var rootTableView: UITableView!
    
    private let noteCellReuseIdentifier = "noteCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Notes"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rootTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        rootTableView.reloadData()
    }
    
}

private extension RootViewController {
    func setup() {
        rootTableView.delegate = self
        rootTableView.dataSource = self
    }
}

extension RootViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotesStorage.shared.notes.count  }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
                                                        noteCellReuseIdentifier, for: indexPath) as? RootTableViewCell  else {
            fatalError("The dequeued cell is not an instance of RootTableViewCell.")
        }
        let tempLabel : String? = NotesStorage.shared.notes[indexPath.row].title
        cell.label!.text = tempLabel!
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let noteViewController = segue.destination as? NoteViewController else { return }
        guard let id = segue.identifier,
              let identifier = SegueIdentifier(rawValue: id) else { return }
        
        switch identifier {
        case .addNote:
            let notesCount = NotesStorage.shared.notes.count
            NotesStorage.shared.append(note: .init(title: "Note \(notesCount + 1)", content: ""))
            noteViewController.recievedIndex = NotesStorage.shared.notes.count - 1
            
        case .editNote:
            noteViewController.recievedIndex = rootTableView.indexPathForSelectedRow!.row
        }
    }
}

// delete by swipe
extension RootViewController {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            NotesStorage.shared.removeNoteAtIndex(indexPath.row)
            rootTableView.reloadData()
        }
    }
}
