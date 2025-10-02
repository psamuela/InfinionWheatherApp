import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!

    private var viewModel: DetailsViewModel!

    func configure(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let vm = viewModel else { return }
        cityLabel.text = vm.cityName
        descriptionLabel.text = vm.descriptionText
        tempLabel.text = vm.temperatureText
    }
}
