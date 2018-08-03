import Foundation

public class Duration {
    private let depth: Int
    private var timingStack = [(startTime:Double, name:String, reported:Bool)]()

    public static func measure(_ name: String, depth: Int = 0, block: () -> Void) -> Double {
        let duration = Duration(depth)
        duration.startMeasurement(name)
        block()
        return duration.stopMeasurement()
    }

    public static func measureAndReturn<T>(_ name: String, depth: Int = 0, block: () -> T) -> T {
        let duration = Duration(depth)
        duration.startMeasurement(name)
        let rval: T = block()
        _ = duration.stopMeasurement()
        return rval
    }

    init(_ depth: Int = 0) {
        self.depth = depth
    }

    public func startMeasurement(_ name: String) {
        timingStack.append((now, name, false))
    }

    public func stopMeasurement() -> Double {
        return stopMeasurement(nil)
    }

    public func stopMeasurement(_ executionDetails: String?) -> Double {
        let endTime = now
        let beginning = timingStack.removeLast()
        let took = endTime - beginning.startTime

        print("\(depthIndent)\(beginning.name) took: \(took.milliSeconds)" + (executionDetails == nil ? "" : " (\(executionDetails!))"))
        return took
    }

    private var depthIndent: String {
        return String(repeating: "\t", count: depth)
    }

    private var now: Double {
        return Date().timeIntervalSinceReferenceDate
    }
}

private extension Double {
    var milliSeconds: String {
        return String(format: "%03.2fms", self*1000)
    }
}
