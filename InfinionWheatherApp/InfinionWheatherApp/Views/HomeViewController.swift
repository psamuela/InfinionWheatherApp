import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var fetchButton: UIButton!
    @IBOutlet weak var saveFavoriteButton: UIButton!

    private var viewModel: HomeViewModel!

    func configure(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            let apiKey = Constants.openWeatherApiKey
            let weatherService = OpenWeatherService(apiKey: apiKey)
            viewModel = HomeViewModel(weatherService: weatherService, favorites: FavoritesStore())
        }

        cityTextField.text = viewModel.favoriteCity

        viewModel.onWeatherLoaded = { [weak self] weather in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else { return }
            detailsVC.configure(viewModel: DetailsViewModel(weather: weather))
            self?.navigationController?.pushViewController(detailsVC, animated: true)
        }

        viewModel.onError = { [weak self] error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }

        viewModel.onFavoriteUpdated = { [weak self] city in
            self?.cityTextField.text = city
        }
    }

    @IBAction func fetchTapped(_ sender: Any) {
        guard let city = cityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !city.isEmpty else {
            let alert = UIAlertController(title: "Enter city", message: "Please type a city name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        viewModel.getWeather(for: city)
    }

    @IBAction func saveFavoriteTapped(_ sender: Any) {
        guard let city = cityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !city.isEmpty else { return }
        viewModel.saveFavorite(city)
        let alert = UIAlertController(title: "Saved", message: "\(city) saved as favorite.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
