//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell
{
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    private struct Mentions {
        static let hashtagsColor = UIColor.purpleColor()
        static let urlsColor = UIColor.blueColor()
        static let userColor = UIColor.orangeColor()
    }
    
    func updateUI() {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            //tweetTextLabel?.text = tweet.text
            let text = tweet.text

            if tweetTextLabel?.text != nil  {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }
            
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.changeKeywordsColor(tweet.hashtags, color: Mentions.hashtagsColor)
            attributedText.changeKeywordsColor(tweet.urls, color: Mentions.urlsColor)
            attributedText.changeKeywordsColor(tweet.userMentions, color: Mentions.userColor)
            
            tweetTextLabel?.attributedText = attributedText
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                if let imageData = NSData(contentsOfURL: profileImageURL) { // blocks main thread!
                    tweetProfileImageView?.image = UIImage(data: imageData)
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }

    }
}

// MARK: - Extensions

private extension NSMutableAttributedString {
    func changeKeywordsColor(keywords: [Tweet.IndexedKeyword], color: UIColor){
        for keyword in keywords {
            addAttribute(NSForegroundColorAttributeName, value: color, range: keyword.nsrange)
        }
    }
}
