
import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome Back")
                .font(.largeTitle)

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            Button("Sign In") {}

            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .padding()
    }
}
