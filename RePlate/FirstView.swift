//
import SwiftUI

struct SplashView: View {
    @State private var navigate = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 53/255, green: 123/255, blue: 73/255)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Image("RePlate_logo")
                        .resizable()
                        .frame(width: 189, height: 189)

                }

                NavigationLink(destination: LoginView(), isActive: $navigate) {
                    EmptyView()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    navigate = true
                }
            }
        }
    }
}
