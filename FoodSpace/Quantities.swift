//
//  Quantities.swift
//  FoodSpace
//
//  Created by Corey Howell on 10/2/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import Foundation
import Foundation
import UIKit

struct Quantities {
    
    static let zeroToHundredStringIntDictionary: [String: Int] = [
        "0": 0,
        "1": 1,
        "2": 2,
        "3": 3,
        "4": 4,
        "5": 5,
        "6": 6,
        "7": 7,
        "8": 8,
        "9": 9,
        
        "10": 10,
        "11": 11,
        "12": 12,
        "13": 13,
        "14": 14,
        "15": 15,
        "16": 16,
        "17": 17,
        "18": 18,
        "19": 19,
        
        "20": 20,
        "21": 21,
        "22": 22,
        "23": 23,
        "24": 24,
        "25": 25,
        "26": 26,
        "27": 27,
        "28": 28,
        "29": 29,
        
        "30": 30,
        "31": 31,
        "32": 32,
        "33": 33,
        "34": 34,
        "35": 35,
        "36": 36,
        "37": 37,
        "38": 38,
        "39": 39,
        
        "40": 40,
        "41": 41,
        "42": 42,
        "43": 43,
        "44": 44,
        "45": 45,
        "46": 46,
        "47": 47,
        "48": 48,
        "49": 49,
        
        "50": 50,
        "51": 51,
        "52": 52,
        "53": 53,
        "54": 54,
        "55": 55,
        "56": 56,
        "57": 57,
        "58": 58,
        "59": 59,
        
        "60": 60,
        "61": 61,
        "62": 62,
        "63": 63,
        "64": 64,
        "65": 65,
        "66": 66,
        "67": 67,
        "68": 68,
        "69": 69,
        
        "70": 70,
        "71": 71,
        "72": 72,
        "73": 73,
        "74": 74,
        "75": 75,
        "76": 76,
        "77": 77,
        "78": 78,
        "79": 79,
        
        "80": 80,
        "81": 81,
        "82": 82,
        "83": 83,
        "84": 84,
        "85": 85,
        "86": 86,
        "87": 87,
        "88": 88,
        "89": 89,
        
        "90": 90,
        "91": 91,
        "92": 92,
        "93": 93,
        "94": 94,
        "95": 95,
        "96": 96,
        "97": 97,
        "98": 98,
        "99": 99,
        
        "100": 100
    ]
    
    static let zeroToHundredStringArray: [String] = [
        "",
        "0",
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        
        "10",
        "11",
        "12",
        "13",
        "14",
        "15",
        "16",
        "17",
        "18",
        "19",
        
        "20",
        "21",
        "22",
        "23",
        "24",
        "25",
        "26",
        "27",
        "28",
        "29",
        
        "30",
        "31",
        "32",
        "33",
        "34",
        "35",
        "36",
        "37",
        "38",
        "39",
        
        "40",
        "41",
        "42",
        "43",
        "44",
        "45",
        "46",
        "47",
        "48",
        "49",
        
        "50",
        "51",
        "52",
        "53",
        "54",
        "55",
        "56",
        "57",
        "58",
        "59",
        
        "60",
        "61",
        "62",
        "63",
        "64",
        "65",
        "66",
        "67",
        "68",
        "69",
        
        "70",
        "71",
        "72",
        "73",
        "74",
        "75",
        "76",
        "77",
        "78",
        "79",
        
        "80",
        "81",
        "82",
        "83",
        "84",
        "85",
        "86",
        "87",
        "88",
        "89",
        
        "90",
        "91",
        "92",
        "93",
        "94",
        "95",
        "96",
        "97",
        "98",
        "99",
        
        "100"
    ]
    
    
    // Use like makeIntoFraction(123, denomiator: 45678) // returns "¹²³⁄₄₅₆₇₈"
    static func makeIntoFractionString(numerator: Int, denominator: Int) -> String {
        let superscriptDigits = Array("⁰¹²³⁴⁵⁶⁷⁸⁹".characters);
        let subscriptDigits = Array("₀₁₂₃₄₅₆₇₈₉".characters);
        
        let zeroBias = UnicodeScalar("0").value
        let supers = "\(numerator)".unicodeScalars.map { superscriptDigits[Int($0.value - zeroBias)] }
        let subs = "\(denominator)".unicodeScalars.map { subscriptDigits[Int($0.value - zeroBias)] }
        
        return String(supers + [ "⁄" ] + subs)
    }
    
