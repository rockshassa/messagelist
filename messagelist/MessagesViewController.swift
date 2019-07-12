//
//  ViewController.swift
//  messagelist
//
//  Created by Nicholas Galasso on 7/9/19.
//  Copyright © 2019 Rockshassa. All rights reserved.
//

import UIKit

class MessagesViewController: UITableViewController {

    var page:String?
    var fetching = false
    var messageList = [Message]()
    var messageHeights = [IndexPath:CGFloat]()
    var imageCache:NSCache<NSString,UIImage> = {
        let c = NSCache<NSString,UIImage>()
        c.countLimit = 100 //cache up to ~100 avatars
        return c
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if page == nil, !fetching {
            fetching = true
            API.fetchMessages(completion: responseHandler)
        }
    }
    
    var responseHandler:RequestCompletion {
        return { [weak self] (responseCode) in
            switch responseCode {
                
            case .success(let response):
                let first = self!.messageList.count-1
                let last = first+response.messages.count-1
                
                self?.messageList.append(contentsOf: response.messages)
                self?.page = response.pageToken
                
                var indexes = [IndexPath]()
                for i in first...last {
                    indexes.append(IndexPath(row: i, section: 0))
                }
                self?.tableView.insertRows(at: indexes, with: .fade)
                
            case .failure(let error):
                print(error?.localizedDescription ?? "unknown error")
            }
            self?.fetching = false
        }
    }
}

//MARK:- UITableView Data Source

extension MessagesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        let msg = messageList[indexPath.row]
        
        cell.contentLabel.text = msg.content
        
        if let img = imageCache.object(forKey: msg.author.photoUrl as NSString) {
            cell.avatar.image = img
        } else {
            fetchImage(msg.author.photoUrl, indexPath: indexPath)
        }
        
        return cell
    }
}

//MARK:- UITableViewDelegate

extension MessagesViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == messageList.count-3, page != nil, !fetching {
            fetching = true
            API.fetchMessages(page, completion: responseHandler)
        }
        messageHeights[indexPath] = cell.frame.size.height
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return messageHeights[indexPath] ?? 50
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (action, indexPath) in
            self?.messageList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return [delete]
    }
}

//MARK:- Image fetching and cacheing

extension MessagesViewController {
    
    func fetchImage(_ urlString:String, indexPath:IndexPath){
        
        //todo: prevent multiple requests for the same url occurring at once
        
        let url = API.baseUrl.appendingPathComponent(urlString)
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, resp, error) in
            guard let imgData = data, let image = UIImage(data: imgData) else {
                print("error fetching image")
                return
            }
            
            self?.imageCache.setObject(image, forKey: urlString as NSString)
            
            DispatchQueue.main.async {
                if let cell = self?.tableView.cellForRow(at: indexPath) as? MessageCell {
                    cell.avatar.image = image
                }
            }
        }.resume()
    }
}
