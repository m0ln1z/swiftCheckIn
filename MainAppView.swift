import SwiftUI



// Нужно отображать авторизованного пользователя, В центре экрана приложения будет написано Добрый {time} ( по времени сортирнуть - утро, день, вечер) + {firstName, lastName}

// next step: кнопка профиля кликабельная, сделать отображение инфы в профилея типа имя фамилия, статус.

//ВАЖНО: по кнопке отсканировать QR открывать камеру у пользователя.


struct MainAppView: View {
    @State private var isMenuOpen: Bool = false
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

    var body: some View {
        ZStack {
            backgroundColor
                .edgesIgnoringSafeArea(.all)

            NavigationView {
                VStack {
                    Image(logoImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .padding(.top, 50)

                    Spacer()
                    
                    NavigationLink(destination: ScanQRView()) {
                        Text("Отсканировать QR Code")
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
            }
            .navigationBarHidden(true)
            
            // Меню, которое появляется слева
            if isMenuOpen {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 20) {
                            Button(action: {
                                // actions for Profile
                            }) {
                                Text("Профиль")
                                    .foregroundColor(textColor)
                                    .padding()
                            }
                            
                            Button(action: {
                                // actions for Settings
                            }) {
                                Text("Настройки")
                                    .foregroundColor(textColor)
                                    .padding()
                            }

                            Button(action: {
                                // actions for Logout
                            }) {
                                Text("Выйти")
                                    .foregroundColor(.red)
                                    .padding()
                            }
                        }
                        .padding()
                        .frame(width: 250)
                        .background(menuBackgroundColor) // Прозрачное темное или светлое меню
                        .cornerRadius(15)
                        .padding(.top, 20) // Добавить отступ сверху, чтобы меню не прилипало к верху
                    }
                    Spacer()
                }
                .transition(.opacity) // Плавное появление меню
                .zIndex(1) // Чтобы меню было поверх других элементов
            }
        }
    }
}

struct ScanQRView: View {
    var body: some View {
        VStack {
            Text("Сканирование QR-кода")
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            Text("Future: add UI for scan qr")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
        }
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
