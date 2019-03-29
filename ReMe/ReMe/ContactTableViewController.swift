//  Created by Jane Appleseed on 10/17/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//
import UIKit

class ContactTableViewController: UITableViewController,ViewBProtocol {
    func setData(data: NSMutableArray, idx rowindex: Int, lastMessageTime lastMsgTime: Date?) {
        contacts[rowindex].messageArrayHistory = data
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        // get the date time String from the date object
        if(lastMsgTime != nil){
            let time=formatter.string(from: lastMsgTime!)
            contacts[rowindex].lastMsgTime = time
        }
        
        if(data.count>0){
            let msg = data[data.count-1] as! MNCChatMessage
            contacts[rowindex].lastMsgContent = msg.text
        }
        self.tableView.reloadData()
    }
    
   
    
    
    //MARK: Properties
    
    var contacts = [Contact]()
    var myUserId = ""
    //var messageArrayHistory: NSMutableArray = []
    var activeDialogViewController: MNCDialogViewController?
    var rowFlg: Int = 0


    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the sample data.
        loadSampleContacts()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ContactTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContactTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ContactTableViewCell.")
        }
        
        let contact = contacts[indexPath.row]
        
        cell.nameLabel.text = contact.name
        cell.photoImageView.image = contact.photo
        cell.lastMsgTimeLabel.text = contact.lastMsgTime
        cell.lastMsgLabel.text = contact.lastMsgContent
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    //MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "OpenDialogSegue") {
            activeDialogViewController = (segue.destination as! MNCDialogViewController)
            var chatMateIndex: Int? = nil
            if let sender = sender as? UITableViewCell {
                chatMateIndex = tableView.indexPath(for: sender)?.row
            }
            activeDialogViewController!.chatMateId = contacts[chatMateIndex ?? 0].name
            activeDialogViewController!.myUserId = "moha" //self.myUserId;
            activeDialogViewController!.messageArray = contacts[chatMateIndex ?? 0].messageArrayHistory!//messageArrayHistory[tableView.indexPathForSelectedRow?.row ?? 0]
            activeDialogViewController!.rowFlg = (tableView.indexPathForSelectedRow?.row)!
            activeDialogViewController!.delegate = self
            return
        }
    }

    
    //MARK: Private Methods
    
    private func loadSampleContacts() {
        
        let photo1 = UIImage(named: "m1")
        let photo2 = UIImage(named: "m2")
        let photo3 = UIImage(named: "m3")
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        
        // get the date time String from the date object
        let time=formatter.string(from: currentDateTime)

        guard let contact1 = Contact(name: "Moha dawi", photo: photo1, lastMsgTime: "", lastMsgContent: "", msgHistory: NSMutableArray() ) else {
            fatalError("Unable to instantiate contact1")
        }

        guard let contact2 = Contact(name: "Sousou", photo: photo2, lastMsgTime: "",lastMsgContent: "", msgHistory: NSMutableArray()) else {
            fatalError("Unable to instantiate contact2")
        }

        guard let contact3 = Contact(name: "Jordan Cat", photo: photo3, lastMsgTime: "",lastMsgContent: "", msgHistory: NSMutableArray()) else {
            fatalError("Unable to instantiate contact3")
        }

        contacts += [contact1, contact2, contact3]
    }

}
