//
//  ChartDataView.swift
//  Tawazon
//
//  Created by mac on 25/01/2023.
//  Copyright © 2023 Inceptiontech. All rights reserved.
//

import UIKit
import Charts

protocol ChartDataViewDelegate: class {
    func dataTypeChanged(type: Int)
}

class ChartDataView: UIView, ChartViewDelegate {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dataTypeSegment: RoundedSegmentedControl!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var feelingLabelsStackView: UIStackView!
    @IBOutlet var feelingsLabel: [UILabel]!
    @IBOutlet weak var upperDividerView: UIView!
    @IBOutlet weak var verticalDividerView: UIView!
    @IBOutlet weak var bottomDividerView: UIView!
    @IBOutlet weak var verticalGradientView: GradientView!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var selectedFeelingDetailsView: UIView!
    @IBOutlet weak var selectedFeelingImageView: UIImageView!
    @IBOutlet weak var selectedFeelingTitleLabel: UILabel!
    @IBOutlet weak var selectedFeelingDateLabel: UILabel!
    
    var delegate: ChartDataViewDelegate?
    
    var moodTrackerVM: MoodTrackerVM?{
        didSet{
            chartData = moodTrackerVM?.MoodTrackerData?.chart
        }
    }
    
    var chartData: [ChartData]?{
        didSet{
            print("chartData: \(chartData?[0].intensity)")
            updateChartData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
        updateChartData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dataTypeSegment.layoutIfNeeded()
        dataTypeSegment.roundCorners(corners: .allCorners, radius: 14)
        
        chartView.roundCorners(corners: .allCorners, radius: 16)
    }
    
    private func initialize(){
        dateLabel.font = .munaBoldFont(ofSize: 20)
        dateLabel.textColor = .white.withAlphaComponent(0.5)
        dateLabel.text = "ديسمبر"
        
        dataTypeSegment.backgroundColor = .catalinaBlue
        dataTypeSegment.layer.masksToBounds = true
        dataTypeSegment.roundCorners(corners: .allCorners, radius: 14)
        dataTypeSegment.segmentImage = UIImage(color: .chambray)
        dataTypeSegment.setTitle("moodTrakerSubtractive".localized, forSegmentAt: 0)
        dataTypeSegment.setTitle("moodTrakerAccumulative".localized, forSegmentAt: 1)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, .font: UIFont.munaBoldFont(ofSize: 16)]
        dataTypeSegment.setTitleTextAttributes(titleTextAttributes, for: .normal)
        dataTypeSegment.setTitleTextAttributes(titleTextAttributes, for: .selected)
        dataTypeSegment.isHidden = true
        
        chartView.backgroundColor = .midnightBlue
        chartView.roundCorners(corners: .allCorners, radius: 16)
        
        upperDividerView.backgroundColor = .chambray
        
        verticalDividerView.backgroundColor = .chambray
        
        bottomDividerView.backgroundColor = .chambray
        
        verticalGradientView.applyGradientColor(colors: [UIColor.deYork.cgColor, UIColor.barleyWhite.cgColor, UIColor.cranberry.cgColor], startPoint: .top, endPoint: .bottom)
        verticalGradientView.roundCorners(corners: .allCorners, radius: 2)
        
        lineChartView.backgroundColor = .clear
        lineChartView.isUserInteractionEnabled = false
        
        for feelLabel in feelingsLabel{
            feelLabel.font = .munaFont(ofSize: 14)
            feelLabel.textColor = .white.withAlphaComponent(0.8)
            feelLabel.transform = CGAffineTransform(rotationAngle: 60.0 * .pi / 180.0)
        }
        
        selectedFeelingDetailsView.backgroundColor = .chambray
        selectedFeelingDetailsView.layer.cornerRadius = 12
        selectedFeelingDetailsView.isHidden = true
        
        selectedFeelingTitleLabel.font = .munaBlackFont(ofSize: 15)
        selectedFeelingTitleLabel.textColor = .white.withAlphaComponent(0.8)
        
        selectedFeelingDateLabel.font = .munaFont(ofSize: 13)
        selectedFeelingDateLabel.textColor = .white.withAlphaComponent(0.72)
        
        selectedFeelingImageView.backgroundColor = .clear
        selectedFeelingImageView.contentMode = .scaleAspectFill
        
        intializeChart()
        
    }
    
    
    private func intializeChart(){
        lineChartView.renderer = newRender(dataProvider: lineChartView, animator: lineChartView.chartAnimator, viewPortHandler: lineChartView.viewPortHandler)
        // Do any additional setup after loading the view.
        
        lineChartView.backgroundColor = .clear
        lineChartView.delegate = self
        
        lineChartView.chartDescription.enabled = false
        
        lineChartView.dragEnabled = true
        lineChartView.setScaleEnabled(true)
        lineChartView.pinchZoomEnabled = false
        lineChartView.highlightPerDragEnabled = true
        
//        lineChartView.backgroundColor = UIColor(red: 33/255, green: 43/255, blue: 83/255, alpha: 1)
        
        lineChartView.legend.enabled = false
        lineChartView.layer.cornerRadius = 16
        
        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelRotationAngle = 0
        xAxis.setLabelCount(8, force: true)
        xAxis.labelFont = UIFont(name: "SFPro-Regular", size: 12) ?? .systemFont(ofSize: 12)
        xAxis.labelTextColor = .white.withAlphaComponent(0.5)
        xAxis.drawAxisLineEnabled = true
//        xAxis.avoidFirstLastClippingEnabled = true
//        xAxis.axisLineDashLengths = [CGFloat(2)]
        xAxis.axisLineWidth = CGFloat(1)
        xAxis.axisLineColor = UIColor(red: 75/255, green: 84/255, blue: 127/255, alpha: 1)
        xAxis.granularityEnabled = true
        xAxis.drawGridLinesEnabled = true
        xAxis.gridLineDashLengths = [CGFloat(4)]
        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularity = chartData?.count ?? 0 < 10 ? 86400 : (86400 * 7)
//        xAxis.labelCount = 7
        
        xAxis.valueFormatter = DateValueFormatter()
        
        let leftAxis = lineChartView.leftAxis
//        leftAxis.labelPosition = .insideChart
//        leftAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
//        leftAxis.drawGridLinesEnabled = true
//        leftAxis.granularityEnabled = true
        leftAxis.axisMinimum = 1
        leftAxis.axisMaximum = 5
//        leftAxis.yOffset = 0
//        leftAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)

        lineChartView.leftAxis.enabled = false
        lineChartView.rightAxis.enabled = false
        
        lineChartView.legend.form = .line
        
        lineChartView.clipsToBounds = false
        lineChartView.animate(xAxisDuration: 2.5)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("entry: \(entry)")
        let timeResult = entry.x
        let date = Date(timeIntervalSince1970: timeResult)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dateFormatter.timeZone = .current
        let pointDate = dateFormatter.string(from: date)
        let pointIntensity = entry.y
        if let chartPoints = chartData{
            let point = chartPoints.filter({
                return $0.intensity == pointIntensity && $0.dateValue == pointDate
            }).first
            print("selectedPoint: \(point)")
            if chartPoints.count > 10{
                if let feelingIconUrl = point?.feeling?.icon?.url{
                    selectedFeelingImageView.af.setImage(withURL: feelingIconUrl)
                }
                selectedFeelingTitleLabel.text = point?.feeling?.title
                selectedFeelingDateLabel.text = point?.dateValue
                selectedFeelingDetailsView.isHidden = false
            }
            
        }
    }
    
