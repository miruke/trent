//
//  TimeEntry.swift
//  trent Watch App
//
//  Created by Ren Zhongkai on 6/2/24.
//

import Foundation

class TimeEntry : Hashable {
    var hour: Int? = nil
    var minute: Int? = nil
    var rides: [String] = []
    
    var lastHour: Int = 4
    var lastMinute: Int = 0
    
    init(text:String) {
        let MIN_LENGTH = 7
        if text.count >= MIN_LENGTH {
            self.hour = Int(text.prefix(2))!
            self.minute = Int(text.prefix(5).suffix(2))!
            let rest = text.suffix(text.count + 1 - MIN_LENGTH)
            self.rides = rest.map { String($0) }
        }
    }
    
    init(hour:Int, minute:Int, rides: String? = "") {
        self.hour = hour
        self.minute = minute
        if rides!.count > 0 {
            self.rides = rides!.map { String($0) }
        }
    }
    
    // Implementing Equatable protocol
    static func ==(lhs: TimeEntry, rhs: TimeEntry) -> Bool {
        return lhs.hour == rhs.hour && lhs.minute == rhs.minute && lhs.rides == rhs.rides
    }
    
    // Implementing Hashable protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hour)
        hasher.combine(self.minute)
        hasher.combine(self.rides.joined())
    }
    
    func id() -> Int {
        var hasher = Hasher()
        self.hash(into: &hasher)
        return hasher.finalize()
    }
    
    static func readToArray(file: String) -> [TimeEntry] {
        return FileReader.readToArray(file: file).compactMap { str -> TimeEntry? in
            let entry = TimeEntry(text: str)
            if entry.hour == nil || entry.minute == nil {
                return nil
            }
            return entry
        }
    }
    
    static func getCurrentHourAndMinute() -> (hour: Int, minute: Int) {
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        return (hour, minute)
    }
    
    /**
     * Compare entries
     * @return true if first is later or equal than the second
     * otherwise false
     */
    func afterOrEqual(target: TimeEntry, lastHour: Int? = 4, lastMinute: Int? = 0) -> Bool {
        return self.timeValue(lastHour: lastHour!, lastMinute: lastMinute!) >= target.timeValue(lastHour: lastHour!, lastMinute: lastMinute!)
    }
    
    func toText(padding: Int = -1) -> String {
        if self.hour == nil || self.minute == nil {
            return "h?:m?"
        }
        return String(format: "%02d:%02d %@", self.hour!, self.minute!, String(repeating: " ", count: (padding > 0 ? padding : 0)) + self.rides.joined())
    }
    
    func timeValue(lastHour:Int=4, lastMinute:Int=0) -> Int {
        if self.hour == nil || self.minute == nil {
            return -1
        }
        let val = self.hour! * 60 + self.minute!
        if val >= 0 && val <= (lastHour * 60 + lastMinute) {
            return val + 1440
        }
        return val
    }
    
    static func findNext(entries:[TimeEntry]) -> TimeEntry? {
        let (hh, mm) = TimeEntry.getCurrentHourAndMinute()
        return TimeEntry.findAfter(entries: entries, hh: hh, mm: mm)
    }
    
    static func findAfter(entries:[TimeEntry], hh: Int, mm: Int) -> TimeEntry? {
        let target = TimeEntry(hour: hh, minute: mm)
        let last = entries.last
        if let index = entries.firstIndex(where: { $0.afterOrEqual(target: target, lastHour: last?.hour, lastMinute: last?.minute) }) {
            return entries[index]
        }
        return nil
    }
}
