//
//  APIClient.swift
//  flickr-Search
//
//  Created by Paul Tangen on 5/5/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import Foundation

class APIClient {
    
    class func searchFlicker(tags: String, completion: @escaping (Bool) -> Void) {
        
        let store = DataStore.sharedInstance
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?tagmode=any&format=json&nojsoncallback=1&tags=\(tags)"
        print(urlString)
        let url = URL(string: urlString)
        if let url = url {
            var request = URLRequest(url: url)
            
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                
                if let unwrappedData = data {
                    store.items.removeAll()
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as? [String: Any]
                        if let responseJSON = responseJSON {
                            if let itemsDictAny = responseJSON["items"] {
                                
                                let itemsDict = itemsDictAny as! [[String:Any]]
                                var itemsUnsorted = [Item]()
                                
                                //unwrap the incoming data and populate item array in datastore
                                for itemDict in itemsDict {
                                    if let title = itemDict["title"] as? String {
                                        if let link = itemDict["link"] as? String {
                                            if let mediaDict = itemDict["media"] as? [String:String] {
                                                if let media = mediaDict["m"] {
                                                    if let date_takenString = itemDict["date_taken"] as? String {
                                                        if let description = itemDict["description"] as? String {
                                                            if let author = itemDict["author"] as? String {
                                                                if let tags = itemDict["tags"] as? String {
                                                                    
                                                                    // find width
                                                                    //let descriptionChars = description.characters
//                                                                    let widthStartIndex = description.characters.index(of: "w")
//                                                                    if let widthRange = description.range(of: "width") {
//                                                                        //let tld = description[widthRange]                 // "com"
//                                                                        //print("widthRange = \(widthRange)")
//                                                                    }
                                                                    //print("widthStartIndex = \(widthStartIndex)")
                                                                    
                                                                    // Convert date_takenString to Date
                                                                    let dateFormat = DateFormatter()
                                                                    dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss-SS:SS"
                                                                    if let date_taken = (dateFormat.date(from: date_takenString) as NSDate?) {
                                                                        
                                                                        let itemInst = Item(title: title, link: link, media: media, date_taken: date_taken as Date, description: description, author: author, tags: tags, width: 0, height: 0)
                                                                        //print("*** item.title = \(itemInst.title)")
                                                                        itemsUnsorted.append(itemInst)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                } // end for loop
                                store.items = itemsUnsorted.sorted(by: { $0.title < $1.title })
                            }
                        }
                        completion(true)
                    } catch {
                        completion(false) // An error occurred when creating responseJSON
                    }
                }
            }).resume()
        }
    }
}
