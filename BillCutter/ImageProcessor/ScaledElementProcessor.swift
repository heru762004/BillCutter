//
//  ScaledElementProcessor.swift
//  SampleMLKit
//
//  Created by Heru Prasetia on 8/7/19.
//  Copyright © 2019 NETS. All rights reserved.
//

import Foundation
import Firebase

class ScaledElementProcessor {
    
    var items: [Item] = []
    
    let vision = Vision.vision()
    var textRecognizer: VisionTextRecognizer!
    var isGrandTotalFound = false
    
    init() {
        textRecognizer = vision.onDeviceTextRecognizer()
//        textRecognizer = vision.cloudTextRecognizer()
//        let options = VisionCloudTextRecognizerOptions()
//        options.languageHints = ["en","hi"]
//        textRecognizer = vision.cloudTextRecognizer(options: options)
    }
    
    func process(in image: UIImage,
                 callback: @escaping (_ text: [Item]) -> Void) {
        // 2
        let visionImage = VisionImage(image: image)
        // 3
        textRecognizer.process(visionImage) { result, error in
            // 4
//            print("ERROR = \(error)")
            guard
                error == nil,
                let result = result,
                !result.text.isEmpty
                else {
                    callback(self.items)
                    return
            }
            // 5
            //callback(result.text)
            // process
            self.processReceipt(result: result)
//            self.processText(recognizedText: result.text)
            callback(self.items)
        }
    }
    
    private func processReceipt(result: VisionText) {
        self.items.removeAll()
        
        // 1. define farthest right x coordinate
        var endx: CGFloat = 0.0
        var endXMin: CGFloat = 0.0
        let thresholdXPct: CGFloat = 80.0
        let thresholdYPct: CGFloat = 40.0
        for block in result.blocks {
            print("MAX X = \(block.frame.maxX)")
            for line in block.lines {
                if line.text.contains(".") && line.text.count > 1 {
                    if endx < line.frame.maxX {
                        endx = line.frame.maxX
                    }
                }
            }
//            if let cornerPoints = block.cornerPoints {
//                for point in cornerPoints {
//                    if endx < point.cgPointValue.x {
//                        endx = point.cgPointValue.x
//                    }
//                }
//            }
        }
        print("endX Points = \(endx)")
        endXMin = endx - thresholdXPct*endx/100.0 // calculate threshold for x
        print("endX Min Points = \(endXMin)")
        
        // 2. construct sentence line by line. // find price
        var arrayYMin: [CGFloat] = []
        var arrayMoney : [String] = []
        var arrayText : [String] = []
        for block in result.blocks {
            for line in block.lines {
                print("line text \(line.text) frame = \(line.frame.minX) | \(endXMin)")
                if line.frame.minX >= endXMin {
                    var strNum = line.text.replacingOccurrences(of: " ", with: "")
                    strNum = strNum.replacingOccurrences(of: "$", with: "")
                    // in case the receipt has 'S' char
                    strNum = strNum.replacingOccurrences(of: "S", with: "")
                    // in case have '*'
                    strNum = strNum.replacingOccurrences(of: "*", with: "")
                    if strNum.contains(".") && strNum.count > 1 {
                        if Double(strNum) != nil  {
                            let price = strNum
                            let endYMin = line.frame.midY //- thresholdYPct*line.frame.maxY/100.0
                            arrayYMin.append(endYMin)
                            arrayMoney.append(price)
                            print("TEXT = \(line.text)")
                        }
                        
                    }
                }
            }
        }
        for block in result.blocks {
            for line in block.lines {
                print("TEXT LINE = \(line.text)")
                print("LINE FRAME = \(line.frame)")
                if arrayYMin.count == 0 {
                    break;
                }
                var idx: Int = 0
                for posY in arrayYMin {
                    print("LINE MID Y = \(line.frame.midY) vs \(posY))")
                    if abs((posY - line.frame.midY)) <= thresholdYPct && abs((posY - line.frame.midY)) > 0 {
//                        print("TEXT 2 = \(line.text)")
                        let abc = line.text.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: "*", with: "")
                        let set = NSCharacterSet.alphanumerics
                        if abc.rangeOfCharacter(from: set) == .none {

                        } else {
                            if (line.text.count > 1) {
                                arrayText.append(abc)
                                arrayYMin.remove(at: idx)
                                break
                            }
                        }
                    }
                    idx+=1
                }
            }
        }
        
        isGrandTotalFound = false
        
