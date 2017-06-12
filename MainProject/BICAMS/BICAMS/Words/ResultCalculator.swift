//
//  ResultCalculator.swift
//  SiriDemo
//
//  Created by Balázs Bojrán on 2017. 04. 21..
//  Copyright © 2017. Balázs Bojrán. All rights reserved.
//

import Foundation
import CoreData

extension Date {
    
    static func getPatientAge() -> Int {
        
        let now = Date()
        let birthday: Date = patient!.birthDate! as Date
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
        
        return age
    }
    
    func toString() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
        
        return dateFormatter.string(from: self)
    }
    
    static func date(from: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
        
        return dateFormatter.date(from: from)!
    }
    
    func getMonthAndDay() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd."
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
        
        return dateFormatter.string(from: self)
    }
    
    func getMonth() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
        
        return dateFormatter.string(from: self)
    }
    
    func getDay() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
        
        return dateFormatter.string(from: self)
    }
}

extension NSDate {
    
    func year() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
        
        return dateFormatter.string(from: self as Date)
    }
    
    func toString() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd."
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
        
        return dateFormatter.string(from: self as Date)
    }
    
    class func date(from: String) -> NSDate {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
        
        return dateFormatter.date(from: from)! as NSDate
    }
}

class ResultCalculator {
    
    let scoreTable = ScoreTable()
    
    var result = Result(context: managedObjectContext!)
    
    let fetchRequest: NSFetchRequest<Result> = Result.fetchRequest()
    
    var tScore: Int = 0
    
    func calculate() {
        
        if patient != nil {
            
            result.patient = patient
            
            result.date = Date() as NSDate
            
            var finalScore: Int32
            
            if tScore < 5 {
                
                finalScore = 0
                
            } else {
                
                switch Int((patient?.sexType)!) {
                case 0:
                    finalScore = Int32(calculateFemaleScore())
                case 1:
                    finalScore = Int32(calculateMaleScore())
                default:
                    finalScore = 0
                }
            }
            
            result.point = finalScore
            result.normative = calculateNormativeResult(from: finalScore)
            result.personal = calculatePersonalResult(from: finalScore)
            
            patient?.addToResults(result)
            
            try? managedObjectContext?.save()
        }
    }
    
    private func calculateFemaleScore() -> Int {
        
        let ageIndex = scoreTable.getAgeIndex(by: Date.getPatientAge())
        
        return scoreTable.female[tScore]![ageIndex]
    }
    
    private func calculateMaleScore() -> Int {
        
        let ageIndex = scoreTable.getAgeIndex(by: Date.getPatientAge())
        
        return scoreTable.male[tScore]![ageIndex]
    }
    
    private func calculateNormativeResult(from finalScore: Int32) -> String {
        
        var normative: String
        
        switch Int(finalScore) {
        case 0...19:
            normative = "Nagyon gyenge"
        case 20...29:
            normative = "Gyenge"
        case 30...39:
            normative = "Átlag alatti"
        case 40...60:
            normative = "Átlagos"
        case 61...70:
            normative = "Átlag feletti"
        case 71...80:
            normative = "Jó"
        default:
            normative = "Nagyon jó"
        }
        
        return normative
    }
    
    private func calculatePersonalResult(from finalScore: Int32) -> String {
        
        var personal: String
        
        switch Int(finalScore) {
        case 0...19:
            personal = "Súlyos károsodás"
        case 20...29:
            personal = "Közepes károsodás"
        case 30...39:
            personal = "Enyhe károsodás"
        default:
            personal = "Normál"
        }
        
        return personal
    }
}








