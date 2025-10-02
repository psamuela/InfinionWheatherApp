# InfinionWeatherApp
Infinion iOS weather app


An iOS app that retrieves and displays current weather information for any city using the OpenWeather API (https://openweathermap.org/current).

Built with Swift, Storyboards, and the MVVM architecture, demonstrating SOLID principles, Dependency Injection, and *unit testing.

## Features
**Splash Screen** - navigates to the Home screen.
**Home Screen** - user enters a city name, retrieves weather data, and can save a favorite city (prepopulates on launch).
**Details Screen** - displays weather description and temperature for the selected city.
**Persistent Favorites** - stored using `UserDefaults`.
**MVVM** - ViewModels manage state, ViewControllers handle UI.
**Unit Tests** - mock network calls using a custom `URLProtocol`.


## Project Architecture
- **MVVM**:  
  - `HomeViewModel`, `DetailsViewModel` handle presentation logic.  
  - ViewControllers only deal with UI. 

## Requirements
- iOS 15.0+
- Simulator sometimes takes time to load, kindly use real device to preview


  Thanks 


