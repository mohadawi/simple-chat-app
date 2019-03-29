//  Created by Jane Appleseed on 10/17/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//""
import XCTest
@testable import ReMe

class ReMeTests: XCTestCase {
    
    //MARK: Contact Class Tests
    
    // Confirm that the Contact initializer returns a Contact object when passed valid parameters.
    func testContactInitializationSucceeds() {
        
        // nil time
        let nullTimeContact = Contact.init(name: "moha", photo: nil, lastMsgTime: "", lastMsgContent: "", msgHistory: NSMutableArray())
        XCTAssertNotNil(nullTimeContact)

    }
    
    // Confirm that the Contact initialier returns nil when passed a negative rating or an empty name.
    func testContactInitializationFails() {
        

        // Empty name
        let emptyStringContact = Contact.init(name: "", photo: nil, lastMsgTime: "", lastMsgContent: "", msgHistory: NSMutableArray())
        XCTAssertNil(emptyStringContact)
        
    }
}
