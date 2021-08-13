//
//  SecondViewController.swift
//  weatherApp
//
//  Created by Антон Сивцов on 20.04.2021.
//

import UIKit
import Kingfisher

final class CityDetailVC: UIViewController {

    // MARK: - Properties
    private let nameLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let humidityLabel = UILabel()
    private let pressureLabel = UILabel()
    private let imageView = UIImageView()
    private let dateFormater = DateFormatter()
    private let item: City

    // MARK: - Init
    init(item: City) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        setupConstraints()
        configure()
    }

}

// MARK: - Methods
extension CityDetailVC {
    private func setupVC() {
        nameLabel.textAlignment = .center
        temperatureLabel.textAlignment = .center
        humidityLabel.textAlignment = .center
        pressureLabel.textAlignment = .center
        dateFormater.dateFormat = "dd.MM.yyyy HH.mm"

        view.addSubview(nameLabel)
        view.addSubview(humidityLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(pressureLabel)
        view.addSubview(imageView)

        view.backgroundColor = .white
    }

    private func setupConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        humidityLabel.translatesAutoresizingMaskIntoConstraints = false
        pressureLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            nameLabel.bottomAnchor.constraint(equalTo: temperatureLabel.topAnchor, constant: -15),

            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: humidityLabel.topAnchor, constant: -15),

            humidityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            pressureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pressureLabel.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor, constant: 15),

            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: pressureLabel.bottomAnchor, constant: 15),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }

    private func configure() {
        nameLabel.text = item.name
        temperatureLabel.text = String(item.temp) + " Celcium"
        humidityLabel.text = String(item.humidity) + " Humidity"
        pressureLabel.text = String(item.pressure) + " Pressure"
        imageView.kf.setImage(with: item.iconURL)

        let date = dateFormater.string(from: item.dt)
        title = date
    }

}