     func updateChartData() {
         dateLabel.text = moodTrackerVM?.MoodTrackerData?.title
         selectedFeelingDetailsView.isHidden = true
         if chartData?.count ?? 0 >= 12{
             bottomDividerView.isHidden = true
         }else{
             bottomDividerView.isHidden = false
         }
         let xAxis = lineChartView.xAxis
         if (chartData?.count ?? 0 < 5){ // 3Months
             xAxis.setLabelCount(5, force: true)
             xAxis.granularity = 86400 * 7
             xAxis.labelRotationAngle = 0
         }else if (chartData?.count ?? 0 < 10){ // 7Days
             xAxis.setLabelCount(8, force: true)
             xAxis.granularity = 86400
             xAxis.labelRotationAngle = 0
         }else if (chartData?.count ?? 0 < 13){ // 1Year
             xAxis.setLabelCount(13, force: true)
             xAxis.granularity = 2629743
             xAxis.labelRotationAngle = 90
         }else if (chartData?.count ?? 0 < 25){ // 6Months
             xAxis.setLabelCount(24, force: true)
             xAxis.granularity = 86400 * 7
             xAxis.labelRotationAngle = 90
         }else{ // 1Month
             if dataTypeSegment.selectedSegmentIndex == 1{ // accumulative
                 xAxis.setLabelCount(5, force: true)
                 xAxis.granularity = 86400 * 7
                 xAxis.labelRotationAngle = 0
             }else{ // subtractive
                 xAxis.setLabelCount(32, force: true)
                 xAxis.granularity = 86400
                 xAxis.labelRotationAngle = 90
             }
             
         }
         print("granularity: \(chartData?.count ?? 0 < 10 ? 86400 : (86400 * 7))")
         
         self.setDataCount()
    }
    
