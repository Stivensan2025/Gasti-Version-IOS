import SwiftUI

struct RegisterView: View {

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var successMessage = ""
    @State private var isLoading = false

    var onBackToLogin: () -> Void

    var body: some View {

        ZStack {
            GastiStyle.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {

                    Spacer(minLength: 30)

                    Image(systemName: "wallet.pass.fill")
                        .font(.system(size: 65))
                        .foregroundColor(GastiStyle.accent)

                    VStack(spacing: 8) {
                        Text("Gasti")
                            .font(.system(size: 38, weight: .bold))
                            .foregroundColor(.white)

                        Text("Empieza a organizar tu dinero")
                            .font(.subheadline)
                            .foregroundColor(GastiStyle.muted)
                            .multilineTextAlignment(.center)
                    }

                    VStack(alignment: .leading, spacing: 18) {

                        Text("Crear cuenta")
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
                                    "Mínimo 6 caracteres",
                                    text: $password
                                )
                                .textContentType(.newPassword)
                                .foregroundColor(.white)
                            }
                            .padding()
                            .background(GastiStyle.background)
                            .cornerRadius(12)
                        }

                        // Confirmar contraseña
                        VStack(alignment: .leading, spacing: 8) {

                            Text("Confirmar contraseña")
                                .font(.subheadline)
                                .foregroundColor(GastiStyle.muted)

                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(GastiStyle.accent)

                                SecureField(
                                    "Repite tu contraseña",
                                    text: $confirmPassword
                                )
                                .textContentType(.newPassword)
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

                        // Mensaje de éxito
                        if !successMessage.isEmpty {
                            Text(successMessage)
                                .font(.caption)
                                .foregroundColor(GastiStyle.accent)
                                .fixedSize(
                                    horizontal: false,
                                    vertical: true
                                )
                        }

                        // Botón para crear cuenta
                        Button(action: registerUser) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .tint(.black)
                                } else {
                                    Text("Crear cuenta")
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

                        // Volver al inicio de sesión
                        Button(action: onBackToLogin) {
                            Text("¿Ya tienes cuenta? Inicia sesión")
                                .font(.subheadline)
                                .foregroundColor(GastiStyle.accent)
                                .frame(maxWidth: .infinity)
                        }
                        .disabled(isLoading)

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

    // MARK: - Registro con Supabase

    private func registerUser() {

        let cleanEmail = email.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        errorMessage = ""
        successMessage = ""

        guard !cleanEmail.isEmpty else {
            errorMessage = "Escribe tu correo electrónico."
            return
        }

        guard cleanEmail.contains("@"),
              cleanEmail.contains(".") else {
            errorMessage = "Escribe un correo electrónico válido."
            return
        }

        guard !password.isEmpty else {
            errorMessage = "Escribe una contraseña."
            return
        }

        guard password.count >= 6 else {
            errorMessage = "La contraseña debe tener al menos 6 caracteres."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Las contraseñas no coinciden."
            return
        }

        isLoading = true

        SupabaseAuthService.shared.register(
            email: cleanEmail,
            password: password
        ) { result in

            isLoading = false

            switch result {

            case .success:
                successMessage =
                    "Registro enviado. Si Supabase requiere confirmación por correo, revisa tu bandeja de entrada antes de iniciar sesión."

                password = ""
                confirmPassword = ""

            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}
