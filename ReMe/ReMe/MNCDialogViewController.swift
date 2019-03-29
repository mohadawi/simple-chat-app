
//  Created by Apple on 3/27/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit

protocol ViewBProtocol {
    func setData(data: NSMutableArray, idx rowindex: Int,lastMessageTime lastMsgTime:Date?)
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


class MNCDialogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
    
    
    @IBOutlet  var scrollView: UIScrollView!
    @IBOutlet  var messageEditField: UITextField!
    @IBOutlet  var historicalMessagesTableView: UITableView!
    private var activeTextField: UITextField?
    var chatMateId = ""
    var messageArray: NSMutableArray = []
    var myUserId = ""
    var rowFlg: Int = 0
    var delegate: ViewBProtocol?
    private var flag: Int = 0
    var  keybSize: CGSize?
    var lastMessageTime: Date? = nil
    
    
    // MARK: Boilerplate methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        historicalMessagesTableView.addGestureRecognizer(tap)
        flag = 1
        myUserId="moha"
        
        registerForKeyboardNotifications()
        
        navigationItem.title = chatMateId
        if messageArray == nil {
            messageArray = []
        }
        
        self.historicalMessagesTableView.rowHeight = UITableView.automaticDimension
        
        //set automatic height for tableview cell
        historicalMessagesTableView.estimatedRowHeight = 140
       
        retrieveMessagesFromParse(withChatMateID: chatMateId)
        
