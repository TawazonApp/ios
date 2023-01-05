//
//  UIColor+Additions.swift
//  NewLife App
//
//  Generated on Zeplin. (2/25/2019).
//  Copyright (c) 2019 __MyCompanyName__. All rights reserved.
//

import UIKit

/// MissingHashMarkAsPrefix:   "Invalid RGB string, missing '#' as prefix"
/// UnableToScanHexValue:      "Scan hex error"
/// MismatchedHexStringLength: "Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8"
public enum UIColorInputError: Error {
  case missingHashMarkAsPrefix
  case unableToScanHexValue
  case mismatchedHexStringLength
  case outputHexStringForWideDisplayColor
}

extension UIColor {
    
    class var duskyBlue: UIColor {
        return UIColor(red: 77.0 / 255.0, green: 83.0 / 255.0, blue: 171.0 / 255.0, alpha: 1.0)
    }
    
    class var iris: UIColor {
        return UIColor(red: 111.0 / 255.0, green: 94.0 / 255.0, blue: 174.0 / 255.0, alpha: 1.0)
    }
    
    class var wisteria: UIColor {
        return UIColor(red: 177.0 / 255.0, green: 116.0 / 255.0, blue: 194.0 / 255.0, alpha: 1.0)
    }
    
    class var peachyPink: UIColor {
        return UIColor(red: 1.0, green: 141.0 / 255.0, blue: 141.0 / 255.0, alpha: 1.0)
    }
    
    class var midnight: UIColor {
        return UIColor(red: 7.0 / 255.0, green: 3.0 / 255.0, blue: 25.0 / 255.0, alpha: 1.0)
    }
    
    class var midnightExpress: UIColor{
        return UIColor(red: 24.0 / 255.0, green: 23.0 / 255.0, blue: 37.0 / 255.0, alpha: 1.0)
    }

    class var darkBlueGrey: UIColor {
        return UIColor(red: 16.0 / 255.0, green: 15.0 / 255.0, blue: 55.0 / 255.0, alpha: 1.0)
    }
    
    class var darkGreyBlue: UIColor {
        return UIColor(red: 52.0 / 255.0, green: 45.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
    }
    
    class var grape: UIColor {
        return UIColor(red: 85.0 / 255.0, green: 57.0 / 255.0, blue: 95.0 / 255.0, alpha: 1.0)
    }
    
    class var lightPlum: UIColor {
        return UIColor(red: 157.0 / 255.0, green: 87.0 / 255.0, blue: 115.0 / 255.0, alpha: 1.0)
    }
    
    class var powderPink: UIColor {
        return UIColor(red: 1.0, green: 165.0 / 255.0, blue: 230.0 / 255.0, alpha: 1.0)
    }
    
    class var lighterPurple: UIColor {
        return UIColor(red: 142.0 / 255.0, green: 96.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
    }
    
    class var mediumPurple: UIColor {
        return UIColor(red: 156.0 / 255.0, green: 135.0 / 255.0, blue: 231.0 / 255.0, alpha: 1.0)
    }
    
    class var hanPurple: UIColor {
        return UIColor(red: 65.0 / 255.0, green: 40.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }

    class var bubblegum: UIColor {
        return UIColor(red: 250.0 / 255.0, green: 113.0 / 255.0, blue: 205.0 / 255.0, alpha: 1.0)
    }
    
    class var lightPurple: UIColor {
        return UIColor(red: 196.0 / 255.0, green: 113.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    }
    
