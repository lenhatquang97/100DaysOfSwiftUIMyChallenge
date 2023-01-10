import SwiftUI
struct FlagImage: View {
    var path: String
    var body: some View {
        Image("\(path)@2x")
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var numsOfCorrect = 0
    @State private var numsOfQuestions = 0
    
    @State private var isRotating = [0.0, 0.0, 0.0]
    @State private var fadeOut = [false, false, false]
    @State private var animationAmount = [1.0, 1.0, 1.0]
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            numsOfCorrect += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        showingScore = true
        numsOfQuestions += 1
        if numsOfQuestions == 8 {
            scoreTitle = "Done! You have answered 8 questions"
        }
    }
    
    func askQuestion() {
        for i in 0...2 {
            fadeOut[i] = false
            animationAmount[i] = 1.0
        }
        if numsOfQuestions == 8 {
            numsOfCorrect = 0
            numsOfQuestions = 0
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func handleBlur(_ number: Int){
        if number == 0 {
            fadeOut[1] = true
            fadeOut[2] = true
        } else if number == 1 {
            fadeOut[0] = true
            fadeOut[2] = true
        } else if number == 2 {
            fadeOut[0] = true
            fadeOut[1] = true
        }
    }

    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            VStack(spacing: 15){
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                VStack {
                    Text("Question \(numsOfQuestions)/8: Tap the flag of").foregroundColor(.white).font(.subheadline.weight(.heavy))

                    Text(countries[correctAnswer]).foregroundColor(.white).font(.largeTitle.weight(.semibold))

                }
                ForEach(0..<3) { number in
                    Button {
                       flagTapped(number) 
                        withAnimation{
                            isRotating[number] += 360.0
                        }
                        withAnimation(Animation.easeOut(duration: 0.6)){
                            handleBlur(number)
                        }
                        withAnimation {
                            animationAmount[number] -= 0.25
                        }
                    } label: {
                        FlagImage(path: countries[number])
                    }.rotation3DEffect(.degrees(isRotating[number]), axis: (x: 0, y: 1, z: 0))
                        .opacity(fadeOut[number] ? 0.25 : 1)
                        .scaleEffect(animationAmount[number])
                }
            }
        }.alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Score: \(numsOfCorrect)")
                .foregroundColor(.white)
                .font(.title.bold())
        }
    }
}
