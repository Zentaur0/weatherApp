import Foundation
import SwiftyJSON

final class WeatherService {

    // MARK: - Static
    static let shared = WeatherService()

    // MARK: - Init
    private init() {}
}

// MARK: - Methods
extension WeatherService {
    func getData(cityName: String, completion: @escaping (Result<City, Error>) -> Void) {

        let url = URL.init(string: "http://api.openweathermap.org/data/2.5/weather?q=\(cityName)&units=metric&appid=4b983b516e78ccd70bd0d7b9ab3efaa4")

        guard let url = url else { return }

        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let json = try JSON(data: data)
                let city = City(json: json)

                DispatchQueue.main.async {
                    completion(.success(city))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        dataTask.resume()
    }

}
