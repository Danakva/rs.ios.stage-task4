import Foundation

public extension Int {
    private enum Roman: Int, CaseIterable {
        case i = 1
        case v = 5
        case x = 10
        case l = 50
        case c = 100
        case d = 500
        case m = 1000
        case max = 4000
        
        var textRepresent: String {
            switch self {
            case .i: return "I"
            case .v: return "V"
            case .x: return "X"
            case .l: return "L"
            case .c: return "C"
            case .d: return "D"
            case .m: return "M"
            case .max: return "MM"
            }
        }
        
        var specialDif: Roman {
            switch self {
            case .i, .v: return .i
            case .x, .l: return .x
            case .c, .d: return .c
            case .m, .max: return .m
            }
        }
    }
    
    var roman: String? {
        var result: String = ""
        let romans = Array(Roman.allCases.reversed())
        for (index, roman) in romans.enumerated() {
            if self == roman.rawValue {
                result.append(roman.textRepresent)
            } else if self >= roman.rawValue {
                let temp = proceed(value: self, lower: roman, upper: romans[index-1], temp: roman.specialDif)
                result.append(temp.0)
                if temp.1 > 0 {
                    result.append(temp.1.roman ?? "")
                }
            }
        }
        return self <= 0 ? nil : result
    }

    private func proceed(value: Int, lower: Roman, upper: Roman, temp: Roman) -> (String, Int) {
        switch value {
        case lower.rawValue:
            return (lower.textRepresent, 0)
        case lower.rawValue+1 ..< upper.rawValue - temp.rawValue:
            return (lower.textRepresent, value - lower.rawValue)
        case upper.rawValue - temp.rawValue ..< upper.rawValue:
            let res = temp.textRepresent.appending(upper.textRepresent)
            let newValue = value - upper.rawValue + temp.rawValue
            return (res, newValue)
        default:
            return ("", 0)
        }
    }
}
