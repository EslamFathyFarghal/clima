 

import UIKit

 class WeatherViewController: UIViewController, UITextFieldDelegate , WeatherManagerDelegate {
    
    
  
    

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherHelper()
    
    @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self 
        searchTextField.delegate = self
    }

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

    func didUpdateWeather(weatherData: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weatherData.tempToString
            self.conditionImageView.image = UIImage(systemName: weatherData.conditionName) 
            self.cityLabel.text = weatherData.cityName
        }
        
      }
    func didFailWithAnError(error: Error) {
        print("error")
    }
}

