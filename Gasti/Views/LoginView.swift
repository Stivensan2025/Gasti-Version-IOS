import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""

    var onLogin: (String) -> Void

    var body: some View {
        ZStack {
            GastiStyle.background
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: 24) {
                    Spacer(minLength: 35)

                    Image(systemName: "wallet.pass.fill")
                        .font(.system(size: 65))
                        .foregroundColor(GastiStyle.accent)

                    VStack(spacing: 8) {
                        Text("Gasti")
                            .font(.system(size: 38, weight: .bold))
                            .foregroundColor(.white)

                        Text("Organiza tu dinero, alcanza tus metas")
                            .font(.subheadline)
                            .foregroundColor(GastiStyle.muted)
                            .multilineTextAlignment(.center)
                    }

                    VStack(alignment: .leading, spacing: 18) {
                        Text("Iniciar sesión")
                            .font(.title2.bold())
                            .foregroundColor(.white)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Correo electrónico")
                                .font(.subheadline)
                                .foregroundColor(GastiStyle.muted)

                            HStack {
                                Image(systemName: "envelope")
                                    .foregroundColor(GastiStyle.accent)

                                TextField("nombre@correo.com", text: $email)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(GastiStyle.background)
                            .cornerRadius(12)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Contraseña")
                                .font(.subheadline)
                                .foregroundColor(GastiStyle.muted)

                            HStack {
                                Image(systemName: "lock")
                                    .foregroundColor(GastiStyle.accent)

                                SecureField("Escribe tu contraseña", text: $password)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(GastiStyle.background)
                            .cornerRadius(12)
                        }

                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                        }

                        Button(action: validateLogin) {
                            Text("Iniciar sesión")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(GastiStyle.accent)
                                .cornerRadius(14)
                        }

                        Text("Tus finanzas, organizadas en un solo lugar.")
                            .font(.caption)
                            .foregroundColor(GastiStyle.muted)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }
                    .padding(22)
                    .background(GastiStyle.card)
                    .cornerRadius(22)

                    Spacer(minLength: 25)
                }
                .padding(22)
            }
        }
    }

    private func validateLogin() {
        let cleanEmail = email.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard cleanEmail.contains("@"),
              cleanEmail.contains(".") else {
            errorMessage = "Escribe un correo electrónico válido."
            return
        }

        guard password.count >= 6 else {
            errorMessage = "La contraseña debe tener al menos 6 caracteres."
            return
        }

        errorMessage = ""
        onLogin(cleanEmail)
    }
}