    func setDataCount() {
        var chartValues : [ChartDataEntry] = []
        if let chartPoints = chartData{
            for (index, point) in chartPoints.enumerated(){
            
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd"
                let datePoint = dateFormatter.date(from: point.dateValue ?? "")
                
                if (chartData?.count ?? 0 < 5){ // 3Months
                    chartValues.append(ChartDataEntry(x: (datePoint?.timeIntervalSince1970 ?? TimeInterval()), y: Double(abs(point.cumulativeIntensity ?? 1)) , data: chartPoints.count < 10 ? point.feeling?.icon : ""))
                }else if (chartData?.count ?? 0 < 10){ // 7Days
                    chartValues.append(ChartDataEntry(x: (datePoint?.timeIntervalSince1970 ?? TimeInterval()), y: Double(abs(point.intensity ?? 1)) , data: chartPoints.count < 10 ? point.feeling?.icon : ""))
                    feelingsLabel[index].text = point.feeling?.title
                }else if (chartData?.count ?? 0 < 13){ // 1Year
                    chartValues.append(ChartDataEntry(x: (datePoint?.timeIntervalSince1970 ?? TimeInterval()), y: Double(abs(point.cumulativeIntensity ?? 1)) , data: chartPoints.count < 10 ? point.feeling?.icon : ""))
                }else if (chartData?.count ?? 0 < 25){ // 6Months
                    chartValues.append(ChartDataEntry(x: (datePoint?.timeIntervalSince1970 ?? TimeInterval()), y: Double(abs(point.cumulativeIntensity ?? 1)) , data: chartPoints.count < 10 ? point.feeling?.icon : ""))
                }else{ // 1Month
                    if dataTypeSegment.selectedSegmentIndex == 1{ // accumulative
                        chartValues.append(ChartDataEntry(x: (datePoint?.timeIntervalSince1970 ?? TimeInterval()), y: Double(abs(point.cumulativeIntensity ?? 1)) , data: chartPoints.count < 10 ? point.feeling?.icon : ""))
                    }else{// subtractive
                        chartValues.append(ChartDataEntry(x: (datePoint?.timeIntervalSince1970 ?? TimeInterval()), y: Double(abs(point.intensity ?? 1)) , data: chartPoints.count < 10 ? point.feeling?.icon : ""))
                    }
                }
                
                if chartPoints.count > 5 && chartPoints.count < 10{
                    feelingLabelsStackView.isHidden = false
                }else{
                    feelingLabelsStackView.isHidden = true
                }
            }
        }
        print("chartValues.count: \(chartValues.count)")
        let set1 = LineChartDataSet(entries: chartValues, label: "DataSet 1")
        set1.axisDependency = .right
        set1.setColor(UIColor(red: 167/255, green: 159/255, blue: 224/255, alpha: 1))
        set1.lineWidth = 2
        
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.setDrawHighlightIndicators(true)
        
        set1.drawValuesEnabled = false
        set1.fillAlpha = 0.26
        set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        set1.highlightColor = .chambray
        if chartValues.count > 5 && chartValues.count < 10{ // 7Days
            set1.circleRadius = 6
            set1.setCircleColor(UIColor(red: 33/255, green: 43/255, blue: 83/255, alpha: 1))
            set1.drawCirclesEnabled = true
            set1.drawCircleHoleEnabled = true
            set1.circleHoleColor = .white
            set1.circleHoleRadius = 3
            set1.drawIconsEnabled = true
            
        }else{ // otherRanges
            set1.mode = .cubicBezier
            set1.drawCirclesEnabled = false
            set1.drawCircleHoleEnabled = false
            set1.drawIconsEnabled = false
        }
        
        let data = LineChartData(dataSet: set1)
        data.setValueTextColor(.white)
        
        data.setValueFont(.systemFont(ofSize: 9, weight: .light))
        
        lineChartView.data = data
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        delegate?.dataTypeChanged(type: dataTypeSegment.selectedSegmentIndex + 1)
    }
}


