//
//  ContentView.swift
//  WordScrambleHackingWithSwiftProject
//
//  Created by Shubham on 1/12/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var userScore = 0
        
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your words", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            
            
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK") {
                    
                }
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Score: \(userScore)")
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Restart game") {
                        resetGame()
                        startGame()
                    }
                }
            }
        }
    }
    
    func addNewWord() {
        
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard newWord.count > 0 else { return }
        guard answer != rootWord else {
            wordError(title: "Word not original", message: "Be more original")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }


        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        userScore += 1
        newWord = ""
    }
    
    func resetGame() {
        usedWords.removeAll()
        newWord = ""
        userScore = 0
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8) {
                let allWords = startWords.components(separatedBy: "\n")
                
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Could not locate the start.txt file from bundle")
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

#Preview {
    ContentView()
}


//        List {
//            Text("Static Row")
//
//            ForEach(people, id: \.self) {
//                Text($0)
//            }
//
//            Text("Static Row")
//        }


//        List(people, id: \.self) {
//            Text("Dynamic row \($0)")
//        }

//        List {
//            Section("Section 1") {
//                Text("Static row 1")
//                Text("Static row 2")
//            }
//
//            Section("Section 2") {
//                ForEach(0..<5) { num in
//                    Text("Hello \(num)")
//                }
//            }
//
//            Section("Section 3") {
//                Text("Static row 3")
//                Text("Static row 4")
//            }
//        }
//        .listStyle(.grouped)
