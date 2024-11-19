import SwiftUI

struct MainAppView: View {
    var body: some View {
        Text("Тут будет основной интерфейс")
            .font(.largeTitle)
            .foregroundColor(.black)
            .navigationBarHidden(true)  
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
