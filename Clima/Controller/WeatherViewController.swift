 

import UIKit
import CoreLocation

 class WeatherViewController: UIViewController  {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!

    
    var weatherManager = WeatherHelper()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self 
        searchTextField.delegate = self
    }
    @IBAction func locationButton(_ sender: UIButton) {
        locationManager.requestLocation()
    }

}
 
// MARK: - TextField Area

 extension WeatherViewController :UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "You Should Enter a City !"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.getWeather(city: city)
        }
        searchTextField.text = ""

    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true

    }

 }

 // MARK: - Weather Manager Section
 extension WeatherViewController :WeatherManagerDelegate {
    func didUpdateWeather(weatherData: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weatherData.tempToString
            self.conditionImageView.image = UIImage(systemName: weatherData.conditionName)
            self.cityLabel.text = weatherData.cityName
        }
        
      }
    func didFailWithAnError(error: Error) {
        print(error)
    }
 }

 // MARK: - locationManagerDelegate
 extension WeatherViewController: CLLocationManagerDelegate  {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            self.weatherManager.getWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
 }
