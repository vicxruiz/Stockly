//
//  HomeStockDetailViewController.swift
//  Stockly
//
//  Created by Victor  on 6/18/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation
import UIKit
import Charts
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class HomeStockDetialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var stockController: StockController?
    var techStockController: TechStockController?
    var healthStockController: HealthStockController?
    var industrialStockController: IndustrialStockController?
    var stock: Batch?
    var ref: DatabaseReference!
    var keyDataTableKeys = [
        "Previous Close", "Open", "Low", "High",
        "52 Week Low", "52 Week High", "Volume",
        "Average Volume", "Market Cap", "PE Ratio"
    ]
    var keyDataTableData: [String] = []
    var collectionViewData: [News] = []
    var dataEntries: [ChartDataEntry] = []
    
    @IBOutlet weak var keyDataTableView: UITableView!
    @IBOutlet weak var latestPriceLabel: UILabel!
    @IBOutlet weak var changePercentLabel: UILabel!
    @IBOutlet weak var newsCollectionView: UICollectionView!
    @IBOutlet weak var mChart: LineChartView!
    @IBOutlet weak var analyzeButton: UIButton!
    @IBOutlet weak var stockLogoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyDataTableView.delegate = self
        keyDataTableView.dataSource = self
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
        updateViews()
        getChartData()
    }
    
    @IBAction func analyzeButtonPressed(_ sender: Any) {
        Service.showAlert(on: self, style: .alert, title: "Feature Coming Soon!", message: "Sentinement analysis for every stock.")
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        ref = Database.database().reference().child("users").child(uid).child("WatchList")
        guard let key = ref.childByAutoId().key else {return}
        guard let stock = stock else {return}
        let object = ["stock symbol": stock.quote.symbol, "stock name": stock.quote.companyName, "stock percent": "\(stock.quote.changePercent ?? 0.0)", "stock price": "\(stock.quote.latestPrice ?? 0.0)", "id": key]
        ref.child(key).setValue(object)
        Service.showAlert(on: self, style: .alert, title: "Stock Saved!", message: "Successfully added \(stock.quote.companyName) to watchlist")
    }
    
    func getChartData() {
        var values: [Double] = []
        if let stockChart = stock?.chart {
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
        let cell = keyDataTableView.dequeueReusableCell(withIdentifier: "keyDataTableViewCell", for: indexPath) as! KeyDataTableViewCell
        if let previousClose = stock?.quote.previousClose {
            let roundedPreviousClose =  String(format: "%.2f", previousClose)
            self.keyDataTableData.append(roundedPreviousClose)
        } else {
            print("120")
            print("Previous Close Is Null")
        }
        
        if let open = stock?.quote.open {
            let roundedOpen = String(format: "%.2f", open)
            self.keyDataTableData.append(roundedOpen)
        } else {
            print("Open Is Null")
        }
        if let low = stock?.quote.low {
            let roundedLow = String(format: "%.2f", low)
            self.keyDataTableData.append(roundedLow)
        } else {
            print("Low is null")
        }
        
        if let high = stock?.quote.high{
            let roundedHigh = String(format: "%.2f", high)
            self.keyDataTableData.append(roundedHigh)
        } else {
            print("High is null")
        }
        
        if let week52Low = stock?.quote.week52Low {
            let roundedWeek52Low = String(format: "%.2f", week52Low)
            self.keyDataTableData.append(roundedWeek52Low)
        } else {
            print("Week 52 Low Is Null")
        }
        
        if let week52High = stock?.quote.week52High {
            let roundedWeek52High = String(format: "%.2f", week52High)
            self.keyDataTableData.append(roundedWeek52High)
        } else {
            print("Week 52 High Is Null")
        }
        
        if let volume = stock?.quote.latestVolume {
            let roundedVolume = String(format: "%.2fM", volume/1e6)
            self.keyDataTableData.append(roundedVolume)
        } else {
            print("Volume is null")
        }
        if let avgVolume = stock?.quote.avgTotalVolume {
            let roundedAvgVolume = String(format: "%.2fM", avgVolume/1e6)
            self.keyDataTableData.append(roundedAvgVolume)
        } else {
            print("Average Volume Is Null")
        }
        
        if let marketCap = stock?.quote.marketCap {
            let roundedMarketCap =  String(format: "%.2fB", marketCap/1e9)
            self.keyDataTableData.append(roundedMarketCap)
        } else {
            print("Market Cap Is Null")
        }
        
        if let peRatio = stock?.quote.peRatio {
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
        analyzeButton.layer.masksToBounds = true
        analyzeButton.layer.cornerRadius = 5
        mChart.borderColor = .white
        guard let stock = stock else {return}
        self.title = stock.quote.symbol
        fetchImage(stock)
        if let latestPrice = stock.quote.latestPrice {
            latestPriceLabel.text = "$\(latestPrice)"
        }
        if let changePercentage = stock.quote.changePercent {
            let roundedPercent = Double(round(1000 * changePercentage)/1000)
            changePercentLabel.text = "\(roundedPercent)%"
            if "\(changePercentage)".contains("-") {
                changePercentLabel.textColor = UIColor.red
            } else {
                changePercentLabel.textColor = UIColor.green
            }
        }
        collectionViewData = stock.news
    }
    
    func fetchImage(_ stock: Batch) {
        guard let stockController = stockController else {return}
        stockController.fetchLogo(stock.quote.symbol) { (error) in
            
            if let error = error {
                print(error)
            }
            
            stockController.getData(url: URL(string: stockController.stockLogoURL!)!, completion: { (data, error) in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.stockLogoImageView.image = UIImage(data: data)
                }
            })
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewsDetail" {
            guard let destinationVC = segue.destination as? StockNewsViewContorller else {return}
            let cell = sender as! SymbolNewsCollectionViewCell
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


extension HomeStockDetialViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView {
            return self.collectionViewData.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == newsCollectionView {
            let cell = newsCollectionView.dequeueReusableCell(withReuseIdentifier: "symbolNewsCell", for: indexPath) as! SymbolNewsCollectionViewCell
            
            cell.headlineLabel.text = self.collectionViewData[indexPath.row].headline
            if let dateTime = self.collectionViewData[indexPath.row].datetime {
                let date = Date(timeIntervalSince1970: (TimeInterval(dateTime/1000)))
                cell.dateLabel.text = "\(date)"
            } else {
                cell.dateLabel.text = ""
            }
            return cell
        } else {
            print("Error")
        }
        
        return UICollectionViewCell()

    }
    
    
}

