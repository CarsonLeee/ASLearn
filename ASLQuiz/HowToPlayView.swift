import SwiftUI

struct HowToPlayView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color(#colorLiteral(red: 0, green: 40/255, blue: 63/255, alpha: 1)), Color(#colorLiteral(red: 0, green: 57/255, blue: 89/255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("How to Play")
                    .font(.custom("Poppins-Bold", size: 36))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, alignment: .center)

                VStack(alignment: .leading, spacing: 20) { // Increased spacing
                    Text("Welcome to ASLearn!")
                        .font(.custom("Poppins-SemiBold", size: 22))
                        .foregroundColor(Color(#colorLiteral(red: 0.4, green: 0.8, blue: 1, alpha: 1)))
                        .padding(.top, 10)
               
                    Text("Improve your knowledge of the American Sign Language (ASL) alphabet through a series of interactive games.")
                        .font(.custom("Poppins-Regular", size: 18))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.bottom, 30)
                

                    GameInstructionView(title: "Gesture Guess", description: "Identify ASL signs from images in a multiple-choice quiz.")
                        .padding(.bottom, 30)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)

                    GameInstructionView(title: "Sign Sculptor", description: "Replicate ASL signs using your camera to match displayed letters.")
                }
                .padding(.horizontal)
                .padding(.bottom, 20)

                Spacer()

                Button(action: {
                    viewModel.currentScreen = .home
                }) {
                    Text("Back")
                        .font(.custom("Poppins-Medium", size: 22))
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 102/255, blue: 255/255, alpha: 1)))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(#colorLiteral(red: 30/255, green: 30/255, blue: 30/255, alpha: 0.8)))
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
    }
}

struct GameInstructionView: View {
    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.custom("Poppins-SemiBold", size: 22))
                .foregroundColor(Color(#colorLiteral(red: 0.4, green: 0.8, blue: 1, alpha: 1)))

            Text(description)
                .font(.custom("Poppins-Regular", size: 18))
                .foregroundColor(.white.opacity(0.9))
        }
    }
}

struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView(viewModel: AppViewModel())
    }
}
