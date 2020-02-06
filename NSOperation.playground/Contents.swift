import UIKit
import Foundation

// NSInvocationOperation
// 在arc下线程不安全，疑似被移除


// NSBlockOperation
func useInvocationOperation() {
    let op = BlockOperation.init {
        for _ in 0..<2 {
            sleep(2)
            print("1---", Thread.current)
        }
    }
    
    op.addExecutionBlock {
        for _ in 0..<2 {
            sleep(2)
            print("2---", Thread.current)
        }
    }
    
    op.addExecutionBlock {
        for _ in 0..<2 {
            sleep(2)
            print("3---", Thread.current)
        }
    }
    
    op.addExecutionBlock {
        for _ in 0..<2 {
            sleep(2)
            print("4---", Thread.current)
        }
    }
    
    op.addExecutionBlock {
        for _ in 0..<2 {
            sleep(2)
            print("5---", Thread.current)
        }
    }
    
    op.addExecutionBlock {
        for _ in 0..<2 {
            sleep(2)
            print("6---", Thread.current)
        }
    }
    
    op.start()
}

//useInvocationOperation()

enum ErrorType: Error {
    case ErrorTypeNil
    case ErrorType1
}

class TestOperation: Operation {
    
    override func main() {
        do {
            try autoreleasepool {
                var isDone = false
                // 响应取消事件
                while !isCancelled && !isDone {
                    // 执行任务操作
                    print("执行任务操作", Thread.current)
                    isDone = true
                }
            }
        } catch let error {
            print("ErrorType.ErrorTypeNil")
        } catch ErrorType.ErrorType1 {
            print("ErrorType.ErrorType1")
        } catch {
            
        }
    }
}

extension UIImage {
    
    func myDrawRectWithRoundedCorner(_ radius: CGFloat, size: CGSize) -> UIImage? {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius))
        context?.addPath(path.cgPath)
        context?.clip()
        draw(in: rect)
        context?.drawPath(using: .fillStroke)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UIView {
    func myAddCorner(_ radius: CGFloat, size: CGSize, bgColor: UIColor) {
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius))
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = bgColor.cgColor
        self.layer.addSublayer(layer)
    }
}
