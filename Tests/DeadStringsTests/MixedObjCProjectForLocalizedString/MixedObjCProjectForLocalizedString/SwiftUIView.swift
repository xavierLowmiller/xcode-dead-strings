//
//  ContentView.swift
//

import SwiftUI

struct ContentView: View {
    @State private var mail = """
    a@b.com
    """
    @State private var password = #"secret"#

    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                Text("login_title")
                TextField("mail_address_placeholder", text: $mail)
                    .disabled(true)
                    .border(Color.black, width: 1)
                SecureField("password_placeholder", text: $password)
                    .border(Color.black, width: 1)
            }.padding()
            .navigationTitle("swiftui_view_title")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
