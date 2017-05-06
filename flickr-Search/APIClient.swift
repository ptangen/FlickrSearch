//
//  APIClient.swift
//  flickr-Search
//
//  Created by Paul Tangen on 5/5/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import Foundation

class APIClient {
    
    var foundCharacters = String()
    
    class func searchFlickr(tags: String, completion: @escaping (String) -> Void) {
        
        let store = DataStore.sharedInstance
        var itemsUnsorted = [Item]()
        if let tagsEncoded = tags.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?tagmode=any&nojsoncallback=1&format=json&tags=\(tagsEncoded)"
        print(urlString)
        let url = URL(string: urlString)
        if let url = url {
            var request = URLRequest(url: url)
            
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                
                if let unwrappedData = data {
                    store.items.removeAll()
                    
                    // trying to clean up invalid JSON
                    // convert json to a string
                    var unwrappedDataString = String(describing: unwrappedData)
                    // replace \' with a ' in the string
                    unwrappedDataString = unwrappedDataString.replacingOccurrences(of: "\\'", with: "'")
                    // convert string back to JSON
                    // As far as I can tell, this is not possible.
                    
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as? [String: Any]
                        
                        if let responseJSON = responseJSON {
                            //if let itemsDictAny = responseJSON["items"] {
                                
                                let itemsDict = responseJSON["items"] as! [[String:Any]]
                                
                                //unwrap the incoming data and populate item array in datastore
                                for itemDict in itemsDict {
                                    if let titleEncoded = itemDict["title"] as? String {
                                        if let linkEncoded = itemDict["link"] as? String {
                                            if let mediaDict = itemDict["media"] as? [String:String] {
                                                if let media = mediaDict["m"] {
                                                    if let date_takenString = itemDict["date_taken"] as? String {
                                                        if let descriptionEncoded = itemDict["description"] as? String {
                                                            if let authorEncoded = itemDict["author"] as? String {
                                                                if let tagsEncoded = itemDict["tags"] as? String {
                                                                    
                                                                    // decode strings
                                                                    let title = self.decodeCharactersIn(string: titleEncoded)
                                                                    let link = self.decodeCharactersIn(string: linkEncoded)
                                                                    let description = self.decodeCharactersIn(string: descriptionEncoded)
                                                                    let author = self.decodeCharactersIn(string: authorEncoded)
                                                                    let tags = self.decodeCharactersIn(string: tagsEncoded)
                                                                    
                                                                    // get width and height from description
                                                                    let width = self.getValueFromDesc(descriptionEncoded: descriptionEncoded, imgTagAttribute: "width")
                                                                    let height = self.getValueFromDesc(descriptionEncoded: descriptionEncoded, imgTagAttribute: "height")
                                                                    
                                                                    // Convert date_takenString to Date
                                                                    let dateFormat = DateFormatter()
                                                                    dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss-SS:SS"
                                                                    if let date_taken = (dateFormat.date(from: date_takenString) as NSDate?) {
                                                                        
                                                                        // create object
                                                                        let itemInst = Item(title: title, link: link, media: media, date_taken: date_taken as Date, description: description, author: author, tags: tags, width: width, height: height)
                                                                        itemsUnsorted.append(itemInst)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                       // }
                                    }
                                } // end for loop
                                store.items = itemsUnsorted.sorted(by: { $0.title < $1.title }) // sort by title
                            }
                        }
                        // return response
                        store.items.count == 0 ? completion("noItemsFound") : completion("success")
                    } catch {
                        // Invalid JSON is returned about periodically, reissue the query if needed
                        let invalidJSON = String(describing: error).contains("Code=3840")
                        if invalidJSON {
                            completion("invalidJSON")
                        } else {
                            print("error = \(error)")
                            completion("error") // JSON is valid, but another error occurred.
                        }
                    }
                }
            }).resume()
        }
        }
    }

    static func decodeCharactersIn(string: String) -> String {
        var string = string; string = string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        let characters = ["&#8217;" : "'", "&#8220;": "“", "[&hellip;]": "...", "&#038;": "&", "&#8230;": "...", "&#039;": "'", "&quot;": "“", "%20": " ", "&gt;": ">", "&apos;": "'" , "&reg;": "", "\'": "'"]
        for (code, character) in characters {
            string = string.replacingOccurrences(of: code, with: character, options: .caseInsensitive, range: nil)
        }
        return string
    }
    
    static func getValueFromDesc(descriptionEncoded: String, imgTagAttribute: String) -> Int {
        
        // the description contains the width and height of the image as attributes an HTML img tag, for example:  ... width="240" height="180" ...
        // this function return the width or height requested

        let imgTagAttributeWithEqual = imgTagAttribute + "="
        let attributeStartRange = descriptionEncoded.range(of: imgTagAttributeWithEqual, options: NSString.CompareOptions.literal,
                                                           range: descriptionEncoded.startIndex..<descriptionEncoded.endIndex, locale: nil)
        if let attributeStartRange = attributeStartRange {
            // remove chars before the value's quote on left
            let attributeStartIndex = attributeStartRange.upperBound
            let attibuteValueWithSuffix = descriptionEncoded[attributeStartIndex..<descriptionEncoded.endIndex]
            
            if let locationOfSpace = attibuteValueWithSuffix.characters.index(of: " ") {
                // remove chars after the value's quote on right
                let attibuteValueWithQuotes = attibuteValueWithSuffix[attibuteValueWithSuffix.startIndex..<locationOfSpace]
                // trim the quotes
                let set = CharacterSet(charactersIn: "\"")
                let attibuteValueString = attibuteValueWithQuotes.trimmingCharacters(in: set)
                
                return Int(attibuteValueString)!
            }
        }
        return 0
    }
}
