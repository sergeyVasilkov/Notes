//
//  NoteViewController.swift
//  Screens
//
//  Created by Сергей Васильков on 28.09.2021.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteContent: UITextView!
    
  
    var noteContentPlaceholder = "Put your text there ..."
    var recievedIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTitle.text = NotesStorage.shared.notes[recievedIndex].title
        noteTitle.delegate = self
        
        noteContent.text = NotesStorage.shared.notes[recievedIndex].content
        noteContent.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.appInBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        placeholderOn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        placeholderOn()
    }
    override func viewWillDisappear(_ animated: Bool) {
        if noteContent.text != noteContentPlaceholder {
            NotesStorage.shared.updateNoteAtIndex(recievedIndex, title: noteTitle.text!, content: noteContent.text)
        }
        
        noteTitle.resignFirstResponder()
        setDefaultTitleIfEmplty()
        placeholderOn()
    }
}

// пришлось разделить на две функции для корректной работы
extension NoteViewController {
    func placeholderOn(){
        if noteContent.text.isEmpty{
            noteContent.text = noteContentPlaceholder
            noteContent.textColor = UIColor.lightGray
            noteContent.returnKeyType = .done
        }
    }
    func placeholderOff(){
        if noteContent.text == noteContentPlaceholder {
            noteContent.text.removeAll()
            noteContent.textColor = UIColor.black
        }
    }
}

extension NoteViewController : UITextViewDelegate, UITextFieldDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderOff()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderOn()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        setDefaultTitleIfEmplty()
    }
}



extension NoteViewController{
    //не теряем данные когда юзер сворачивает приложение
    @objc func appInBackground(){
        NotesStorage.shared.updateNoteAtIndex(recievedIndex,title: noteTitle.text!, content: noteContent.text)
        NotesStorage.shared.save()
    }
    // если заголовок оставляют пустым, то заменить на стандартный
    func setDefaultTitleIfEmplty () {
        let tempContent = NotesStorage.shared.notes[recievedIndex].content
        if NotesStorage.shared.notes[recievedIndex].title.isEmpty{
            NotesStorage.shared.updateNoteAtIndex(recievedIndex, title: "Note \(recievedIndex+1)", content: tempContent)
        } else {
            NotesStorage.shared.updateNoteAtIndex(recievedIndex, title: noteTitle.text!, content: tempContent)
            print (NotesStorage.shared.notes[recievedIndex].title)
        }
    }
}
