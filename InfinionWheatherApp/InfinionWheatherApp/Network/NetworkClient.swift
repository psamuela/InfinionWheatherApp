import Foundation

protocol NetworkClient {
    func perform(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void)
}

final class URLSessionNetworkClient: NetworkClient {
    private let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
    func perform(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            if let e = error { completion(.failure(e)); return }
            guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
                completion(.failure(NSError(domain: "HTTPError", code: 0)))
                return
            }
            completion(.success(data ?? Data()))
        }
        task.resume()
    }
}
