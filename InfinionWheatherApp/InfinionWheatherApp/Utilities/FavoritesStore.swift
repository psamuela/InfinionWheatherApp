import Foundation

protocol FavoritesStoreType: AnyObject {
    var favoriteCity: String? { get set }
}


final class FavoritesStore: FavoritesStoreType {
    private let key = "favoriteCity"
    private let defaults: UserDefaults
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    var favoriteCity: String? {
        get { defaults.string(forKey: key) }
        set { defaults.setValue(newValue, forKey: key) }
    }
}
