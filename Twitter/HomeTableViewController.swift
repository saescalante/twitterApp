//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Santiago Escalante  on 3/4/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    
    let myRefreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        //load the view
        super.viewDidLoad()
        //load the tweet
        loadTweets()
        //refresh
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    @objc func loadTweets(){
        numberOfTweets = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            //clear array
            self.tweetArray.removeAll()
            //repopulate array with tweets from timeline
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            //update table
            self.tableView.reloadData()
            //end refresh
            self.myRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("Could not load tweet!")
        })
    }
    
    
    func loadMoreTweets(){
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        numberOfTweets = numberOfTweets + 20
        let myParams = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            //clear array
            self.tweetArray.removeAll()
            //repopulate array with tweets from timeline
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            //update table
            self.tableView.reloadData()
            //end refresh
            self.myRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("Could not load tweet!")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if indexPath.row + 1 == tweetArray.count{
            loadMoreTweets()
        }
    }
    

    @IBAction func onLogout(_ sender: Any) {
        //logout call to API
        TwitterAPICaller.client?.logout();
        //return to login page
        self.dismiss(animated: true, completion: nil)
        //set value for userLoggedIn key to false
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCellTableViewCell
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        //Display content from Twitter API
        cell.userNameLabel.text = user["name"] as! String
        cell.TweetContent.text = tweetArray[indexPath.row]["text"] as! String
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data{
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
 

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of rows
        return tweetArray.count
    }

   
}
