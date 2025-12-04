
import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            VStack(spacing: 20) {
                Image(systemName: "leaf.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)

                Text("RePlate")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
    }
}
