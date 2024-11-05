import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DogViewModel()
    @AppStorage("likeCounter") var likeCounter: Int = 0
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("DOG LIKE")
                 .font(.largeTitle)
                 .fontWeight(.bold)
                 .foregroundColor(.black)
                 .padding()
            
            if let dogImageURL = viewModel.dogImageURL {
                AsyncImage(url: dogImageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(maxWidth: .infinity, maxHeight: 400)
                        .shadow(radius: 10)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 300, height: 400)
            } else {
                ProgressView()
            }
            
            Text(viewModel.breedName)
                 .font(.title)
                 .fontWeight(.bold)
                 .foregroundColor(.black)
                 .padding()
                 .background(Color.blue.opacity(0.3))
                 .cornerRadius(10)
            
            Text("Dir gefallen aktuell: \(likeCounter - 1) Hunde!")
                .font(.caption)
                 .fontWeight(.bold)
                 .foregroundColor(.black)
                 .padding()

            Spacer()
            
            HStack {
                Button(action: {
                    viewModel.dislikeAction()
                }) {
                    Image(systemName: "hand.thumbsdown")
                        .font(.system(size: 50))
                }
                .padding()
                
                Button(action: {
                    viewModel.likeAction()
                    if likeCounter % 10 == 0 {
                         viewModel.likeNotification()
                       }
                }) {
                    Image(systemName: "hand.thumbsup")
                        .font(.system(size: 50))
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
