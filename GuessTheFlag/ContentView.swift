//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Irina Zherebtsova on 5/19/24.
//

import SwiftUI

struct ContentView: View {
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
    @State private var countries = allCountries.shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var showingResults = false
    @State private var scoreTitle = ""
    @State private var result = 0
    @State private var round = 1

    @State private var selectedFlag = -1
    
    let maxRounds = 8
    
    struct FlagImage: View {
        let name: String
        
        var body: some View {
            Image(name)
                .clipShape(.capsule)
                .shadow(radius: 5)
        }
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(name: countries[number])
                        }
                        .rotation3DEffect(.degrees(selectedFlag == number ? 360 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
                        .animation(.default, value: selectedFlag)
                        .opacity(selectedFlag == -1 || selectedFlag == number ? 1 : 0.25)
                       // .scaleEffect(selectedFlag == -1 || selectedFlag == number ? 1 : 0.25)
                     //   .saturation(selectedFlag == -1 || selectedFlag == number ? 1 : 0)
                    //    .blur(radius: selectedFlag == -1 || selectedFlag == number ? 0 : 3)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(result)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(result).")
        }
        .alert("Game over!", isPresented: $showingResults) {
            Button("Start Again", action: newGame)
        } message: {
            Text("Your final score was \(result).")
        }
    }
    
    func flagTapped(_ number:Int) {
        selectedFlag = number
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            result += 1
        } else {
            let needsThe = ["UK", "US"]
            let theirAnswer = countries[number]

            if needsThe.contains(theirAnswer) {
                scoreTitle = "Wrong! That's the flag of the \(theirAnswer)."
            } else {
                scoreTitle = "Wrong! That's the flag of \(theirAnswer)."
            }
            
            if result > 0 {
                result -= 1
            }
        }
        
        if round == maxRounds {
            showingResults = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.remove(at: correctAnswer)
        if round == maxRounds {
            newGame()
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        round += 1
        selectedFlag = -1
        
    }
    
    func newGame() {
        result = 0
        round = 0
        countries = Self.allCountries
        askQuestion()
        
    }
    
}
#Preview {
    ContentView()
}
