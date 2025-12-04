
import SwiftUI

struct AccountView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)

            Text("User Name")
                .font(.title)

            List {
                Text("My Activity")
                Text("Settings")
                Text("Log Out")
            }
        }
    }
}
