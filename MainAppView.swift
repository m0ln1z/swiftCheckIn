import SwiftUI
import AVFoundation

struct MainAppView: View {
    @State private var isMenuOpen: Bool = false
    @State private var user: User? = nil
    @State private var errorMessage: String? = nil
    @State private var authToken: String? = nil
    @State private var isAuthenticated = false
    @Environment(\.colorScheme) var colorScheme
    
    private var logoImageName: String {
        colorScheme == .dark ? "Group 33" : "Satbayev_University-removebg-preview"
    }
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(UIColor.systemBackground) : Color.white
    }
    
    private var menuBackgroundColor: Color {
        colorScheme == .dark ? Color.black.opacity(0.8) : Color.white.opacity(0.9)
    }
    
    private var textColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            return "Доброе утро"
        case 12..<18:
            return "Добрый день"
        case 18..<24:
            return "Добрый вечер"
        default:
            return "Доброй ночи"
        }
    }
    
    var body: some View {
        ZStack {
            backgroundColor
                .edgesIgnoringSafeArea(.all)
            
            NavigationView {
                VStack {
                    if isAuthenticated, let user = user {
                        Text("\(greeting), \(user.firstName) \(user.lastName)!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(textColor)
                            .padding()
                    } else if let errorMessage = errorMessage {
                        Text("Ошибка: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        ProgressView()
                            .padding()
                    }
                    
                    Image(logoImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .padding(.top, 50)
                    
                    Spacer()
                    
                    
                    if !isAuthenticated {
                        NavigationLink(destination: ContentView()) {
                            Text("Авторизоваться")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 50)
                        }
                    }
                }
                .navigationBarItems(
                    leading: Button(action: {
                        withAnimation {
                            isMenuOpen.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .foregroundColor(textColor)
                    }
                )
                .padding(.top, 10)
                .onAppear {
                    if let token = authToken {
                        fetchUserProfile(authToken: token)
                    }
                }
            }
            .navigationBarHidden(true)
            
            if isMenuOpen {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 20) {
                            NavigationLink(destination: ProfileView(user: user)) {
                                Text("Профиль")
                                    .foregroundColor(textColor)
                                    .padding()
                            }
                            
                            Button(action: {
                                // Actions for Settings
                            }) {
                                Text("Настройки")
                                    .foregroundColor(textColor)
                                    .padding()
                            }
                            
                            Button(action: {
                                // Actions for Logout
                                logoutUser()
                            }) {
                                Text("Выйти")
                                    .foregroundColor(.red)
                                    .padding()
                            }
                        }
                        .padding()
                        .frame(width: 250)
                        .background(menuBackgroundColor)
                        .cornerRadius(15)
                        .padding(.top, 20)
                    }
                    Spacer()
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
    }
    
    private func fetchUserProfile(authToken: String) {
        APIClient.getProfile(authToken: authToken) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profileData):
                    // Assuming profileData contains firstName, lastName, and status
                    if let firstName = profileData["firstName"] as? String,
                       let lastName = profileData["lastName"] as? String,
                       let status = profileData["status"] as? String {
                        self.user = User(firstName: firstName, lastName: lastName, status: status)
                        self.isAuthenticated = true
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func loginUser(email: String, password: String) {
        APIClient.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    self.authToken = token
                    self.fetchUserProfile(authToken: token)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func logoutUser() {
        // Clear token and user data when logging out
        authToken = nil
        user = nil
        isAuthenticated = false
    }
}

struct User {
    let firstName: String
    let lastName: String
    let status: String
}

struct ProfileView: View {
    let user: User?
    
    var body: some View {
        VStack {
            if let user = user {
                Text("Имя: \(user.firstName)")
                    .font(.headline)
                    .padding(.top, 20)
                
                Text("Фамилия: \(user.lastName)")
                    .font(.headline)
                    .padding(.top, 10)
                
                Text("Статус: \(user.status)")
                    .font(.headline)
                    .padding(.top, 10)
            } else {
                Text("Данные пользователя недоступны.")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .padding()
        .navigationTitle("Профиль")
    }
}


   
struct MainAppView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainAppView()
                .previewDevice("iPhone 16 Pro")
                .preferredColorScheme(.light)
            MainAppView()
                .previewDevice("iPhone 16 Pro")
                .preferredColorScheme(.dark)
        }
    }
}
