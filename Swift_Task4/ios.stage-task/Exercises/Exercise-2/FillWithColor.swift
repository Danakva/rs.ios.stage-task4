import Foundation

final class FillWithColor {
    
    class Element {
        var value: Int
        weak var left: Element?
        weak var right: Element?
        weak var top: Element?
        weak var bot: Element?
        
        init?(_ value: Int?) {
            guard let value = value else { return nil }
            self.value = value
        }
        
        func applyColor(startColor: Int, newColor: Int) {
            if value == startColor {
                value = newColor
                top?.applyColor(startColor: startColor, newColor: newColor)
                bot?.applyColor(startColor: startColor, newColor: newColor)
                left?.applyColor(startColor: startColor, newColor: newColor)
                right?.applyColor(startColor: startColor, newColor: newColor)
            }
        }
    }
    
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        var result = [[Element]]()
        for i in 0..<image.count {
            var column = [Element]()
            for j in 0..<image[i].count {
                if let el = Element(image[i][j]) {
                    column.append(el)
                }
            }
            result.append(column)
        }
        for i in 0..<image.count {
            for j in 0..<image[i].count {
                let element = result[i][j]
                element.top = result[safe: i-1]?[safe: j]
                element.bot = result[safe: i+1]?[safe: j]
                element.left = result[safe: i]?[safe: j-1]
                element.right = result[safe: i]?[safe: j+1]
            }
        }
        if let element = result[safe: row]?[safe: column] {
            guard element.value == newColor else {
                element.applyColor(startColor: element.value, newColor: newColor)
                return result.map { $0.map { $0.value }}
            }
            return image
        } else if row == 0, column == 0 {
            return [[newColor]]
        } else {
            return image
        }
    }
}

extension Array {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