    enum Fraction: Double {
        case None = 0.0
        case Tenth =  0.1
        case Eighth = 0.125
        case Seventh = 0.142857
        case Sixth = 0.166667
        case Fifth = 0.2
        case Fourth = 0.25
        case Third = 0.333333333333333
        case Half = 0.5
        case TwoThirds = 0.666666666666667
        case ThreeQuarters = 0.75
        case SevenEighths = 0.875
        
        static let allFractions = [None, Tenth, Eighth, Seventh, Sixth, Fifth, Fourth, Third, Half, TwoThirds, ThreeQuarters, SevenEighths];
    }
    
    static func getFraction(fraction: Fraction) -> String {
        switch fraction {
        case .None:
            return ""
        case .Tenth:
            return makeIntoFractionString(numerator: 1, denominator: 10)
        case .Eighth:
            return makeIntoFractionString(numerator: 1, denominator: 8)
        case .Seventh:
            return makeIntoFractionString(numerator: 1, denominator: 7)
        case .Sixth:
            return makeIntoFractionString(numerator: 1, denominator: 6)
        case .Fifth:
            return makeIntoFractionString(numerator: 1, denominator: 5)
        case .Fourth:
            return makeIntoFractionString(numerator: 1, denominator: 4)
        case .Third:
            return makeIntoFractionString(numerator: 1, denominator: 3)
        case .Half:
            return makeIntoFractionString(numerator: 1, denominator: 2)
        case .TwoThirds:
            return makeIntoFractionString(numerator: 2, denominator: 3)
        case .ThreeQuarters:
            return makeIntoFractionString(numerator: 3, denominator: 4)
        case .SevenEighths:
            return makeIntoFractionString(numerator: 7, denominator: 8)
        }
    }
    
    static func getAllFractionsStringArray() -> [String] {
        var list = [String]();
        for fraction in Fraction.allFractions {
            let value = getFraction(fraction: fraction);
            list.append(value);
        }
        return list;
    }
    
    static func getFractionStringFromDecimal(decimal: Double) -> (fractionString: String, wholeNumber: Int) {
        // get decimals only
        let _decimal = removeWholeNumberFromDecimal(decimal: decimal)
        print(_decimal)
        
        let decimals = _decimal.decimals
        let wholeNumber = _decimal.wholeNumber
        
        // no fraction to return if there are no decimal places
        if (decimals == 0) {
            return ("", wholeNumber)
        }
        
        let approximation = rationalApproximationOf(x0: decimals);
        let numerator = approximation.num;
        let denominator = approximation.den;
        
        return (makeIntoFractionString(numerator: numerator, denominator: denominator), wholeNumber);
    }
    
    fileprivate static func removeWholeNumberFromDecimal(decimal: Double) -> (decimals: Double, wholeNumber: Int) {
        var justDecimals: Double = Double(round(decimal)) - decimal
        
        // check if justDecimals is actually 0
        if justDecimals == 0 {
            return (0, Int(decimal));
        }
        print(justDecimals)
        
        var wholeNumber = Int((decimal) - justDecimals)
        
        if justDecimals < 0 {
            justDecimals += 1
            wholeNumber = Int((decimal + 1) - justDecimals)
        }
        
        // make sure there even is a whole number, otherwise we're returning a 1 incorrectly
        if (decimal < 1) {
            wholeNumber = 0
        }
        
        return (1 - justDecimals, wholeNumber)
    }
    
    
    static func findFractionEnumFromFractionString(fractionAsString: String) -> Fraction? {
        for fraction in Fraction.allFractions {
            if (getFraction(fraction: fraction) == fractionAsString) {
                return fraction;
            }
        }
        return nil;
    }
    
    typealias Rational = (num : Int, den : Int)
    
    fileprivate static func rationalApproximationOf(x0 : Double, withPrecision eps : Double = 1.0E-6) -> Rational {
        var x = x0
        var a = floor(x)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)
        
        while x - a > eps * Double(k) * Double(k) {
            x = 1.0/(x - a)
            a = floor(x)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        return (h, k)
    }
    
    static let unitsStringArray: [String] = ["", "cups", "fl oz", "grams", "kg", "lbs", "liters", "milligrams", "ml", "oz", "pints", "quarts", "tblsps", "tsp"];
}
