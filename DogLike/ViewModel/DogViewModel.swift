import Foundation
import SwiftUI
import UserNotifications

@MainActor
class DogViewModel: ObservableObject {
    @Published var dogImageURL: URL?
    @Published var likeCount = 0
    @Published var dislikeCount = 0
    @Published var breedName = ""
    @Published var notificationIsAllowed: Bool = false
    
    private var repository: DogRepositoryProtocol
    @AppStorage("likeCounter") var likeCounter: Int = 0
    
    init(repository: DogRepositoryProtocol = DogRepository()) {
        self.repository = repository
        
        fetchRandomDogImage()
        Task {
            self.notificationIsAllowed = try await NotificationManager.shared.requestPermission()
        }
    }
    
    func scheduleNotification() {
        NotificationManager.shared.scheduleDailyNotification()
    }
    
    func likeNotification() {
        NotificationManager.shared.likeNotification()
    }
    
    func fetchRandomDogImage() {
        Task {
            do {
                let url = try await repository.fetchRandomDogImage()
                if let breedName = extractBreedName(from: url.absoluteString) {
                    self.breedName = breedName
                } else {
                    breedName = "No Breed found"
                }
                dogImageURL = url
            } catch {
                print("Error while loading: \(error)")
            }
        }
    }
    
    func likeAction() {
        likeCounter += 1
        likeCount += 1
        fetchRandomDogImage()
    }
    
    func dislikeAction() {
        dislikeCount += 1
        fetchRandomDogImage()
    }
    
    func extractBreedName(from urlString: String) -> String? {
        let searchKeyword = "breeds/"

        guard let range = urlString.range(of: searchKeyword) else {
            return nil
        }
        
        let substringFromBreed = urlString[range.upperBound...]
        var breed = ""
        for char in substringFromBreed {
            if char == "/" {
                break
            }
            breed.append(char)
        }
        
        return breed.isEmpty ? nil : breed
    }
    
    func greeting(name: String) -> String {
        return "Welcome to DogLike, \(name)!"
    }
}




