//
//  ViewController.swift
//  weatherApp
//
//  Created by Антон Сивцов on 20.04.2021.
//

import UIKit

// MARK: - CityListVC
final class CityListVC: UIViewController {

    // MARK: - Properties
    private var cities: [City] = []
    private var filteredCities: [City] = []
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

}

// MARK: - Methods
extension CityListVC {
    private func configureView() {
        self.view.addSubview(tableView)

        tableView.register(CityCell.self, forCellReuseIdentifier: CityCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.backgroundColor = .white

        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCity(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton

        extendedLayoutIncludesOpaqueBars = true // prevents navigationController turn black
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController

        // Search Bar setting
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.searchBarStyle = .default

        title = "Weather"
    }

    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor)
        ])
    }

    private func showErrorAlert(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: .none))
        present(alert, animated: true, completion: nil)
    }

    private func showAlert() {
        let alert = UIAlertController(title: "Wrong city",
                                      message: "This city do not exist, please, try again.",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Actions
extension CityListVC {
    @objc func addCity(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Enter name of a city:", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default, handler: {
            [weak self] action in
            if let name = alert.textFields?.first?.text {
                if !name.isEmpty {
                    WeatherService.shared.getData(cityName: name, completion: { [weak self] (result) in
                        switch result {
                        case .success(let city):
                            if city.name != "" {
                                self?.cities.append(city)
                            } else {
                                self?.showAlert()
                            }
                        case .failure(let error):
                            //показать алерт с ошибкой
                            self?.showErrorAlert(error)
                        }
                        guard let cities = self?.cities else { return }
                        self?.filteredCities = cities
                        self?.tableView.reloadData()
                    })

                }
            }
        })
        let action2 = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addTextField(configurationHandler: {
            textField in
            textField.placeholder = "Name"
        })
        alert.addAction(action)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UISearchBarDelegate
extension CityListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCities = []

        if searchText == "" {
            filteredCities = cities
        } else {
            for symbol in cities {
                if symbol.name.lowercased().contains(searchText.lowercased()) {
                    filteredCities.append(symbol)
                }
            }
        }
        self.tableView.reloadData()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredCities = cities
    }

}

// MARK: - UITableViewDataSource
extension CityListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.reuseIdentifier) as? CityCell else {
            return UITableViewCell()
        }

        cell.build(city: cities[indexPath.row])

        return cell
    }

}

// MARK: - UITableViewDelegate
extension CityListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            let city = filteredCities[indexPath.item]
            let vc = CityDetailVC(item: city)
            self.navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            filteredCities.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
