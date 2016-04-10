//
//  RankTableViewCell.swift
//  CrappyBirds
//
//  Created by caoyuxin on 4/9/16.
//

import UIKit
import RealmSwift

class RankTableViewCell: UITableViewCell {


    let realm = try! Realm()
    var recordKey : String = "" {
        didSet(newRecord) {
            if recordKey != "" || self.realm.objects(Record).filter("compoundKey == '\(recordKey)'").count > 0 {
                let record = self.realm.objects(Record).filter("compoundKey == '\(recordKey)'").first!
                usernameLabel.text = record.username
                scoreLabel.text = String(record.score)
                let date = NSDate(timeIntervalSince1970: record.time)
                timeLabel.text = NSDateFormatter.localizedStringFromDate(date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
            }
        }
    }
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
}
