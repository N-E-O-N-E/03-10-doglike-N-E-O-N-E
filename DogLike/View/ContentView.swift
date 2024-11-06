import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DogViewModel()
    @AppStorage("likeCounter") var likeCounter: Int = 0
    
    @State private var dislikeButtonPressed: Bool = false
    @State private var dislikeButtonPressedColor: Color = .blue
    @State private var likeButtonPressed: Bool = false
    @State private var likeButtonPressedColor: Color = .blue
    @State private var nameKlick: Bool = false
    @State private var pictureEffect1: Bool = false
    @State private var rotationAngle: Double = 0
    @State private var opacity: Double = 0.0
    @State private var blurRadius: Double = 0
    @State private var dislikeScale: Double = 1.0
    
    var body: some View {
        VStack {
            Spacer()
            Text("DOG LIKE")
                .font(.system(size: 60, weight: .heavy, design: .rounded))
                .foregroundColor(.black)
                .padding()
            
            if let dogImageURL = viewModel.dogImageURL {
                AsyncImage(url: dogImageURL) { image in
                    image
                        .resizable() .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: pictureEffect1 ? 50 : 20))
                        .frame(maxWidth: .infinity, maxHeight: 400)
                        .shadow(color: pictureEffect1 ? .mint : .gray ,
                                radius: pictureEffect1 ? 100 : 10)
                        .padding()
                        .scaleEffect(dislikeScale)
                        .rotationEffect(.degrees(rotationAngle))
                        .blur(radius: blurRadius )
                        .animation(.easeInOut(duration: 0.5),value: rotationAngle)
                        .animation(.easeInOut(duration: 0.5), value: opacity)
                        .animation(.easeInOut(duration: 0.5), value: blurRadius)
                    
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 300, height: 400)
                .onTapGesture {
                    withAnimation(){
                        pictureEffect1.toggle()
                    }
                }
            } else {
                ProgressView()
            }
            
            Text(viewModel.breedName)
                .font(nameKlick ? .system(size: 50) : .title3)
                .fontWeight(.bold)
                .foregroundColor(nameKlick ? .white : .black)
                .padding(20)
                .background(nameKlick ? Color.black : Color.blue.opacity(0.3))
                .cornerRadius(10)
                .padding()
                .onTapGesture {
                    withAnimation() {
                        nameKlick.toggle()
                    }
                }
            
            Text("Dir gefallen aktuell: \(likeCounter) Hunde!")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding()
            
            Spacer()
            
            HStack {
                Button(action: {
                    withAnimation(){
                        rotationAngle -= 360
                        dislikeScale = 0.0
                        opacity = 1.0
                        dislikeButtonPressedColor = .red
                        dislikeButtonPressed.toggle()
                    } completion: {
                        viewModel.dislikeAction()
                        dislikeButtonPressedColor = .blue
                        rotationAngle += 360
                        dislikeScale = 1.0
                        opacity = 0.0
                    }
                }) {
                    Image(systemName: "hand.thumbsdown.fill")
                        .font(.system(size: 50))
                        .symbolEffect(.bounce, value: dislikeButtonPressed)
                        .foregroundStyle(dislikeButtonPressedColor)
                }
                .padding()
                
                Button(action: {
                    viewModel.likeAction()
                    if likeCounter % 10 == 0 {
                        viewModel.likeNotification()
                    }
                    withAnimation(){
                        likeButtonPressedColor = .green
                        likeButtonPressed.toggle()
                    } completion: {
                        likeButtonPressedColor = .blue
                    }
                    withAnimation(.easeInOut(duration: 0.5)) {
                        rotationAngle += 360
                        opacity = 1.0
                        blurRadius = 5
                    } completion: {
                        opacity = 0.3
                        blurRadius = 0
                    }
                    
                    
                }) {
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.system(size: 50))
                        .symbolEffect(.bounce, value: likeButtonPressed)
                        .foregroundStyle(likeButtonPressedColor)
                    
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
