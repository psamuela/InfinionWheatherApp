import Foundation

final class OpenWeatherService: WeatherService {
    private let apiKey: String
    private let client: NetworkClient
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    init(apiKey: String, client: NetworkClient = URLSessionNetworkClient()) {
        self.apiKey = apiKey
        self.client = client
    }

    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        guard var comps = URLComponents(string: baseURL) else {
            completion(.failure(NSError(domain: "URLError", code: 0)))
            return
        }
        comps.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        guard let url = comps.url else {
            completion(.failure(NSError(domain: "URLError", code: 0)))
            return
        }
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        client.perform(request: req) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let resp = try decoder.decode(WeatherResponse.self, from: data)
                    completion(.success(resp))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}
