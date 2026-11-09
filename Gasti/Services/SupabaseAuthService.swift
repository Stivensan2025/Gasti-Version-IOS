import Foundation

enum SupabaseAuthError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La dirección del servidor no es válida."
        case .invalidResponse:
            return "No se recibió una respuesta válida del servidor."
        case .serverError(let message):
            return message
        }
    }
}

final class SupabaseAuthService {

    static let shared = SupabaseAuthService()

    private let projectURL =
        "https://pylsfzgwxfuepjalkzam.supabase.co"

    // Pega aquí tu clave pública sb_publishable_.
    private let publishableKey =
        "sb_publishable_pprFI4V4tyc8JV84n2UmRw_yYB8O9A2"

    private init() {}

    private func authenticate(
        endpoint: String,
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let url = URL(
            string: "\(projectURL)/auth/v1/\(endpoint)"
        ) else {
            completion(.failure(SupabaseAuthError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30

        request.setValue(
            publishableKey,
            forHTTPHeaderField: "apikey"
        )

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        let body: [String: String] = [
            "email": email.trimmingCharacters(
                in: .whitespacesAndNewlines
            ),
            "password": password
        ]

        do {
            request.httpBody = try JSONSerialization.data(
                withJSONObject: body
            )
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) {
            data, response, error in

            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  let data = data else {
                DispatchQueue.main.async {
                    completion(
                        .failure(SupabaseAuthError.invalidResponse)
                    )
                }
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let message: String

                if let json = try? JSONSerialization.jsonObject(
                    with: data
                ) as? [String: Any] {
                    message = (json["msg"] as? String)
                        ?? (json["message"] as? String)
                        ?? (json["error_description"] as? String)
                        ?? (json["error"] as? String)
                        ?? "Error del servidor."
                } else {
                    message = "Error del servidor."
                }

                DispatchQueue.main.async {
                    completion(
                        .failure(
                            SupabaseAuthError.serverError(message)
                        )
                    )
                }
                return
            }

            DispatchQueue.main.async {
                completion(.success(()))
            }

        }.resume()
    }

    func register(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        authenticate(
            endpoint: "signup",
            email: email,
            password: password,
            completion: completion
        )
    }

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        authenticate(
            endpoint: "token?grant_type=password",
            email: email,
            password: password,
            completion: completion
        )
    }
}
