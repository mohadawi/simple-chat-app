//  Created by Jane Appleseed on 10/17/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//
import UIKit

class Contact {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var lastMsgTime: String
    var lastMsgContent: String
    var messageArrayHistory: NSMutableArray?
    
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, lastMsgTime: String, lastMsgContent: String, msgHistory: NSMutableArray) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }

        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.lastMsgTime = lastMsgTime
        self.lastMsgContent = lastMsgContent
        self.messageArrayHistory = msgHistory
        
    }
}
