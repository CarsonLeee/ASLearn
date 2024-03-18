import SwiftUI
import FirebaseFirestore
import Combine

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
    // Removed the local @State private var score = 0
    @State private var timeRemaining = 10
    @State private var currentQuestion: Question?
    @State private var options: [String] = []
    @State private var selectedOption: String? = nil
    @State private var answerIsCorrect: Bool? = nil
    @State private var showCorrectAnswerAnimation = false
    @State private var isTimerRunning = true
    @ObservedObject var viewModel: AppViewModel

    private let db = Firestore.firestore()
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(stops: [
                .init(color: Color.black, location: 0),
                .init(color: Color(#colorLiteral(red: 0, green: 40/255, blue: 63/255, alpha: 1)), location: 0.4),
                .init(color: Color(#colorLiteral(red: 0, green: 40/255, blue: 63/255, alpha: 1)), location: 0.5),
                .init(color: Color(#colorLiteral(red: 0, green: 57/255, blue: 89/255, alpha: 1)), location: 1)
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text("Score: \(viewModel.score)") // Bind directly to viewModel.score
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.medium)
                    Spacer()
                    Text("Time: \(timeRemaining)")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.medium)
                }
                .padding()
                
                Spacer()
                
                // Display the current question
                if let question = currentQuestion, let imageUrl = URL(string: question.imageUrl) {
                    Text("What alphabet is this?")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding()
                        .fontWeight(.bold)
                    
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable().scaledToFit()
                        case .failure:
                            Image(systemName: "xmark.circle")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 200, height: 200)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(20)
                    .padding(.bottom, 50)
                    
                }
                
                // Display answer options
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        self.selectAnswer(option)
                    }) {
                        Text(option)
                            .foregroundColor(Color(hex: "#0066ff")) // Use the hex initializer for text color
                            .font(.title)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(self.backgroundColorForOption(option)) // Use dynamic background color based on selection
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 4)
                }


                
                Spacer()
            }
        }
        .onAppear {
                self.startGame()
            }
            .onReceive(timer) { _ in
                if self.isTimerRunning && self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else if self.timeRemaining == 0 {
                    viewModel.currentScreen = .score // Correctly using viewModel for navigation
                    self.timer.upstream.connect().cancel()
                }
            }
        }

    
    func backgroundColorForOption(_ option: String) -> Color {
        // Before any selection, return the initial color
        guard let selected = selectedOption else {
            return Color(hex: "#030e14") // Ensure this is the default color before selection
        }

        // After selection, determine if the option is correct or incorrect
        if option == currentQuestion?.correctAnswer && showCorrectAnswerAnimation {
            return .green // Correct answer
        } else if option == selected {
            return showCorrectAnswerAnimation ? .red : Color(hex: "#030e14") // Incorrect selection, but maintains the same color scheme
        }

        // For unselected options, maintain the initial color
        return Color(hex: "#030e14")
    }

    
    func selectAnswer(_ answer: String) {
        isTimerRunning = false
        selectedOption = answer
        answerIsCorrect = answer == currentQuestion?.correctAnswer
        showCorrectAnswerAnimation = true
        
        // Delay for showing correct or incorrect answer
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.answerIsCorrect == true {
                self.viewModel.score += 1 // Update score in viewModel
                self.proceedToNextQuestionAfterDelay()
            } else {
                self.viewModel.currentScreen = .score
            }
        }
    }
    
    func proceedToNextQuestionAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Change this to 1 second
            self.showCorrectAnswerAnimation = false
            self.selectedOption = nil
            self.isTimerRunning = true
            self.fetchRandomQuestion()
        }
    }
    
    func fetchRandomQuestion() {
        db.collection("questions").getDocuments { snapshot, error in
            if let error = error {
                print("Firestore fetch error: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("No documents found in Firestore 'questions' collection.")
                return
            }
            
            let questions = documents.compactMap { document -> Question? in
                try? document.data(as: Question.self)
            }
            
            if let randomQuestion = questions.randomElement() {
                self.currentQuestion = randomQuestion
                
                // Generate three random options that do not include the correct answer
                var letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }
                letters.removeAll { $0 == randomQuestion.correctAnswer } // Remove the correct answer from possibilities
                
                var options = letters.shuffled().prefix(3) // Take three random letters
                options.append(randomQuestion.correctAnswer) // Add the correct answer
                self.options = options.shuffled() // Shuffle the options including the correct answer
                
                self.timeRemaining = 10 // Reset the timer
            }
        }
    }

    
    func colorForOption(_ option: String) -> Color {
        if showCorrectAnswerAnimation {
            if option == currentQuestion?.correctAnswer {
                return .green // Highlight correct answer in green
            } else if option == selectedOption {
                return .red // Show selected incorrect answer in red
            }
        }
        return .white // Default color for options
    }
    

    func startGame() {
        viewModel.score = 0
        selectedOption = nil
        answerIsCorrect = nil
        showCorrectAnswerAnimation = false
        isTimerRunning = true
        timeRemaining = 10
        fetchRandomQuestion()
    }
}

extension View {
    func flashing(isActive: Bool) -> some View {
        self.modifier(FlashingModifier(isActive: isActive))
    }
}

struct FlashingModifier: ViewModifier {
    var isActive: Bool
    
    func body(content: Content) -> some View {
        if isActive {
            return AnyView(content.opacity(0).animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)).opacity(1))
        } else {
            return AnyView(content)
        }
    }
}

struct Question: Identifiable, Codable {
    var id: String?
    var imageUrl: String
    var correctAnswer: String
    var options: [String]
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: AppViewModel())
    }
}
