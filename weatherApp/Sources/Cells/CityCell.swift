//
//  FirstViewControllerTableViewCell.swift
//  weatherApp
//
//  Created by Антон Сивцов on 20.04.2021.
//

import UIKit

final class CityCell: UITableViewCell {

    // MARK: - Static
    static let reuseIdentifier = "CityCell"

    // MARK: - Properties
    private let nameLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let humidityLabel = UILabel()
    private let informationStack = UIStackView()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Methods
extension CityCell {
    private func setupCell() {
        informationStack.addArrangedSubview(temperatureLabel)
        informationStack.addArrangedSubview(humidityLabel)
        informationStack.spacing = 4

        contentView.addSubview(nameLabel)
        contentView.addSubview(informationStack)
    }

    private func setupConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        informationStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            informationStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            informationStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            informationStack.widthAnchor.constraint(equalToConstant: 110)
        ])
    }

    internal func build(city: City) {
        nameLabel.text = city.name
        temperatureLabel.text = String(city.temp)  + "C"
        humidityLabel.text = String(city.humidity) + "H"
    }

}
