//
//  ResultsViewController.swift
//  Stockly
//
//  Created by Victor  on 5/23/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation
import UIKit
import Charts
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var stockController: StockController?
    let dataGetter = DataGetter()
    var ref: DatabaseReference!
    
    @IBOutlet weak var keyDataTableView: UITableView!
    @IBOutlet weak var newsCollectionView: UICollectionView!
    @IBOutlet weak var mChart: LineChartView!
    @IBOutlet weak var stockPriceLabel: UILabel!
    @IBOutlet weak var stockPercentageLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var analyzeButton: UIButton!
    
    var keyDataTableData: [String] = []
    var keyDataTableKeys = [
        "Previous Close", "Open", "Low", "High",
        "52 Week Low", "52 Week High", "Volume",
        "Average Volume", "Market Cap", "PE Ratio"
    ]
    
    var collectionViewData: [News] = []
    var dataEntries: [ChartDataEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        analyzeButton.layer.masksToBounds = true
        analyzeButton.layer.cornerRadius = 5
        keyDataTableView.delegate = self
        keyDataTableView.dataSource = self
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
        getChartData()
        updateViews()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        ref = Database.database().reference().child("users").child(uid).child("WatchList")
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let key = ref.childByAutoId().key else {return}
        guard let quote = stockController?.quote else {return}
        let object = ["stock symbol": quote.symbol, "stock name": quote.companyName, "stock percent": "\(quote.changePercent ?? 0.0)", "stock price": "\(quote.latestPrice ?? 0.0)", "id": key]
        ref.child(key).setValue(object)
        Service.showAlert(on: self, style: .alert, title: "Stock Saved!", message: "Successfully added \(quote.companyName) to watchlist")
    }
    
    private func getChartData() {
        var values: [Double] = []
        if let stockChart = stockController?.chart {
            for x in stockChart {
                if let x = x.close {
                    values.append(x)
                }
            }
        }
        setChart(values: values)
    }
    
    func setChart(values: [Double]) {
        mChart.noDataText = "No Data"
        for i in 0..<values.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        let line1 = LineChartDataSet(entries: dataEntries, label: "Last Month: Daily Close")
        line1.colors = [NSUIColor.init(red: 113/255, green: 232/255, blue: 225/255, alpha: 1)]
        line1.mode = .cubicBezier
        line1.cubicIntensity = 0.2
        line1.valueTextColor = .clear
        let gradient = getGradientFilling()
        line1.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        line1.drawFilledEnabled = true
        
        let data = LineChartData()
        data.addDataSet(line1)
        mChart.data = data
        mChart.setScaleEnabled(false)
        mChart.animate(xAxisDuration: 1.0)
        mChart.legend.textColor = .white
        mChart.leftAxis.labelTextColor = .white
        mChart.rightAxis.drawAxisLineEnabled = false
        mChart.rightAxis.drawGridLinesEnabled = false
        mChart.rightAxis.enabled = false
        mChart.xAxis.drawLabelsEnabled = false
    }
    
    private func getGradientFilling() -> CGGradient {
        let coloTop = UIColor(red: 141/255, green: 133/255, blue: 220/255, alpha: 1).cgColor
        let colorBottom = UIColor(red: 230/255, green: 155/255, blue: 210/255, alpha: 1).cgColor
        let gradientColors = [coloTop, colorBottom] as CFArray
        let colorLocations: [CGFloat] = [0.7, 0.0]
        return CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyDataTableKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = keyDataTableView.dequeueReusableCell(withIdentifier: "SearchKeyDataTableViewCell", for: indexPath) as! SearchKeyDataTableViewCell
        guard let quote = stockController?.quote else {return cell}
        if let previousClose = quote.previousClose {
            let roundedPreviousClose =  String(format: "%.2f", previousClose)
            self.keyDataTableData.append(roundedPreviousClose)
        } else {
            print("Previous Close Is Null")
        }
        
        if let open = quote.open {
            let roundedOpen = String(format: "%.2f", open)
            self.keyDataTableData.append(roundedOpen)
        } else {
            print("Open Is Null")
        }
        if let low = quote.low {
            let roundedLow = String(format: "%.2f", low)
            self.keyDataTableData.append(roundedLow)
        } else {
            print("Low is null")
        }
        
        if let high = quote.high {
            let roundedHigh = String(format: "%.2f", high)
            self.keyDataTableData.append(roundedHigh)
        } else {
            print("High is null")
        }
        
        if let week52Low = quote.week52Low {
            let roundedWeek52Low = String(format: "%.2f", week52Low)
            self.keyDataTableData.append(roundedWeek52Low)
        } else {
            print("Week 52 Low Is Null")
        }
        
        if let week52High = quote.week52High {
            let roundedWeek52High = String(format: "%.2f", week52High)
            self.keyDataTableData.append(roundedWeek52High)
        } else {
            print("Week 52 High Is Null")
        }
        
        if let volume = quote.latestVolume {
            let roundedVolume = String(format: "%.2fM", volume/1e6)
            self.keyDataTableData.append(roundedVolume)
        } else {
            print("Volume is null")
        }
        if let avgVolume = quote.avgTotalVolume {
            let roundedAvgVolume = String(format: "%.2fM", avgVolume/1e6)
            self.keyDataTableData.append(roundedAvgVolume)
        } else {
            print("Average Volume Is Null")
        }
        
        if let marketCap = quote.marketCap {
            let roundedMarketCap =  String(format: "%.2fB", marketCap/1e9)
            self.keyDataTableData.append(roundedMarketCap)
        } else {
            print("Market Cap Is Null")
        }
        
        if let peRatio = quote.peRatio {
            let roundedPERatio = String(format: "%.2f", peRatio)
            self.keyDataTableData.append(roundedPERatio)
        } else {
            print("PE Ratio Is Null")
        }
        
        cell.keyDataKeyLabel.text = self.keyDataTableKeys[indexPath.row]
        cell.keyDataValueLabel.text = keyDataTableData[indexPath.row]
        
        return cell
    }
    
    func updateViews() {
        guard let quote = stockController?.quote else {return}
        self.title = quote.symbol
        if let latestPrice = quote.latestPrice {
            stockPriceLabel.text = "$\(latestPrice)"
        }
        if let changePercentage = quote.changePercent {
            let roundedPercent = Double(round(1000 * changePercentage)/1000)
            stockPercentageLabel.text = "\(roundedPercent)%"
            if "\(changePercentage)".contains("-") {
                stockPercentageLabel.textColor = UIColor.red
            } else {
                stockPercentageLabel.textColor = UIColor.green
            }
        }
        if let news = stockController?.news {
            collectionViewData = news
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchNews" {
            guard let destinationVC = segue.destination as? StockSearchNewsViewController else {return}
            let cell = sender as! SearchNewsCollectionViewCell
            guard let indexPath = self.newsCollectionView.indexPath(for: cell) else {return}
            let url = self.collectionViewData[(indexPath.row)].url
            destinationVC.url = url
        }
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        navigationItem.backBarButtonItem?.tintColor = .white
        
    }
    
}

extension ResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView {
            return self.collectionViewData.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == newsCollectionView {
            let cell = newsCollectionView.dequeueReusableCell(withReuseIdentifier: "SearchNewsCell", for: indexPath) as! SearchNewsCollectionViewCell
            
            cell.searchHeadLinesLabel.text = self.collectionViewData[indexPath.row].headline
            if let dateTime = self.collectionViewData[indexPath.row].datetime {
                let date = Date(timeIntervalSince1970: (TimeInterval(dateTime/1000)))
                cell.searchDateLabel.text = "\(date)"
            } else {
                cell.searchDateLabel.text = ""
            }
            return cell
        } else {
            print("Error")
        }
        
        return UICollectionViewCell()
        
    }
    
    
}


