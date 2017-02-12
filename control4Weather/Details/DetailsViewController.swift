//
//  DetailsViewController.swift
//  control4Weather
//
//  Created by Justin Wright on 2/11/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, WeatherIconFetchable {
  
  @IBOutlet var currentTemp: UILabel!
  @IBOutlet var descriptionLabel: UILabel!
  @IBOutlet var humidityLabel: UILabel!
  @IBOutlet var humidityTitleLabel: UILabel!
  @IBOutlet var maxTemp: UILabel!
  @IBOutlet var minTemp: UILabel!
  @IBOutlet var oneWordLabel: UILabel!
  @IBOutlet var pressureLabel: UILabel!
  @IBOutlet var pressureTitleLabel: UILabel!
  @IBOutlet var todayTitleLabel: UILabel!
  @IBOutlet var todayDateLabel: UILabel!
  @IBOutlet var topView: RoundedView!
  @IBOutlet var weatherImageView: UIImageView!
  
  var weather: Weather!
  var forecast: Forecast?
  
  var imageTask: URLSessionDownloadTask?
  
  var icon: Icon? {
    didSet {
      imageTask?.cancel()
      getImageForIcon(fileName: icon?.fileName)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard weather != nil else { fatalError("ooop") }
    styleView()
    setValuesForLabels()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func styleView() {
    title = weather.city.name
    navigationController?.setAppStyle()
    weatherImageView.tintColor = AppColor.lightBlue.color
    oneWordLabel.textColor = AppColor.darkBlue.color
    
    let tempCompare = weather.currentTemperature > 75.00
    currentTemp.textColor = tempCompare ? AppColor.highlightSalmon.color : AppColor.lightBlue.color
  }
  
  func setValuesForLabels() {
    currentTemp.text = String.format(forFahrenheit: weather.currentTemperature)
    
    descriptionLabel.text = "Currently it is \(weather.description.simpleDescription)."
    
    icon = weather.icon
    
    humidityLabel.text = String.format(forPercent: weather.humidity)
    
    if let forecast = forecast {
      maxTemp.text = String.format(forFahrenheit: forecast.high)
      minTemp.text = String.format(forFahrenheit: forecast.low)
    }
    
    oneWordLabel.text = weather.description.oneWordDescription
    
    pressureLabel.text = String.format(forHPA: weather.pressure)
    
    todayDateLabel.text = weather.dateInfo.today
  }

}
