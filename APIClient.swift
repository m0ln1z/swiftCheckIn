import Foundation

class APIClient {
    static let baseURL = "http://localhost:3000" 
    
    // MARK: - Login
    static func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            completion(.failure(NSError(domain: "Invalid data", code: 400, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        print("Sending request to \(url)") 
        print("Request body: \(String(data: jsonData, encoding: .utf8) ?? "")") 
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)") 
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response status code: \(response.statusCode)") 
            }
            
            if let data = data {
                let responseString = String(data: data, encoding: .utf8)
                print("Login Response: \(responseString ?? "")") 
                completion(.success(()))
            }
        }.resume()
    }
    
    // MARK: - Register
    static func register(username: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/register") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        let parameters: [String: Any] = [
            "username": username,
            "email": email,
            "password": password,
            "createdAt": "2024-11-08T00:00:00.000Z"
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            completion(.failure(NSError(domain: "Invalid data", code: 400, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        print("Sending request to \(url)") // Логирование URL
        print("Request body: \(String(data: jsonData, encoding: .utf8) ?? "")") // Логирование тела запроса
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)") // Логирование ошибки
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response status code: \(response.statusCode)") // Логирование статус-кода ответа
            }
            
            if let data = data {
                let responseString = String(data: data, encoding: .utf8)
                print("Register Response: \(responseString ?? "")") // Логирование ответа
                completion(.success(()))
            }
        }.resume()
    }
}