    class var babyPurple: UIColor {
        return UIColor(red: 181.0 / 255.0, green: 151.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    class var perrywinkle: UIColor {
        return UIColor(red: 119.0 / 255.0, green: 144.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    }
    
    class var paleOliveGreen: UIColor {
        return UIColor(red: 175.0 / 255.0, green: 225.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0)
    }
    
    class var paleTeal: UIColor {
        return UIColor(red: 117.0 / 255.0, green: 213.0 / 255.0, blue: 143.0 / 255.0, alpha: 1.0)
    }
    
    class var salmon: UIColor {
        return UIColor(red: 237.0 / 255.0, green: 130.0 / 255.0, blue: 130.0 / 255.0, alpha: 1.0)
    }
    
    class var bubbleGumPink: UIColor {
        return UIColor(red: 245.0 / 255.0, green: 113.0 / 255.0, blue: 176.0 / 255.0, alpha: 1.0)
    }
    
    class var dark: UIColor {
        return UIColor(red: 23.0 / 255.0, green: 32.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
    }
    
    class var blueberry: UIColor {
        return UIColor(red: 58.0 / 255.0, green: 50.0 / 255.0, blue: 147.0 / 255.0, alpha: 1.0)
    }
    
    class var camoGreen: UIColor {
        return UIColor(red: 69.0 / 255.0, green: 80.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
    }
    
    class var darkNavyBlue: UIColor {
        return UIColor(red: 0.0, green: 0.0, blue: 2.0 / 255.0, alpha: 1.0)
    }
    
    class var darkTwo: UIColor {
        return UIColor(red: 37.0 / 255.0, green: 58.0 / 255.0, blue: 54.0 / 255.0, alpha: 1.0)
    }
    
    class var darkBlueGreyTwo: UIColor {
        return UIColor(red: 35.0 / 255.0, green: 28.0 / 255.0, blue: 79.0 / 255.0, alpha: 1.0)
    }
    
    class var darkBlueGreyThree: UIColor {
        return UIColor(red: 29.0 / 255.0, green: 38.0 / 255.0, blue: 79.0 / 255.0, alpha: 1.0)
    }
    
    class var darkFour: UIColor {
        return UIColor(red: 17.0 / 255.0, green: 15.0 / 255.0, blue: 28.0 / 255.0, alpha: 1.0)
    }
    
    class var lightSlateBlue: UIColor {
        return UIColor(red: 143 / 255.0, green: 142 / 255.0, blue: 255 / 255.0, alpha: 1.0)
    }
    
    class var lightSlateBlueTwo: UIColor {
        return UIColor(red: 99 / 255.0, green: 116 / 255.0, blue: 255 / 255.0, alpha: 1.0)
    }
    
    class var slateBlue: UIColor {
        return UIColor(red: 108 / 255.0, green: 87 / 255.0, blue: 198 / 255.0, alpha: 1.0)
    }
    
    class var mediumSlateBlue: UIColor {
        return UIColor(red: 184 / 255.0, green: 109 / 255.0, blue: 239 / 255.0, alpha: 1.0)
    }
    
    class var mediumSlateBlueTwo: UIColor {
        return UIColor(red: 139 / 255.0, green: 130 / 255.0, blue: 236 / 255.0, alpha: 1.0)
    }
    
    class var aquamarine: UIColor {
        return UIColor(red: 99 / 255.0, green: 255 / 255.0, blue: 190 / 255.0, alpha: 1.0)
    }
    
    class var screaminGreen: UIColor{
        return UIColor(red: 99 / 255.0, green: 255 / 255.0, blue: 137 / 255.0, alpha: 1.0)
    }

    class var babyBlue: UIColor{
        return UIColor(red: 99 / 255.0, green: 228 / 255.0, blue: 255 / 255.0, alpha: 1.0)
    }
    
    class var mayaBlueTwo: UIColor{
        return UIColor(red: 99 / 255.0, green: 155 / 255.0, blue: 255 / 255.0, alpha: 1.0)
    }
    
    class var bittersweet:UIColor{
        return UIColor(red: 255 / 255.0, green: 99 / 255.0, blue: 99 / 255.0, alpha: 1.0)
    }
    
    class var burntSienna: UIColor{
        return UIColor(red: 242 / 255.0, green: 97 / 255.0, blue: 98 / 255.0, alpha: 1.0)
    }

    class var facebookColor: UIColor {
        return UIColor(red: 26 / 255.0, green: 118 / 255.0, blue: 242 / 255.0, alpha: 1.0)
    }
    
    class var brightLilac: UIColor {
        return UIColor(red: 212.0 / 255.0, green: 113.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0)
    }
    
    class var orangePink: UIColor {
        return UIColor(red: 1.0, green: 107.0 / 255.0, blue: 88.0 / 255.0, alpha: 1.0)
    }
    class var carnation: UIColor {
        return UIColor(red: 241.0 / 255.0, green: 122.0 / 255.0, blue: 151.0 / 255.0, alpha: 1.0)
    }
    
    class var periwinkleBlue: UIColor {
        return UIColor(red: 169.0 / 255.0, green: 155.0 / 255.0, blue: 253.0 / 255.0, alpha: 1.0)
    }
    
    class var periwinkle: UIColor {
        return UIColor(red: 161.0 / 255.0, green: 136.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0)
    }
    
    class var lavender: UIColor {
        return UIColor(red: 221.0 / 255.0, green: 176.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0)
    }
    
    class var carnationTwo: UIColor {
        return UIColor(red: 238.0 / 255.0, green: 129.0 / 255.0, blue: 134.0 / 255.0, alpha: 1.0)
    }
    
    class var lavenderPink: UIColor {
        return UIColor(red: 224.0 / 255.0, green: 113.0 / 255.0, blue: 225.0 / 255.0, alpha: 1.0)
    }
    
    class var carnationThree: UIColor {
        return UIColor(red: 238.0 / 255.0, green: 126.0 / 255.0, blue: 139.0 / 255.0, alpha: 1.0)
    }
    
    class var lavenderBlue: UIColor {
        return UIColor(red: 139.0 / 255.0, green: 133.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0)
    }
    
    class var liliac: UIColor {
        return UIColor(red: 179.0 / 255.0, green: 147.0 / 255.0, blue: 241.0 / 255.0, alpha: 1.0)
    }
    
    class var liliacTwo: UIColor {
        return UIColor(red: 192.0 / 255.0, green: 134.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    class var periwinkleBlueTwo: UIColor {
        return UIColor(red: 152.0 / 255.0, green: 171.0 / 255.0, blue: 251.0 / 255.0, alpha: 1.0)
    }
    
    class var lightUrple: UIColor {
        return UIColor(red: 140.0 / 255.0, green: 108.0 / 255.0, blue: 249.0 / 255.0, alpha: 1.0)
    }
    
    class var pastelPurple: UIColor {
        return UIColor(red: 186.0 / 255.0, green: 168.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)
    }
    
    class var paleMauve: UIColor {
        return UIColor(red: 251.0 / 255.0, green: 194.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    }
    
    class var mauve: UIColor {
        return UIColor(red: 220.0 / 255.0, green: 171.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    }
    
    class var moodyBlue: UIColor {
        return UIColor(red: 111.0 / 255.0, green: 107.0 / 255.0, blue: 192.0 / 255.0, alpha: 1.0)
    }

    
    class var palePurple: UIColor {
        return UIColor(red: 161.0 / 255.0, green: 140.0 / 255.0, blue: 209.0 / 255.0, alpha: 1.0)
    }
    
    class var cornflower: UIColor {
        return UIColor(red: 116.0 / 255.0, green: 144.0 / 255.0, blue: 251.0 / 255.0, alpha: 1.0)
    }
    
    class var periwinkleTwo: UIColor {
        return UIColor(red: 163.0 / 255.0, green: 123.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    class var pastelPurpleTwo: UIColor {
        return UIColor(red: 201.0 / 255.0, green: 165.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    class var purpley: UIColor {
        return UIColor(red: 128.0 / 255.0, green: 105.0 / 255.0, blue: 210.0 / 255.0, alpha: 1.0)
    }
    
    class var darkIndigo: UIColor {
        return UIColor(red: 33.0 / 255.0, green: 12.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0)
    }
    
    class var darkIndigoTwo: UIColor {
        return UIColor(red: 15.0 / 255.0, green: 25.0 / 255.0, blue: 69.0 / 255.0, alpha: 1.0)
    }
    
    class var tolopea: UIColor {
        return UIColor(red: 36.0 / 255.0, green: 33.0 / 255.0, blue: 59.0 / 255.0, alpha: 1.0)
    }
    
    class var cherryPie: UIColor {
        return UIColor(red: 53.0 / 255.0, green: 48.0 / 255.0, blue: 87.0 / 255.0, alpha: 1.0)
    }

    class var meteorite: UIColor {
        return UIColor(red: 64.0 / 255.0, green: 58.0 / 255.0, blue: 105.0 / 255.0, alpha: 1.0)
    }
    
    class var gulfBlue: UIColor {
        return UIColor(red: 64.0 / 255.0, green: 58.0 / 255.0, blue: 105.0 / 255.0, alpha: 1.0)
    }
    
    class var waikawaGrey: UIColor {
        return UIColor(red: 106.0 / 255.0, green: 110.0 / 255.0, blue: 148.0 / 255.0, alpha: 1.0)
    }
    
    class var blueberryTwo: UIColor {
        return UIColor(red: 69.0 / 255.0, green: 49.0 / 255.0, blue: 138.0 / 255.0, alpha: 1.0)
    }
    
    class var lightBlue: UIColor {
        return UIColor(red: 152.0 / 255.0, green: 206.0 / 255.0, blue: 251.0 / 255.0, alpha: 1.0)
    }
    
    class var blackTwo: UIColor {
        return UIColor(red: 18.0 / 255.0, green: 18.0 / 255.0, blue: 15.0 / 255.0, alpha: 1.0)
    }
    
    class var periwinkleBlueThree: UIColor {
        return UIColor(red: 154.0 / 255.0, green: 147.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0)
    }
    
    class var carolinaBlue: UIColor {
        return UIColor(red: 142.0 / 255.0, green: 174.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    class var darkishPink: UIColor {
        return UIColor(red: 245.0 / 255.0, green: 49.0 / 255.0, blue: 127.0 / 255.0, alpha: 1.0)
    }
    
    class var salmonTwo: UIColor {
        return UIColor(red: 1.0, green: 124.0 / 255.0, blue: 110.0 / 255.0, alpha: 1.0)
    }
    
    class var darkSlateBlue: UIColor {
        return UIColor(red: 33.0 / 255.0, green: 60.0 / 255.0, blue: 106.0 / 255.0, alpha: 1.0)
    }
    
    class var lightBlueGrey: UIColor {
        return UIColor(red: 199.0 / 255.0, green: 206.0 / 255.0, blue: 217.0 / 255.0, alpha: 1.0)
    }
    
    class var charcoalGrey: UIColor {
        return UIColor(red: 43.0 / 255.0, green: 40.0 / 255.0, blue: 47.0 / 255.0, alpha: 1.0)
    }
    
    class var charcoalGreyTwo: UIColor {
        return UIColor(red: 67.0 / 255.0, green: 63.0 / 255.0, blue: 73.0 / 255.0, alpha: 1.0)
    }
    
    class var lynch: UIColor {
        return UIColor(red: 99.0 / 255.0, green: 120.0 / 255.0, blue: 139.0 / 255.0, alpha: 1.0)
    }
    
    class var sanJuan: UIColor {
        return UIColor(red: 62.0 / 255.0, green: 90.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0)
    }
    class var cornflowerTwo: UIColor {
        return UIColor(red: 99.0 / 255.0, green: 116.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    class var lightPink: UIColor {
        return UIColor(red: 243.0 / 255.0, green: 231.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0)
    }
    
    class var veryLightBlue: UIColor {
        return UIColor(red: 231.0 / 255.0, green: 237.0 / 255.0, blue: 243.0 / 255.0, alpha: 1.0)
    }
    
    class var lightPeach: UIColor {
        return UIColor(red: 247.0 / 255.0, green: 216.0 / 255.0, blue: 208.0 / 255.0, alpha: 1.0)
    }
    class var cyprus: UIColor {
        return UIColor(red: 15.0 / 255.0, green: 38.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
    }
    
    class var mayaBlue: UIColor{
        return UIColor(red: 93.0 / 255.0 , green: 214.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    class var royalBlue: UIColor{
        return UIColor(red: 68.0 / 255.0, green: 119.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    }
    
    class var lavenderTwo: UIColor {
        return UIColor(red: 189.0 / 255.0, green: 164.0 / 255.0, blue: 231.0 / 255.0, alpha: 1.0)
    }
    
    class var lightGold: UIColor {
        return UIColor(red: 1.0, green: 213.0 / 255.0, blue: 96.0 / 255.0, alpha: 1.0)
    }
    
    class var darkSeven: UIColor {
        return UIColor(red: 53.0 / 255.0, green: 51.0 / 255.0, blue: 76.0 / 255.0, alpha: 1.0)
    }
    
    class var midnightBlue: UIColor {
        return UIColor(red: 16.0 / 255.0, green: 39.0 / 255.0, blue: 91.0 / 255.0, alpha: 1.0)
    }
    
    class var midnightBlueTwo: UIColor {
        return UIColor(red: 17 / 255.0, green: 25 / 255.0, blue: 66 / 255.0, alpha: 1.0)
    }
    
    class var dusk: UIColor {
        return UIColor(red: 62.0 / 255.0, green: 60.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
    }
    
    class var duskTwo: UIColor {
        return UIColor(red: 82.0 / 255.0, green: 79.0 / 255.0, blue: 116.0 / 255.0, alpha: 1.0)
    }
    
    class var pale: UIColor {
        return UIColor(red: 1.0, green: 240.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
    }
    
    class var paleRose: UIColor {
        return UIColor(red: 249.0 / 255.0, green: 195.0 / 255.0, blue: 198.0 / 255.0, alpha: 1.0)
    }
    
    class var lightBlueGreyThree: UIColor {
        return UIColor(red: 186.0 / 255.0, green: 207.0 / 255.0, blue: 227.0 / 255.0, alpha: 1.0)
    }
    
    class var metallicBlue: UIColor {
        return UIColor(red: 83.0 / 255.0, green: 120.0 / 255.0, blue: 149.0 / 255.0, alpha: 1.0)
    }
    
    class var darkIndigoFive: UIColor {
        return UIColor(red: 9.0 / 255.0, green: 32.0 / 255.0, blue: 63.0 / 255.0, alpha: 1.0)
    }
    
    class var veryLightPink: UIColor {
        return UIColor(red: 1.0, green: 251.0 / 255.0, blue: 243.0 / 255.0, alpha: 1.0)
    }
    
    class var paleGreyTwo: UIColor {
        return UIColor(red: 246.0 / 255.0, green: 240.0 / 255.0, blue: 1.0, alpha: 1.0)
    }
    
    class var irisTwo: UIColor {
        return UIColor(red: 96.0 / 255.0, green: 87.0 / 255.0, blue: 198.0 / 255.0, alpha: 1.0)
    }
    
    class var slateGrey: UIColor {
        return UIColor(red: 109.0 / 255.0, green: 109.0 / 255.0, blue: 115.0 / 255.0, alpha: 1.0)
    }
    
    class var duskBlue: UIColor {
        return UIColor(red: 61.0 / 255.0, green: 37.0 / 255.0, blue: 122.0 / 255.0, alpha: 1.0)
    }
    
    class var haiti: UIColor{
        return UIColor(red: 35.0 / 255.0, green: 35.0 / 255.0, blue: 47.0 / 255.0, alpha: 1.0)
    }
    
    class var veniceBlue: UIColor{
        return UIColor(red: 40.0 / 255.0, green: 69.0 / 255.0, blue: 110.0 / 255.0, alpha: 1.0)
    }
    
    class var deepLilac: UIColor{
        return UIColor(red: 145.0 / 255.0, green: 85.0 / 255.0, blue: 195.0 / 255.0, alpha: 1.0)
    }

    class var freeSpeechBlue: UIColor{
        return UIColor(red: 86.0 / 255.0, green: 85.0 / 255.0, blue: 195.0 / 255.0, alpha: 1.0)
    }
    
    class var columbiaBlue: UIColor{
        return UIColor(red: 142.0 / 255.0, green: 214.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    class var paleCornflowerBlue: UIColor{
        return UIColor(red: 195.0 / 255.0, green: 169.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    }

    class var regalBlue: UIColor{
        return UIColor(red: 22.0 / 255.0, green: 39.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)
    }

    class var mariner: UIColor{
        return UIColor(red: 65.0 / 255.0, green: 79.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0)
    }
    
    class var macaroniAndCheese: UIColor{
        return UIColor(red: 255.0 / 255.0, green: 177.0 / 255.0, blue: 133.0 / 255.0, alpha: 1.0)
    }

    class var carnationPink: UIColor{
        return UIColor(red: 159.0 / 255.0, green: 179.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }

    class var tacao: UIColor{
        return UIColor(red: 242.0 / 255.0, green: 164.0 / 255.0, blue: 119.0 / 255.0, alpha: 1.0)
    }
    
    class var darkPink: UIColor{
        return UIColor(red: 229.0 / 255.0, green: 71.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0)
    }
    
    class var christalle: UIColor{
        return UIColor(red: 47.0 / 255.0, green: 28.0 / 255.0, blue: 91.0 / 255.0, alpha: 1.0)
    }
    
    class var tiber: UIColor{
        return UIColor(red: 18.0 / 255.0, green: 35.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
    }

    class var magnolia: UIColor{
        return UIColor(red: 230.0 / 255.0, green: 227.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }

    class var licorice: UIColor{
        return UIColor(red: 43.0 / 255.0, green: 53.0 / 255.0, blue: 68.0 / 255.0, alpha: 1.0)
    }

    class var eastBay: UIColor{
        return UIColor(red: 72.0 / 255.0, green: 88.0 / 255.0, blue: 107.0 / 255.0, alpha: 1.0)
    }

    class var lightCoral: UIColor{
        return UIColor(red: 241.0 / 255.0, green: 116.0 / 255.0, blue: 137.0 / 255.0, alpha: 1.0)
    }
    class var ceSoir: UIColor{
        return UIColor(red: 157.0 / 255.0, green: 88.0 / 255.0, blue: 163.0 / 255.0, alpha: 1.0)
    }

    class var blueZodiac: UIColor{
        return UIColor(red: 59.0 / 255.0, green: 72.0 / 255.0, blue: 88.0 / 255.0, alpha: 1.0)
    }

    class var heliotrope: UIColor{
        return UIColor(red: 22.0 / 255.0, green: 39.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)
    }
    class var heliotropeTwo: UIColor{
        return UIColor(red: 183 / 255.0, green: 91 / 255.0, blue: 250 / 255.0, alpha: 1.0)
    }
    class var roseBud: UIColor{
        return UIColor(red: 255.0 / 255.0, green: 162.0 / 255.0, blue: 162.0 / 255.0, alpha: 1.0)
    }
    
    class var elephant: UIColor{
        return UIColor(red: 42.0 / 255.0, green: 58.0 / 255.0, blue: 69.0 / 255.0, alpha: 1.0)
    }
    
    class var lightSkyBlue: UIColor{
        return UIColor(red: 152.0 / 255.0, green: 171.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }

    class var ghostWhite: UIColor{
        return UIColor(red: 247 / 255.0, green: 248 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    class var ghostWhiteTwo: UIColor{
        return UIColor(red: 245 / 255.0, green: 245 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    class var eastSide: UIColor{
        return UIColor(red: 173.0 / 255.0, green: 155.0 / 255.0, blue: 195.0 / 255.0, alpha: 1.0)
    }

    class var mediumOrchid: UIColor{
        return UIColor(red: 160 / 255.0, green: 77 / 255.0, blue: 218 / 255.0, alpha: 1.0)
    }
    
    class var rockBlue: UIColor{
        return UIColor(red: 147 / 255.0, green: 147 / 255.0, blue: 189 / 255.0, alpha: 1.0)
    }
    
    class var governorBay: UIColor{
        return UIColor(red: 87 / 255.0, green: 99 / 255.0, blue: 153 / 255.0, alpha: 1.0)
    }

    class var linkWater: UIColor{
        return UIColor(red: 201 / 255.0, green: 203 / 255.0, blue: 217 / 255.0, alpha: 1.0)
    }
    class var blueHaze: UIColor{
        return UIColor(red: 194 / 255.0, green: 194 / 255.0, blue: 213 / 255.0, alpha: 1.0)
    }
    class var catalinaBlue: UIColor{
        return UIColor(red: 33 / 255.0, green: 43 / 255.0, blue: 83 / 255.0, alpha: 1.0)
    }
    class var gainsboro: UIColor{
        return UIColor(red: 216 / 255.0, green: 216 / 255.0, blue: 216 / 255.0, alpha: 1.0)
    }
    
    class var chambray: UIColor{
        return UIColor(red: 63 / 255.0, green: 94 / 255.0, blue: 123 / 255.0, alpha: 1.0)
    }
    class var jellyBean: UIColor{
        return UIColor(red: 68 / 255.0, green: 122 / 255.0, blue: 149 / 255.0, alpha: 1.0)
    }

    class var paua: UIColor{
        return UIColor(red: 35 / 255.0, green: 43 / 255.0, blue: 80 / 255.0, alpha: 1.0)
    }
}


extension UIColor{
    /// The rgba string representation of color with alpha of the form #RRGGBBAA/#RRGGBB, fails to default color.
    ///
    /// - parameter rgba: String value.
    public convenience init(_ rgba: String, defaultColor: UIColor = UIColor.clear) {
      guard let color = try? UIColor(rgbaThrows: rgba) else {
        self.init(cgColor: defaultColor.cgColor)
        return
      }

      self.init(cgColor: color.cgColor)
    }
    
    /// The rgba string representation of color with alpha of the form #RRGGBBAA/#RRGGBB, throws error.
    ///
    /// - parameter rgba: String value.
    public convenience init(rgbaThrows rgba: String) throws {
      guard rgba.hasPrefix("#") else {
        throw UIColorInputError.missingHashMarkAsPrefix
      }

      let hexString = String(rgba[String.Index(utf16Offset: 1, in: rgba)...])
      var hexValue: UInt32 = 0

      guard Scanner(string: hexString).scanHexInt32(&hexValue) else {
        throw UIColorInputError.unableToScanHexValue
      }

      switch hexString.count {
      case 3:
        self.init(hex3: UInt16(hexValue))
      case 4:
        self.init(hex4: UInt16(hexValue))
      case 6:
        self.init(hex6: hexValue)
      case 8:
        self.init(hex8: hexValue)
      default:
        throw UIColorInputError.mismatchedHexStringLength
      }
    }
    
    /// The shorthand three-digit hexadecimal representation of color.
    /// #RGB defines to the color #RRGGBB.
    ///
    /// - parameter hex3: Three-digit hexadecimal value.
    /// - parameter alpha: 0.0 - 1.0. The default is 1.0.
    public convenience init(hex3: UInt16, alpha: CGFloat = 1) {
      let divisor = CGFloat(15)
      let red = CGFloat((hex3 & 0xF00) >> 8) / divisor
      let green = CGFloat((hex3 & 0x0F0) >> 4) / divisor
      let blue = CGFloat( hex3 & 0x00F) / divisor
      self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// The shorthand four-digit hexadecimal representation of color with alpha.
    /// #RGBA defines to the color #RRGGBBAA.
    ///
    /// - parameter hex4: Four-digit hexadecimal value.
    public convenience init(hex4: UInt16) {
      let divisor = CGFloat(15)
      let red = CGFloat((hex4 & 0xF000) >> 12) / divisor
      let green = CGFloat((hex4 & 0x0F00) >> 8) / divisor
      let blue = CGFloat((hex4 & 0x00F0) >> 4) / divisor
      let alpha = CGFloat( hex4 & 0x000F       ) / divisor
      self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// The six-digit hexadecimal representation of color of the form #RRGGBB.
    ///
    /// - parameter hex6: Six-digit hexadecimal value.
    public convenience init(hex6: UInt32, alpha: CGFloat = 1) {
      let divisor = CGFloat(255)
      let red = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
      let green = CGFloat((hex6 & 0x00FF00) >> 8) / divisor
      let blue = CGFloat( hex6 & 0x0000FF       ) / divisor
      self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// The six-digit hexadecimal representation of color with alpha of the form #RRGGBBAA.
    ///
    /// - parameter hex8: Eight-digit hexadecimal value.
    public convenience init(hex8: UInt32) {
      let divisor = CGFloat(255)
      let red = CGFloat((hex8 & 0xFF000000) >> 24) / divisor
      let green = CGFloat((hex8 & 0x00FF0000) >> 16) / divisor
      let blue = CGFloat((hex8 & 0x0000FF00) >> 8) / divisor
      let alpha = CGFloat( hex8 & 0x000000FF       ) / divisor
      self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

}
