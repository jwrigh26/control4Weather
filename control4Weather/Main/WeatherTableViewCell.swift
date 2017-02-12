//
//  WeatherTableViewCell.swift
//  control4Weather
//
//  Created by Justin Wright on 2/11/17.
//  Copyright © 2017 Justin Wright. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell, WeatherIconFetchable {
  
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var stateLabel: UILabel!
  @IBOutlet weak var currentTempLabel: UILabel!
  @IBOutlet weak var weatherImageView: UIImageView!
  
  fileprivate let rowAlternativeColor: UIColor = AppColor.lightBlue.color
  fileprivate let placeholder = #imageLiteral(resourceName: "IconPlaceholder")
  
  var imageTask: URLSessionDownloadTask?
  var icon: Icon? {
    didSet {
      imageTask?.cancel()
      getImageForIcon(fileName: icon?.fileName)
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    cityLabel.textColor = AppColor.medBlue.color
    stateLabel.textColor = AppColor.medBlue.color
    currentTempLabel.textColor = AppColor.darkBlue.color
    weatherImageView?.image = placeholder
    
    
    let disclosureImage = #imageLiteral(resourceName: "Indicator")
    let disclosureView = UIImageView(image: disclosureImage)
    disclosureView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
    self.accessoryView = disclosureView
    self.accessoryView?.tintColor = AppColor.highlightSalmon.color
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    //super.setSelected(selected, animated: animated)
    // We don't override super here to prevent the cell from staying selected.
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    icon = nil
    weatherImageView?.image = placeholder
  }
  
  func configure(withWeather weather: Weather, row: Int) {
    cityLabel.text = weather.city.name
    icon = weather.icon
    stateLabel.text = weather.city.stateAbbreviation
    currentTempLabel.text = String.format(forFahrenheit: weather.currentTemperature)
    backgroundColor = row % 2 == 0 ? UIColor.white : rowAlternativeColor
    weatherImageView.tintColor = row % 2 == 0 ? AppColor.lightBlue.color : UIColor.white
  }
}
