//
//  ProjectsTests.swift
//  ProjectsTests
//
//  Created by Alexander Yuzhin on 02.12.2021.
//

import XCTest
@testable import Runner

class ProjectsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        
        AccountsManager.start()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1ReadAllAccounts() throws {
        // Sample read all accounts as json string
        print(AccountsManager.shared.exportAccounts() ?? "")
    }

    func test2AddAccount() throws {
        AccountsManager.shared.add(string: """
           {
               "displayName": "Yuzhin Alexander",
               "email": "alexander.yuzhin@portal.com",
               "avatar": "/storage/userPhotos/root/28db9c8d-ec03-4d83-b16a-2b5171642f00_size_360-360.png",
               "portal": "https://test.portal.com",
               "token": "111"
           }
        """);
        
        let account = AccountsManager.shared.get(by: "https://test.portal.com", email: "alexander.yuzhin@portal.com")
        
        XCTAssertNotNil(account)
    }
    
    func test3UpdateAccount() throws {
        AccountsManager.shared.update(string: """
           {
               "displayName": "Yuzhin Alexander",
               "email": "alexander.yuzhin@portal.com",
               "avatar": "/storage/userPhotos/root/28db9c8d-ec03-4d83-b16a-2b5171642f00_size_360-360.png",
               "portal": "https://test.portal.com",
               "token": "222"
           }
        """);
        
        let account = AccountsManager.shared.get(by: "https://test.portal.com", email: "alexander.yuzhin@portal.com")
        
        XCTAssertEqual(account?.token, "222")
    }
    
    func test4RemoveAccount() throws {
        AccountsManager.shared.remove(string: """
           {
               "displayName": "Yuzhin Alexander",
               "email": "alexander.yuzhin@portal.com",
               "avatar": "/storage/userPhotos/root/28db9c8d-ec03-4d83-b16a-2b5171642f00_size_360-360.png",
               "portal": "https://test.portal.com",
               "token": "222"
           }
        """);
        
        let account = AccountsManager.shared.get(by: "https://test.portal.com", email: "alexander.yuzhin@portal.com")
        
        XCTAssertNil(account)
    }

}
