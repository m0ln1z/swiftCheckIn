import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isLoggingIn: Bool = false
    @State private var isLoggedIn: Bool = false
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 28/255, green: 28/255, blue: 30/255) : Color.white
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 13) {
                    Image("Satbayev_University-removebg-preview")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .padding(.bottom, 5)
                    
                    Text("Авторизация")
                        .font(.system(size: 32, weight:  .bold, design: .rounded))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    VStack(alignment: .leading, spacing: 13) {
                        Text("Email")
                            .foregroundColor(colorScheme == .dark ? .gray : .black)
                            .font(.headline)
                        
                        TextField("Введите ваш email", text: $email)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6))
                            )
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Пароль")
                           .foregroundColor(colorScheme == .dark ? .gray : .black)
                            .font(.headline)
                        
                        HStack {
                            if isPasswordVisible {
                                TextField("Введите ваш пароль", text: $password)
                            } else {
                                SecureField("Введите ваш пароль", text: $password)
                            }
                            
                            Button(action: {
                                withAnimation {
                                    isPasswordVisible.toggle()
                                }
                            }) {
                                Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6))
                        )
                    }
                    
                    Button(action: {
                        isLoggingIn = true
                        APIClient.login(email: email, password: password) { result in
                            DispatchQueue.main.async {
                                isLoggingIn = false
                                switch result {
                                case .success:
                                    print("Успешный вход!")
                                    isLoggedIn = true
                                case .failure(let error):
                                    print("Ошибка: \(error.localizedDescription)")
                                }
                            }
                        }
                    }) {
                        if isLoggingIn {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("Войти")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                    }
                    .disabled(isLoggingIn)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    HStack {
                        Text("Нет аккаунта?")
                            .foregroundColor(.gray)
                        NavigationLink(destination: RegistrationView()) {
                            Text("Зарегистрироваться")
                                .foregroundColor(.blue)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.bottom, 30)
                    
                    .navigationDestination(isPresented: $isLoggedIn) {
                        MainAppView()
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}
struct RegistrationView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 28/255, green: 28/255, blue: 30/255) : Color.white
    }
    
    var body: some View {
        ZStack {
            backgroundColor
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Spacer()
                
                Text("Регистрация")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("ФИО")
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? .gray : .black)
                    
                    TextField("Введите ваше ФИО", text: $fullName)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6))
                        )
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Email")
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? .gray : .black)
                    
                    TextField("Введите ваш email", text: $email)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6))
                        )
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Пароль")
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? .gray : .black)
                    
                    SecureField("Введите ваш пароль", text: $password)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6))
                        )
                }
                
                Button(action: {
                    APIClient.register(username: fullName, email: email, password: password) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                print("Регистрация успешна!")
                            case .failure(let error):
                                print("Ошибка: \(error.localizedDescription)")
                            }
                        }
                    }
                }) {
                    Text("Зарегистрироваться")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.top, 20)

                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
}


struct ContentView: View {
    var body: some View {
        LoginView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 16 Pro")
                .preferredColorScheme(.light)
            ContentView()
                .previewDevice("iPhone 16 Pro")
                .preferredColorScheme(.dark)
        }
    }
}
