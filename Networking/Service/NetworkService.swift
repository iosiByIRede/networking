import Foundation

enum NetworkServiceError: String, Error, CaseIterable {
    case unauthorized = "Sua sessão expirou.\nEfetue o login novamente."
    case dataError = "Verifique os dados informados."
    case clientError = "Verifique os dados informados e a sua conexão com a internet. Caso o error persista entre em contato com o nosso suporte."
    case serverError = "Parece que estamos passando por manutenção nos servidores.\nTente novamente mais tarde."
    case unknownError = "Um erro inesperado ocorreu.\n Entre em contato com o nosso suporte ou tente novamente mais tarde."
}

protocol NetworkServiceInterface {
    func request<Request: RequestTemplate>(
                    _ request: Request,
                    using session: URLSession,
                    completion: @escaping (Result<Request.Response, NetworkServiceError>) -> Void)
}

class NetworkService: NetworkServiceInterface {
    static let shared: NetworkService = NetworkService()

    func request<Request: RequestTemplate>(
                    _ request: Request,
                    using session: URLSession = URLSession.shared,
                    completion: @escaping (Result<Request.Response, NetworkServiceError>) -> Void) {
        guard let url = request.url else {
            return completion(.failure(NetworkServiceError.unknownError))
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.data
        urlRequest.allHTTPHeaderFields = request.headers

        session.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    return completion(.failure(NetworkServiceError.unknownError))
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    return completion(.failure(NetworkServiceError.unknownError))
                }

                switch httpResponse.statusCode {
                case 401:
                    return completion(.failure(NetworkServiceError.unauthorized))
                case 400...499:
                    return completion(.failure(NetworkServiceError.clientError))
                case 500...599:
                    return completion(.failure(NetworkServiceError.serverError))
                default:
                    break
                }

                guard let data = data else {
                    return completion(.failure(NetworkServiceError.unknownError))
                }

                do {
                    try completion(.success(request.decode(data)))
                } catch {
                    completion(.failure(NetworkServiceError.unknownError))
                }
            }
        }.resume()
    }
}