        self.historicalMessagesTableView.delegate = self
    }
    @objc override func dismissKeyboard() {
        messageEditField.endEditing(true)
    }
    
    // Setting up keyboard notifications.
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    @objc func keyboardWasShown(_ aNotification: Notification?) {
        let info = aNotification?.userInfo
        let kbSize: CGSize? = (info?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size
        keybSize=kbSize
        let contentInsets = UIEdgeInsets(top: 0, left: 0.0, bottom: (kbSize?.height)!, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect: CGRect = view.frame
        aRect.size.height -= kbSize?.height ?? 0.0
        if !aRect.contains((activeTextField?.frame.origin)!) {
            scrollView.scrollRectToVisible(activeTextField?.frame ?? CGRect.zero, animated: false)
        }
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    @objc func keyboardWillBeHidden(_ aNotification: Notification?) {
        let contentInsets: UIEdgeInsets = .zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        sendTextMessage(messageEditField.text, toRecipient: chatMateId)
        var contentInsets: UIEdgeInsets = .zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        /*
        contentInsets = UIEdgeInsets(top: -(keybSize?.height)!, left: 0.0, bottom: 0, right: 0.0)
        messageEditField.bounds.inset(by: contentInsets)
        var bkgndRect: CGRect = activeTextField!.superview!.frame
        bkgndRect.size.height += keybSize!.height
        activeTextField!.superview!.frame = bkgndRect
         */
         //messageEditField.bounds.y
    }
    
    func sendTextMessage(_ messageText: String?, toRecipient recipientId: String?) {
        
        //for testing purpose
        /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
         message:self.messageEditField.text
         delegate:nil
         cancelButtonTitle:@"OK"
         otherButtonTitles:nil];
         [alert show];*/
        
        //self.myUserId=@"moha";
        
        let currentDateTime = Date()
        lastMessageTime = currentDateTime
        
        let cell = MNCChatMessage()
        cell.text = messageEditField.text!
        cell.timestamp = currentDateTime
        cell.senderId="moha"// we can set the senderId for real application, here we used 2 demo ids 'moha' and 'ali'
        //we can add button for voice play!
        //[cell.button1 addTarget:self action:@selector(cellButton1Pressed:) forControlEvents:UIControlEventTouchUpInside];
        messageArray.add(cell)
        
        //echo message
        let cell1 = MNCChatMessage()
        cell1.text = messageEditField.text!
        cell1.timestamp = currentDateTime
        cell1.senderId="ali"
        //[cell.button1 addTarget:self action:@selector(cellButton1Pressed:) forControlEvents:UIControlEventTouchUpInside];
        messageArray.add(cell1)
        historicalMessagesTableView.reloadData() // will call the delegate again and refresh cells
        
        messageEditField.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //send chat data to parent viewcontoller
        sendData(data:messageArray, idx: rowFlg, msgTime: lastMessageTime)
        
    }
    
    func sendData(data: NSMutableArray, idx rowindex: Int, msgTime time:Date?) {
        var data = data
        //send data using protocol
        delegate!.setData(data:data, idx: rowindex, lastMessageTime: time)
    }
    
    // MARK: UITextFieldDelegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    func retrieveMessagesFromParse(withChatMateID chatMateId: String?) {
        let chatMessageArray = [NSDictionary]();
        // Store all retrieve messages into messageArray
        for i in 0..<chatMessageArray.count {
            let chatMessage = MNCChatMessage()
            chatMessage.messageId = chatMessageArray[i]["messageId"] as! String
            chatMessage.senderId = chatMessageArray[i]["senderId"] as! String
            chatMessage.recipientIds = [chatMessageArray[i]["recipientId"]]
            chatMessage.text = chatMessageArray[i]["text"] as! String
            chatMessage.timestamp = chatMessageArray[i]["timestamp"] as! Date
            self.messageArray.add(chatMessage)
        }
        self.historicalMessagesTableView.reloadData() // Refresh the table view
        //[weakSelf scrollTableToBottom];  // Scroll to the bottom of the table view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var messageCell = tableView.dequeueReusableCell(withIdentifier: "MessageListPrototypeCell", for: indexPath) as? MNCChatMessageCell
        configureCell(messageCell: &messageCell!, indexPath: indexPath)
        return messageCell!;
        //return UITableViewCell()
    }
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
        
    }*/

    func getLinesArrayFromLabel(label:UILabel) -> [String] {
    
    let text:NSString = label.text! as NSString // TODO: Make safe?
    let font:UIFont = label.font
    let rect:CGRect = label.frame
    
    let myFont:CTFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
    let attStr:NSMutableAttributedString = NSMutableAttributedString(string: text as String)
        attStr.addAttribute(NSAttributedString.Key(rawValue: String(kCTFontAttributeName)), value:myFont, range: NSMakeRange(0, attStr.length))
    let frameSetter:CTFramesetter = CTFramesetterCreateWithAttributedString(attStr as CFAttributedString)
    let path:CGMutablePath = CGMutablePath()
    path.addRect(CGRect(x:0, y:0, width:rect.size.width, height:100000))
    
    let frame:CTFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
    let lines = CTFrameGetLines(frame) as NSArray
    var linesArray = [String]()
    
    for line in lines {
    let lineRange = CTLineGetStringRange(line as! CTLine)
    let range:NSRange = NSMakeRange(lineRange.location, lineRange.length)
    let lineString = text.substring(with: range)
    linesArray.append(lineString as String)
    }
    return linesArray
    }

    func configureCell( messageCell: inout MNCChatMessageCell, indexPath: IndexPath) {
        
        let chatMessage: MNCChatMessage? = messageArray[indexPath.row] as? MNCChatMessage ;//indexPath.row ?? 0]
        
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        // get the date time String from the date object
        let time=formatter.string(from: (chatMessage?.timestamp)!)
        
        //append the time to the message
        // First get the last line in the message
        messageCell.chatMateMessageLabel!.text = chatMessage?.text
        let lines: [String] = getLinesArrayFromLabel(label: messageCell.chatMateMessageLabel!)
        let tmp :String
        var max=0
        for index in 0...lines.count-1 {
            if lines[index].count > max {
                max = index
            }
        }
        tmp = lines[max]
        let spaces = String(repeating: " ", count: (tmp.count + 2))
        print(max)
        print(tmp)
        print(tmp.count)
        
        let longString = "  " + (chatMessage?.text)! + "\n" + spaces + time
        let longestWord = time
        let longestWordRange = (longString as NSString).range(of: longestWord)
        
        let attributedString = NSMutableAttributedString(string: longString, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)])
        attributedString.setAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : UIColor.blue], range: longestWordRange)
        
        //make the messages round cornered
        messageCell.myMessageLabel!.layer.cornerRadius = messageCell.myMessageLabel!.frame.width/15
        messageCell.chatMateMessageLabel!.layer.cornerRadius = messageCell.chatMateMessageLabel!.frame.width/15
        
        //label.attributedText = attributedString
        
        //int i=1;
        //toggle between 'moha' and 'ali' to present a message followed by echo directly
        if flag % 2 == 0 {
            chatMessage?.senderId = "moha"
        } else {
            chatMessage?.senderId = "ali"
        }
        
        if (chatMessage?.senderId == myUserId) {
            // If the message was sent by me
            messageCell.chatMateMessageLabel!.text = ""
            messageCell.myMessageLabel!.attributedText = attributedString
            //messageCell.myMessageLabel!.layer.masksToBounds = true
            
        } else {
            // If the message was sent by the chat mate
            messageCell.myMessageLabel!.text = ""
            messageCell.chatMateMessageLabel!.attributedText = attributedString
        }
        
        if flag == 2 {
            flag = 1
        } else {
            flag += 1
        }
    }
}
