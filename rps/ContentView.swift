//
//  ContentView.swift
//  rps
//
//  Created by Joel Martinez on 9/6/22.
//

import SwiftUI

struct RPSOptionsView: View {
    let option: String
    let callBack: (() -> Void)
    
    var body: some View {
        Button(option) {
            callBack()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .font(.system(size: 70.0))
        .padding()
    }
}

struct ContentView: View {
    
    enum PlayOption: String {
        case rock = "🪨"
        case paper = "📜"
        case scissors = "✂️"
        static let allOptions = [rock, paper, scissors]
    }
    
    let maxTurns = 10
    
    @State private var challengeChoice: PlayOption = PlayOption.allOptions.randomElement()!
    @State private var userChoice: PlayOption?
    @State private var userShouldWin = Bool.random()
    @State private var score = 0
    @State private var turn = 1
    @State private var showingAlert = false
    
    var body: some View {
        ZStack {
            Color.teal
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("You need to \(shouldWinOrLooseString(userShouldWin)) against \(challengeChoice.rawValue)")
                    .font(.largeTitle)
                    .padding()
                    .multilineTextAlignment(.center)
                
                Text("Score: \(score)")
                Text("Turn \(turn) of \(maxTurns)")
                    .font(.caption)
                
                Spacer()
                
                ForEach(PlayOption.allOptions, id:\.self) { option in
                    RPSOptionsView(option: option.rawValue) {
                        userChoice = option
                        score = didWin(option) ? score + 1 : score - 2
                        showingAlert = true
                    }
                }
                .alert(didWin(userChoice ?? PlayOption.rock) ? "Correct" : "Wrong", isPresented: $showingAlert) {
                    let buttonTitle = canKeepPlaying() ? "Continue" : "Play again"
                    let action = canKeepPlaying() ? askQuestion : restartGame
                    Button(buttonTitle, action: action)
                } message: {
                    let message = canKeepPlaying() ? "Your score is \(score)" : "Your final score is \(score)"
                    Text(message)
                }
                Spacer()
            }
        }
    }
    
    func shouldWinOrLooseString(_ shouldWin: Bool) -> String {
        shouldWin ? "Win" : "Loose"
    }
    
    func canKeepPlaying() -> Bool {
        turn < maxTurns
    }
    
    func restartGame() {
        score = 0
        turn = 1
        askQuestion()
    }
    
    func askQuestion() {
        challengeChoice = PlayOption.allOptions.randomElement()!
        userShouldWin.toggle()
        turn += 1
    }
    
    func didWin(_ withOption: PlayOption) -> Bool {
        withOption == correctUserSelection(userShouldWin, against: challengeChoice)
    }
    
    func correctUserSelection(_ toWin: Bool, against: PlayOption) -> PlayOption {
        let correctOption: PlayOption
        
        switch against {
        case .rock:
            correctOption = toWin ? .paper : .scissors
        case .paper:
            correctOption = toWin ? .scissors : .rock
        case .scissors:
            correctOption = toWin ? .rock : .paper
        }
        return correctOption
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
