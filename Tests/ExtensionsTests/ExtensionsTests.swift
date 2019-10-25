import XCTest
@testable import Extensions

final class ExtensionsTests: XCTestCase {
    
    func testExample() {
    }
    
    func testDispatch() {
        DispatchQueue.global().async {
            XCTAssertFalse(Thread.current.isMainThread)
            DispatchQueue.sync(safe: .main) {
                XCTAssertTrue(Thread.current.isMainThread)
            }
        }
        // 主线程安全sync
        DispatchQueue.sync(safe: .main) {
            XCTAssertTrue(Thread.current.isMainThread)
        }
        
        // 并行队列sync 则在主线程执行
        DispatchQueue.sync(safe: .global()) {
            XCTAssertTrue(Thread.current.isMainThread)
        }
        
        // 串行队列sync 则在主线程执行
        DispatchQueue.sync(safe: .init(label: "com.test.queue")) {
            XCTAssertTrue(Thread.current.isMainThread)
        }
    }
    
    

    static var allTests = [
        ("testExample", testExample),
        ("testDispatch", testDispatch),
        ("testArray", testArray),
        ("testTimeInterval", testTimeInterval),
        ("testDate", testDate),
    ]
}

extension ExtensionsTests {
    
    func testArray() {
        struct Model: Equatable {
            let id: Int
            var name: String
        }
        let array: [Model] = [.init(id: 0, name: "a"), .init(id: 1, name: "b"), .init(id: 0, name: "c")]
        
        // 过滤重复元素
        XCTAssertEqual(array.filtered(duplication: \.id), [.init(id: 0, name: "a"), .init(id: 1, name: "b")])
        
        // 获取指定条件元素的下标集合
        XCTAssertEqual(array.indexs({ $0.id == 0 }), [0, 2])
        
        // 更新某元素
        var temp = array
        temp.update(object: .init(id: 0, name: "c")) { (element) in
            element.name = "e"
        }
        XCTAssertEqual(temp, [.init(id: 0, name: "a"), .init(id: 1, name: "b"), .init(id: 0, name: "e")])
        
        do {
            var array: [Int] = []
            XCTAssertEqual(array.safeRemoveFirst(), nil)
            XCTAssertEqual(array, [])
        }
        do {
            var array: [Int] = [0]
            XCTAssertEqual(array.safeRemoveFirst(), 0)
            XCTAssertEqual(array, [])
        }
        
        do {
            var array: [Int] = []
            XCTAssertEqual(array.safeRemoveLast(), nil)
            XCTAssertEqual(array, [])
        }
        do {
            var array: [Int] = [0, 1]
            XCTAssertEqual(array.safeRemoveLast(), 1)
            XCTAssertEqual(array, [0])
        }
    }
}

extension ExtensionsTests {
    
    func testTimeInterval() {
        let date = Date()
        do {
            let time: TimeInterval = date.timeIntervalSince1970
            XCTAssertGreaterThanOrEqual(time.toDate(.since1970), date)
        }
        do {
            let time: TimeInterval = date.timeIntervalSinceNow
            XCTAssertGreaterThanOrEqual(time.toDate(.sinceNow), date)
        }
    }
    
    func testDate() {
        let date = Date()
        print(date.constellation ?? "")
    }
}
