//
//  SearchAnalyzeViewController.swift
//  Stockly
//
//  Created by Victor  on 6/23/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation
import UIKit
import Charts

class SearchAnalyzeViewController: UIViewController {
    @IBOutlet weak var pieChart: PieChartView!
    
    private var dataEntries: [PieChartDataEntry] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getChartData()
    }
    
    func getChartData() {
        var values: [Double] = []
        values.append(50.7)
        values.append(11.3)
        values.append(34.0)
        let options = ["Buy", "Hold", "Sell"]
        setChart(dataPoints: options, values: values)
    }
    
    private func setChart(dataPoints: [String], values: [Double]) {
        pieChart.noDataText = "No Data"
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: "\(dataPoints[i])")
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Options")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChart.data = pieChartData
        
        var colors: [UIColor] = []
        
        for i in 0..<values.count {
            
            colors.append(UIColor.orange)
            colors.append(Service.stocklyDesignTheme)
            colors.append(UIColor.lightGray)
        }
        pieChartDataSet.colors = colors
        
        
        pieChart.centerAttributedText = NSAttributedString(string: "Stock Analysis")
        pieChart.legendRenderer.legend = nil
        pieChart.animate(xAxisDuration: 1.0)
    }
    
    
}
