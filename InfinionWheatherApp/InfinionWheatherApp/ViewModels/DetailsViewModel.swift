import Foundation

final class DetailsViewModel {
    private let weather: WeatherResponse
    init(weather: WeatherResponse) {
        self.weather = weather
    }
    var cityName: String { weather.name }
    var descriptionText: String { weather.descriptionText.capitalized }
    var temperatureText: String { String(format: "%.1f°C", weather.temperatureCelsius) }
}
