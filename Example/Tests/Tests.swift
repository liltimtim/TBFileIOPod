import UIKit
import XCTest
import TBFileIOPod

class TBFileIOTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        FileIO.shared.purgeAllCreatedFolders()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        FileIO.shared.purgeAllCreatedFolders()
    }
    
    func testFileExistsAtPath() {
        XCTAssertFalse(FileIO.shared.fileExists("TestFolder"))
    }
    
    func testCreateFolderWithName() {
        FileIO.shared.purgeAllCreatedFolders()
        XCTAssertNil(FileIO.shared.createFolder(withName: "MyFolder"))
        XCTAssertTrue(FileIO.shared.fileExists(FileIO.shared.documentsDirectory!.URLByAppendingPathComponent("MyFolder").path!))
    }
    
    func testCreateFolderWithExistingName() {
        FileIO.shared.purgeAllCreatedFolders()
        XCTAssertNil(FileIO.shared.createFolder(withName: "MyFolder"))
        XCTAssertTrue(FileIO.shared.fileExists(FileIO.shared.documentsDirectory!.URLByAppendingPathComponent("MyFolder").path!))
        XCTAssertNotNil(FileIO.shared.createFolder(withName: "MyFolder"))
    }
    
    func testRemoveFolderWithName() {
        XCTAssertNil(FileIO.shared.createFolder(withName: "MyFolder_Test1"))
        XCTAssertTrue(FileIO.shared.fileExists(FileIO.shared.documentsDirectory!.URLByAppendingPathComponent("MyFolder_Test1").path!))
        XCTAssertNil(FileIO.shared.removeFolder(withName: "MyFolder_Test1"))
        XCTAssertFalse(FileIO.shared.fileExists(FileIO.shared.documentsDirectory!.URLByAppendingPathComponent("MyFolder_Test1").path!))
    }
    
    func testPurgeAllFolders() {
        let purge = FileIO.shared.purgeAllCreatedFolders()
        print(purge)
    }
    
    func testCreateObject() {
        XCTAssertNil(FileIO.shared.writeObjectToFile(destinationFolder: "MyFile", withObject: NSData(), withFileName: "TestFileName"))
    }
    
    func testRemoveFileInFolder() {
        XCTAssertNil(FileIO.shared.writeObjectToFile(destinationFolder: "MyFolder", withObject: NSData(), withFileName: "MyObject"))
        XCTAssertNil(FileIO.shared.removeFile(fromFolder: "MyFolder", fileName: "MyObject"))
    }
    
    func testRemoveFileInFolderFileDoesNotExist() {
        XCTAssertNotNil(FileIO.shared.removeFile(fromFolder: "MyFolder", fileName: "MyObject"))
    }
    
    func testListAllFolders() {
        XCTAssertNil(FileIO.shared.createFolder(withName: "MyFolder"))
        XCTAssertNil(FileIO.shared.createFolder(withName: "MyFolder1"))
        XCTAssertEqual(FileIO.shared.listFolders()?.count, 2)
    }
    
    func testGetDataFromFileAtPath() {
        let exp = expectationWithDescription("get object from file")
        XCTAssertNil(FileIO.shared.createFolder(withName: "MyFolder"))
        XCTAssertNil(FileIO.shared.writeObjectToFile(destinationFolder: "MyFolder", withObject: NSData(), withFileName: "MyObject"))
        FileIO.shared.getContentsOfFile(fromFolder: "MyFolder", fromFile: "MyObject") { (object, error) in
            XCTAssertNotNil(object)
            XCTAssertNil(error)
            print(error)
            exp.fulfill()
        }
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
}