        var idx: Int = 0
        var idxText: Int = -1
        for text in arrayText {
            var isGst = false
            var isGrandTotal = false
            var isRoundingAmount = false
            print("Title = \(text)")
            print("Amount = \(arrayMoney[idx])")
            if text.uppercased().contains("GST") {
                isGst = true
            }
            if text.lowercased().contains("grand total") || text.lowercased().contains( "tota") {
                isGrandTotal = true
            }
            if text.lowercased().contains("rounding") {
                isRoundingAmount = true
            }
            
            if isGrandTotal == true && isGrandTotalFound == false {
                print("isgrandtotal = \(isGrandTotal)")
                let item = Item(name: text, price: (arrayMoney[idx] as NSString).floatValue, isGst: isGst, isGrandTotal: isGrandTotal, isRoundingAmount: isRoundingAmount)
                items.append(item)
                if idxText > -1 {
                    items.remove(at: idxText)
                }
                idxText = items.count-1
                idx+=1
            } else {
                if isGrandTotal == true {
                    isGrandTotalFound = true
                }
                
                if isGrandTotal == false {
                    //                print("TEXT LOWERCASED = \(text)")
                    if text.lowercased().contains("tota") {
                        if isGrandTotalFound == true {
                            idx+=1
                        }
                    } else {
                        print("text 23 = \(text)")
                        if text.lowercased().starts(with: "visa") || text.lowercased().starts(with: "master") || text.lowercased().starts(with: "cash") ||
                            text.lowercased().contains("tota") ||
                            text.lowercased().starts(with: "pay") ||
                            text.lowercased().contains("paid") ||
                            text.lowercased().starts(with: "rebate") ||
                            text.lowercased().starts(with: "amex") ||
                            text.lowercased().starts(with: "change") ||
                            text.lowercased().contains("inclu") ||
                            text.lowercased().contains("diners") ||
                            text.lowercased().contains("nets") ||
                            text.lowercased().contains("pts") ||
                            text.lowercased().contains("points") ||
                            text.lowercased().contains("vi8a") ||
                            text.lowercased().contains("ma8ter") ||
                            text.lowercased().contains("chainge") ||
                            text.lowercased().contains("subttl") ||
                            text.lowercased().contains("credit") ||
                            text.lowercased().contains("mana") ||
                            text.lowercased().contains("xxxxx") {//||
                            //                    (arrayMoney[idx] as NSString).floatValue == 0.0 {
                            idx+=1
                        } else {
                            //                    print("(arrayMoney[idx]).floatValue = \((arrayMoney[idx] as NSString).floatValue)")
                            let moneyFloat = (arrayMoney[idx] as NSString).floatValue
                            print("moneyFloat = \(moneyFloat)")
                            if moneyFloat > 0.0 || moneyFloat < 0.0 {
                                let item = Item(name: text, price: (arrayMoney[idx] as NSString).floatValue, isGst: isGst, isGrandTotal: isGrandTotal, isRoundingAmount: isRoundingAmount)
                                items.append(item)
                            }
                            idx+=1
                        }
                    }
                    
                }
            }
            
        }
        
    }
    
    // Split the processed text into lines and store
    // them into an array
    // Afterward, remove all the ones that requires
    private func processText(recognizedText: String){
        
        var allLines: [String] = []
        
        // Remove all element first before filling it up
        allLines.removeAll()
        self.items.removeAll()
        
        // Place processed text into new String
        //var text:String! = processedTextView.text
        var text:String! = recognizedText
        
        // Declare range to find \n
        var range:Range<String.Index>?
        
        // range attempts to find \n
        range = text.range(of: "\n")
        
        // Run loop while range is still able to find \n
        while range != nil {
            
            // Get index from beginning of text to \n
            let index = text.startIndex ..< (range?.lowerBound)!
            
            // Create the line of string with index
            let line = text[index]
            
            // Append the line
            allLines.append(String(line))
            
            // Get index for after the the \n to the end
            let index2 = text.index(after: (range?.lowerBound)!) ..< text.endIndex
            
            // Update the text with the index
            text = String(text[index2])
            
            // Attempts to find \n
            range = text.range(of: "\n")
        }
        
        // Remove all whitespace form allLines array
        allLines = allLines.filter{ !$0.trimmingCharacters(in: .whitespaces).isEmpty}
        
        for line in allLines {
            var isGst = false
            var isGrandTotal = false
            var isRoundingAmount = false
            if line.uppercased().contains("GST") {
                isGst = true
            }
            if line.lowercased().contains("grand total") || line.lowercased() == "total" {
                isGrandTotal = true
            }
            if line.lowercased().contains("rounding") {
                isRoundingAmount = true
            }
            let item = Item(name: line, price: 0, isGst: isGst, isGrandTotal: isGrandTotal, isRoundingAmount: isRoundingAmount)
            items.append(item)
        }
    }
    
}
