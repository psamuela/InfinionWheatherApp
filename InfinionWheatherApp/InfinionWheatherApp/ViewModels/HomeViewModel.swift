import Foundation

final class HomeViewModel {
    private let weatherService: WeatherService
    private let favorites: FavoritesStoreType

    var onWeatherLoaded: ((WeatherResponse) -> Void)?
    var onError: ((Error) -> Void)?
    var onFavoriteUpdated: ((String?) -> Void)?

    init(weatherService: WeatherService, favorites: FavoritesStoreType) {
        self.weatherService = weatherService
        self.favorites = favorites
    }

    var favoriteCity: String? { favorites.favoriteCity }

    func getWeather(for city: String) {
        weatherService.fetchWeather(for: city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.onWeatherLoaded?(response)
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }

    func saveFavorite(_ city: String) {
        favorites.favoriteCity = city
        onFavoriteUpdated?(city)
    }
}