class newRender : LineChartRenderer{
    internal var _xBounds = XBounds() // Reusable XBounds object
    override func drawExtras(context: CGContext) {
        super.drawExtras(context: context)
        drawIcons(context: context)
    }
    
    private func drawIcons(context: CGContext)
    {
        guard
            let dataProvider = dataProvider,
            let lineData = dataProvider.lineData
        else { return }
        
        let phaseY = animator.phaseY
        
        var pt = CGPoint()
        var rect = CGRect()
        
        // If we redraw the data, remove and repopulate accessible elements to update label values and frames
        accessibleChartElements.removeAll()
//        accessibilityOrderedElements = accessibilityCreateEmptyOrderedElements()

        // Make the chart header the first element in the accessible elements array
        if let chart = dataProvider as? LineChartView {
            let element = createAccessibleHeader(usingChart: chart,
                                                 andData: lineData,
                                                 withDefaultDescription: "Line Chart")
            accessibleChartElements.append(element)
        }

        context.saveGState()

        for i in lineData.indices
        {
            guard let dataSet = lineData[i] as? LineChartDataSetProtocol else { continue }

            // Skip Circles and Accessibility if not enabled,
            // reduces CPU significantly if not needed
            if !dataSet.isVisible || !dataSet.isDrawCirclesEnabled || dataSet.entryCount == 0
            {
                continue
            }
            
            let trans = dataProvider.getTransformer(forAxis: dataSet.axisDependency)
            let valueToPixelMatrix = trans.valueToPixelMatrix
            
            _xBounds.set(chart: dataProvider, dataSet: dataSet, animator: animator)
            
            let circleRadius = dataSet.circleRadius
            let circleDiameter = circleRadius * 2.0
            let circleHoleRadius = dataSet.circleHoleRadius
            let circleHoleDiameter = circleHoleRadius * 2.0
            
            let drawCircleHole = dataSet.isDrawCircleHoleEnabled &&
                circleHoleRadius < circleRadius &&
                circleHoleRadius > 0.0
            let drawTransparentCircleHole = drawCircleHole &&
                (dataSet.circleHoleColor == nil ||
                    dataSet.circleHoleColor == NSUIColor.clear)
            
            for j in _xBounds
            {
                guard let e = dataSet.entryForIndex(j) else { break }
                
                pt.x = CGFloat(e.x)
                pt.y = CGFloat(e.y * phaseY)
                pt = pt.applying(valueToPixelMatrix)
                
                if (!viewPortHandler.isInBoundsRight(pt.x))
                {
                    break
                }
                
                // make sure the circles don't do shitty things outside bounds
                if (!viewPortHandler.isInBoundsLeft(pt.x) || !viewPortHandler.isInBoundsY(pt.y))
                {
                    continue
                }
                
                // Accessibility element geometry
                let scaleFactor: CGFloat = 3
                let accessibilityRect = CGRect(x: pt.x - (scaleFactor * circleRadius),
                                               y: pt.y - (scaleFactor * circleRadius),
                                               width: scaleFactor * circleDiameter,
                                               height: scaleFactor * circleDiameter)
                // Create and append the corresponding accessibility element to accessibilityOrderedElements
//                if let chart = dataProvider as? LineChartView
//                {
//                    let element = createAccessibleElement(withIndex: j,
//                                                          container: chart,
//                                                          dataSet: dataSet,
//                                                          dataSetIndex: i)
//                    { (element) in
//                        element.accessibilityFrame = accessibilityRect
//                    }
//
//                    accessibilityOrderedElements[i].append(element)
//                }

                context.setFillColor(dataSet.getCircleColor(atIndex: j)!.cgColor)

                rect.origin.x = pt.x - circleRadius
                rect.origin.y = pt.y - circleRadius
                rect.size.width = circleDiameter
                rect.size.height = circleDiameter

                if let iconUrlString = (e.data as? String) {
                    if let url = iconUrlString.url{
    //                    let imageView = UIImageView(frame: CGRect(x: pt.x - 14, y: pt.y + 10, width: 28, height: 28))
    //                    imageView.af.setImage(withURL: url)
    //                    imageView.backgroundColor = .red
                    
    //                    URLSession.shared.dataTask(with: url) { (data, response, error) in
    //                      // Error handling...
    //                      guard let imageData = data else { return }
    //                        print("data: \(data)")
    //
    //                      DispatchQueue.main.async {
    //                          if let image = UIImage(data: imageData){
    //                              print("image")
    //                              image.draw(in: CGRect(x: pt.x - 14, y: pt.y + 10, width: 28, height: 28))
    //                          }
    //                      }
    //                    }.resume()
                              
                        
                        do {
                              let imgData = try NSData(contentsOf: url, options: NSData.ReadingOptions())
                              let image = UIImage(data: imgData as Data)
    //                            DispatchQueue.main.async() { () -> Void in
                                    image?.draw(in: CGRect(x: pt.x - 14, y: pt.y + 10, width: 28, height: 28))
    //                       }
                        } catch {

                        }
                    }
                }
                
                
                
                if drawTransparentCircleHole
                {
                    // Begin path for circle with hole
                    context.beginPath()
                    context.addEllipse(in: rect)
                    
                    // Cut hole in path
                    rect.origin.x = pt.x - circleHoleRadius
                    rect.origin.y = pt.y - circleHoleRadius
                    rect.size.width = circleHoleDiameter
                    rect.size.height = circleHoleDiameter
                    context.addEllipse(in: rect)
                    
                    // Fill in-between
                    context.fillPath(using: .evenOdd)
                }
                else
                {
                    context.fillEllipse(in: rect)
                    
                    if drawCircleHole
                    {
                        context.setFillColor(dataSet.circleHoleColor!.cgColor)

                        // The hole rect
                        rect.origin.x = pt.x - circleHoleRadius
                        rect.origin.y = pt.y - circleHoleRadius
                        rect.size.width = circleHoleDiameter
                        rect.size.height = circleHoleDiameter
                        
                        context.fillEllipse(in: rect)
                    }
                }
            }
        }
        
        context.restoreGState()

        // Merge nested ordered arrays into the single accessibleChartElements.
//        accessibleChartElements.append(contentsOf: accessibilityOrderedElements.flatMap { $0 } )
//        accessibilityPostLayoutChangedNotification()
    }
    
}

