import SwiftUI

struct ContentView: View {
    private var howManyQuestions = 10
    @State private var allStates = ["Rock", "Paper", "Scissors"]
    @State private var opposedRandomMove = Int.random(in: 0..<3)
    @State private var questionNumber = 1
    @State private var isPresent = false
    @State private var isCorrect = false
    @State private var correctAnswers = 0
    
    func checkWhetherAnswerCorrect(state: String){
        let opposedMove = allStates[opposedRandomMove]
        switch opposedMove {
            case "Rock": isCorrect = state == "Paper"
            case "Paper": isCorrect = state == "Scissors"
            default: isCorrect = state == "Rock"
        }
    }
    
    var body: some View {
        ZStack{
            Color.black
            VStack(spacing: 20) {
                Text("Rock, Paper and Scissors")
                    .font(.title).bold().padding()
                Text("Question \(questionNumber)/10: Computer's move is \(allStates[opposedRandomMove]) ").font(.title3).bold()
                ForEach(0..<allStates.count, id: \.self){index in
                    Button {
                        isPresent = true
                        checkWhetherAnswerCorrect(state: allStates[index])
                        if(isCorrect){
                            correctAnswers += 1
                        }
                    } label: {
                        Image(allStates[index])
                    }.alert(isPresented: $isPresent){
                        if questionNumber == 10 {
                            return Alert(
                                title: Text("Done"),
                                message: Text("Your score: \(correctAnswers)"),
                                dismissButton: .default(Text("OK"), action: {
                                    isPresent = false
                                    questionNumber = 1
                                    opposedRandomMove = Int.random(in: 0..<3)
                                })
                            )
                        } else {
                            return Alert(
                                title: Text(isCorrect ? "You win" : "You lose"),
                                message: Text("Number of correct answer: \(correctAnswers)"),
                                dismissButton: .default(Text("OK"), action: {
                                    isPresent = false
                                    questionNumber += 1
                                    opposedRandomMove = Int.random(in: 0..<3)
                                })
                            )
                        }
                    } 
                }
            }.foregroundColor(.white)
        }
    }
}
