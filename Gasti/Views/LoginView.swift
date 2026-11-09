import SwiftUI

struct LoginView: View {

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isLoading = false
    @State private var showRegister = false

    var onLogin: (String) -> Void

    var body: some View {

        ZStack {

            GastiStyle.background
                .ignoresSafeArea()

            ScrollView {

                VStack(spacing: 24) {

                    Spacer(minLength: 35)

                    // Icono de Gasti
                    Image(systemName: "wallet.pass.fill")
                        .font(.system(size: 65))
                        .foregroundColor(GastiStyle.accent)

                    // Encabezado
                    VStack(spacing: 8) {

                        Text("Gasti")
                            .font(.system(size: 38, weight: .bold))
                            .foregroundColor(.white)

                        Text("Organiza tu dinero, alcanza tus metas")
                            .font(.subheadline)
                            .foregroundColor(GastiStyle.muted)
                            .multilineTextAlignment(.center)
                    }

                    // Formulario
                    VStack(alignment: .leading, spacing: 18) {

                        Text("Iniciar sesión")
                            .font(.title2.bold())
                            .foregroundColor(.white)

                        // Correo electrónico
                        VStack(alignment: .leading, spacing: 8) {

                            Text("Correo electrónico")
                                .font(.subheadline)
                                .foregroundColor(GastiStyle.muted)

                            HStack {

                                Image(systemName: "envelope")
                                    .foregroundColor(GastiStyle.accent)

                                TextField(
                                    "nombre@correo.com",
                                    text: $email
                                )
                                .keyboardType(.emailAddress)
                                .textContentType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .foregroundColor(.white)
                            }
                            .padding()
                            .background(GastiStyle.background)
                            .cornerRadius(12)
                        }

                        // Contraseña
                        VStack(alignment: .leading, spacing: 8) {

                            Text("Contraseña")
                                .font(.subheadline)
                                .foregroundColor(GastiStyle.muted)

                            HStack {

                                Image(systemName: "lock")
                                    .foregroundColor(GastiStyle.accent)

                                SecureField(
                                    "Escribe tu contraseña",
                                    text: $password
                                )
                                .textContentType(.password)
                                .foregroundColor(.white)
                            }
                            .padding()
                            .background(GastiStyle.background)
                            .cornerRadius(12)
                        }

                        // Mensaje de error
                        if !errorMessage.isEmpty {

                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .fixedSize(
                                    horizontal: false,
                                    vertical: true
                                )
                        }

                        // Botón de inicio de sesión
                        Button(action: loginWithSupabase) {

                            HStack {

                                if isLoading {

                                    ProgressView()
                                        .tint(.black)

                                } else {

                                    Text("Iniciar sesión")
                                        .font(.headline)
                                }
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(GastiStyle.accent)
                            .cornerRadius(14)
                        }
                        .disabled(isLoading)

                        // Ir al registro
                        Button(action: {
                            showRegister = true
                        }) {

                            Text("¿No tienes cuenta? Regístrate")
                                .font(.subheadline)
                                .foregroundColor(GastiStyle.accent)
                                .frame(maxWidth: .infinity)
                        }
                        .disabled(isLoading)

                        // Texto inferior
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
        .sheet(isPresented: $showRegister) {

            RegisterView(
                onBackToLogin: {
                    showRegister = false
                }
            )
        }
    }

    // MARK: - Inicio de sesión con Supabase

    private func loginWithSupabase() {

        let cleanEmail = email.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        // Validar correo
        guard !cleanEmail.isEmpty else {
            errorMessage = "Escribe tu correo electrónico."
            return
        }

        guard cleanEmail.contains("@"),
              cleanEmail.contains(".") else {

            errorMessage = "Escribe un correo electrónico válido."
            return
        }

        // Validar contraseña
        guard !password.isEmpty else {
            errorMessage = "Escribe tu contraseña."
            return
        }

        guard password.count >= 6 else {

            errorMessage =
                "La contraseña debe tener al menos 6 caracteres."

            return
        }

        errorMessage = ""
        isLoading = true

        // Conectar con Supabase
        SupabaseAuthService.shared.login(
            email: cleanEmail,
            password: password
        ) { result in

            isLoading = false

            switch result {

            case .success:

                // Notificar al componente principal
                // que el inicio de sesión fue exitoso.
                onLogin(cleanEmail)

            case .failure(let error):

                errorMessage = mensajeDeError(error)
            }
        }
    }

    // MARK: - Mensajes de error

    private func mensajeDeError(_ error: Error) -> String {

        let mensaje = error.localizedDescription
        let texto = mensaje.lowercased()

        if texto.contains("invalid login credentials") {
            return "El correo o la contraseña son incorrectos."
        }

        if texto.contains("email not confirmed") {
            return "Debes confirmar tu correo electrónico antes de iniciar sesión."
        }

        if texto.contains("too many requests") {
            return "Hubo demasiados intentos. Espera un momento."
        }

        if texto.contains("network") ||
           texto.contains("internet") {

            return "Comprueba tu conexión a internet e inténtalo de nuevo."
        }

        return mensaje
    }
}
