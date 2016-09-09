//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"


func getFormattedStringFromDate(date: NSDate) -> String {
    // set date formatter
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyy-M-d"
    return formatter.stringFromDate(date)
}

let today = NSDate()
let ninetyDaysAgo = NSDate(timeInterval: 7776000.0, sinceDate: today)

getFormattedStringFromDate(today)
getFormattedStringFromDate(ninetyDaysAgo)

