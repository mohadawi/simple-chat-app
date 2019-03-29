
//  Created by Apple on 3/27/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import Foundation
class MNCChatMessage: NSObject {
    var messageId = ""
    var recipientIds: [Any] = []
    var senderId = ""
    var text = ""
    var headers: [AnyHashable : Any] = [:]
    var timestamp: Date?
}
