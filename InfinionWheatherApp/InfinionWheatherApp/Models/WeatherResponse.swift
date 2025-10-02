import Foundation

struct WeatherResponse: Decodable {
    struct Weather: Decodable {
        let description: String
    }
    struct Main: Decodable {
        let temp: Double
        let feels_like: Double?
    }

    let name: String
    let weather: [Weather]
    let main: Main

    var descriptionText: String {
        weather.first?.description ?? "No description"
    }
    var temperatureCelsius: Double {
        main.temp
    }
}
