//
//  NotesStorage.swift
//  Screens
//
//  Created by Сергей Васильков on 25.09.2021.
//

import Foundation

class NotesStorage {
    static let shared = NotesStorage()
    
    private let notesFilename = "notes"
    
    private var directoryUrl: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private var notesFileUrl: URL {
        directoryUrl.appendingPathComponent(notesFilename)
    }
    
    private var fileManager: FileManager {
        FileManager.default
    }
    
    private (set) var notes: [NoteModel] = [] {
        didSet {
            save()
        }
    }
    
    private init() {
        load()
    }
    
    private func getStorage() -> Int {
        return notes.count
    }
}

extension NotesStorage {
    public func save() {
        do {
            let serialized = try JSONEncoder().encode(notes)
            try serialized.write(to: notesFileUrl)
        } catch {
            fatalError()
        }
    }
    
    private func load() {
        do {
            guard fileManager.fileExists(atPath: notesFileUrl.path) else { return }
            
            if let data = fileManager.contents(atPath: notesFileUrl.path) {
                let deserialized = try JSONDecoder().decode([NoteModel].self, from: data)
                notes = deserialized
            }
        } catch {
            fatalError()
        }
    }
}

extension NotesStorage {
    @discardableResult
    func append(note: NoteModel) -> Bool {
        var notes = self.notes
        notes.append(note)
        self.notes = notes
        return true
    }
    
    @objc func updateNoteAtIndex(_ index: Int, title: String, content: String) {
        guard index >= 0, index < notes.count else { return }
        
        var notesTemp = notes
        notesTemp[index] = .init(title: title,content: content)
        self.notes = notesTemp
    }
    
    func removeNoteAtIndex(_ index: Int) {
        guard index >= 0, index < notes.count else { return }
        
        var notes = notes
        notes.remove(at: index)
        self.notes = notes
    }
    
}
