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
        ("testAssociated", testAssociated)
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
        XCTAssertEqual(array.deduplication(for: \.id), [.init(id: 0, name: "a"), .init(id: 1, name: "b")])
        
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

extension ExtensionsTests {
    
    private static var testAssociated1Key: Void?
    private static var testAssociated2Key: Void?
    
    func testAssociated() {
        
        let object = NSObject()
        
        do {
            let number = 123
            
            let old: Int? = object.associated.get(&ExtensionsTests.testAssociated1Key)
            
            XCTAssertNil(old)
            
            object.associated.set(assign: &ExtensionsTests.testAssociated1Key, number)
            
            let new: Int? = object.associated.get(&ExtensionsTests.testAssociated1Key)
            
            XCTAssertEqual(new, number)
        }
        
        do {
            let number = NSString(format: "%d", 321)
            
            let old: NSString? = object.associated.get(&ExtensionsTests.testAssociated2Key)
            
            XCTAssertNil(old)
            
            object.associated.set(retain: &ExtensionsTests.testAssociated2Key, number)
            
            let new: NSString? = object.associated.get(&ExtensionsTests.testAssociated2Key)
            
            XCTAssertEqual(new, number)
        }
    }
}

extension ExtensionsTests {
    
    func testEncode() {
        struct Model: Codable, Equatable {
            let name: String
            let id: Int
        }
        
        // 结构体string data model 转换
        do {
            let model: Model = .init(name: "a", id: 0)
            let json = #"{"name":"a","id":0}"#
            XCTAssertEqual(try model.jsonString(), json)
            XCTAssertEqual(try model.jsonData().jsonString(), json)
            XCTAssertEqual(model, try JSONDecoder().decode(Model.self, from: model.jsonString()))
            XCTAssertEqual(model, try JSONDecoder().decode(Model.self, from: model.jsonData()))
            
            if let string = try? model.jsonData().toJSON() as? [String: Any] {
                print(string)
            }

            if let string = try? model.toJSON() as? [String: Any] {
                print(string)
            }

            if let string = try? json.toJSON() as? [String: Any] {
                print(string)
            }
        }
        
        // 数组string data model 转换
        do {
            let json = #"[{"name":"a","id":0},{"name":"b","id":1},{"name":"c","id":2}]"#
            let array: [Model] = [.init(name: "a", id: 0), .init(name: "b", id: 1), .init(name: "c", id: 2)]
            
            XCTAssertEqual(try array.jsonString() , json)
            XCTAssertEqual(array, try JSONDecoder().decode([Model].self, from: array.jsonString()))
            XCTAssertEqual(array, try JSONDecoder().decode([Model].self, from: array.jsonData()))
            
            if let string = try? array.jsonData().toJSON() {
                print(string)
            }
            
            if let string = try? array.toJSON() {
                print(string)
            }
            
            if let string = try? array.toJSON() {
                print(string)
            }
        }
    }
}
