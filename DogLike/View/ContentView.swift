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
    @State private var scale: Double = 1.0
    @GestureState private var scaleMagn: CGFloat = 1.0
    @State private var offsetX: CGFloat = 0.0
    
    var body: some View {
        VStack {
            Spacer()
            Text("DOG LIKE")
                .font(.system(size: 60, weight: .heavy, design: .rounded))
                .foregroundColor(.black)
                .padding()
            VStack {
                if let dogImageURL = viewModel.dogImageURL {
                    AsyncImage(url: dogImageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: pictureEffect1 ? 35 : 10))
                            .frame(maxWidth: .infinity, maxHeight: 400)
                            .offset(x: offsetX)
                            .padding()
                        
                            .scaleEffect(scale)
                            .rotationEffect(.degrees(rotationAngle))
                            .blur(radius: blurRadius )
                        
                            .animation(.easeInOut(duration: 0.5),value: rotationAngle)
                            .animation(.easeInOut(duration: 0.5), value: opacity)
                            .animation(.easeInOut(duration: 0.5), value: blurRadius)
                        
                            .onTapGesture(count: 2, perform: {
                                scale = 1.0
                                offsetX = 0.0
                            })
                            .onTapGesture {
                                print("BildUrl: \(dogImageURL)")
                                withAnimation(){
                                    pictureEffect1.toggle()
                                }
                            }
                            .gesture(
                                MagnifyGesture()
                                    .onChanged({ scale in
                                        self.scale = scale.magnification
                                    })
                                    .onEnded({ scale in
                                        self.scale = scale.magnification
                                    })
                            )
                            .gesture(
                                withAnimation() {
                                    DragGesture()
                                        .onChanged { value in
                                            offsetX = value.translation.width
                                        }
                                        .onEnded { value in
                                            if value.translation.width > 150 {
                                                
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
                                                offsetX = 0.0
                                                
                                            } else if value.translation.width < -150 {
                                                
                                                withAnimation(){
                                                    rotationAngle -= 360
                                                    scale = 0.0
                                                    opacity = 1.0
                                                    dislikeButtonPressedColor = .red
                                                    dislikeButtonPressed.toggle()
                                                } completion: {
                                                    viewModel.dislikeAction()
                                                    dislikeButtonPressedColor = .blue
                                                    rotationAngle += 360
                                                    scale = 1.0
                                                    opacity = 0.0
                                                }
                                                
                                                offsetX = 0.0
                                                
                                            } else {
                                                offsetX = 0
                                            }
                                        }
                                }
                            )
                            .clipped()
                            .shadow(color: pictureEffect1 ? .purple : .gray ,radius: pictureEffect1 ? 100 : 10)
                        
                            .onLongPressGesture(minimumDuration: 1.5, perform: {
                                viewModel.likeAction()
                                
                                if likeCounter % 10 == 0 {
                                    viewModel.likeNotification()
                                }
                                withAnimation(){
                                    likeButtonPressedColor = .green; likeButtonPressed.toggle()
                                } completion: {
                                    likeButtonPressedColor = .blue
                                }
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    rotationAngle += 360; opacity = 1.0; blurRadius = 5
                                } completion: {
                                    opacity = 0.3; blurRadius = 0
                                }
                            })
                        
                        
                        
                    } placeholder: { ProgressView() }
                } else { ProgressView() }
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
                        scale = 0.0
                        opacity = 1.0
                        dislikeButtonPressedColor = .red
                        dislikeButtonPressed.toggle()
                    } completion: {
                        viewModel.dislikeAction()
                        dislikeButtonPressedColor = .blue
                        rotationAngle += 360
                        scale = 1.0
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
