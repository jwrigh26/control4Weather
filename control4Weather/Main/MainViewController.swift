//
//  MainViewController.swift
//  control4Weather
//
//  Created by Justin Wright on 2/11/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  weak var tableViewIndicator: UIActivityIndicatorView?
  
  fileprivate let dataManager = WeatherDataManager()
  fileprivate var tableViewData: [Weather]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    styleView()
    setupTableView()
    loadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func styleView() {
    title = "Control 4 Weather"
    navigationController?.setAppStyle()
    automaticallyAdjustsScrollViewInsets = false
    tableView.rowHeight = 64.0
  }
  
  func setupTableView() {
    tableViewIndicator = tableView.addIndicator(.gray)
    tableViewIndicator?.startAnimating()
  }
  
  func loadData() {
    dataManager.getWeatherByBulkCall{ [weak self] success, error in
      guard success else {
        if let error = error as? WeatherError, error == .bulkCallFailed {
          self?.backupDataIfLoadFails()
        }
        // TODO: add better error checking here.
        return
      }
      self?.refreshTableView()
    }
  }
  
  fileprivate func backupDataIfLoadFails() {
    dataManager.getWeatherByInefficientCall{ [weak self] success, error in
      // TODO: add better error checking here.
      guard success else { return }
      self?.refreshTableView()
    }
  }
 }

extension MainViewController : UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.cellIdentifier, for: indexPath)
    if let cell = cell as? WeatherTableViewCell, let data = tableViewData, data.indices.contains(indexPath.row) {
      let weather = data[indexPath.row]
      cell.configure(withWeather: weather, row: indexPath.row)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let value = tableViewData?.count ?? 0
    if value > 0 { tableViewIndicator?.stopAnimating() }
    return value
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  fileprivate func refreshTableView() {
    tableViewData = dataManager.weather
    tableView.reloadData()
  }
}

extension MainViewController : UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let data = tableViewData, data.indices.contains(indexPath.row) {
      let weather = data[indexPath.row]
      goToDetails(weather: weather)
    }
  }
  
  fileprivate func goToDetails(sender: Any? = nil, weather: Weather) {
    let storyboard = UIStoryboard(storyboard: .Details)
    let viewController: DetailsViewController = storyboard.initViewController()
    viewController.weather = weather
    viewController.forecast = dataManager.forecasts?.filter({ $0.id == weather.city.id }).first
    navigationController?.pushViewController(viewController, animated: true)
  }
}
