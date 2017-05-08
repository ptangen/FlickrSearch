//
//  APIClient.swift
//  flickr-Search
//
//  Created by Paul Tangen on 5/5/17.
//  Copyright © 2017 Paul Tangen. All rights reserved.
//

import Foundation
import SwiftyJSON // only used to convert the JSON to a string and fix the invalid JSON

class APIClient {
    
    class func searchFlickr(tags: String, completion: @escaping (String) -> Void) {
        
        let store = DataStore.sharedInstance
        var itemsUnsorted = [Item]()
        if let tagsEncoded = tags.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?tagmode=any&nojsoncallback=1&format=json&tags=\(tagsEncoded)"
            let url = URL(string: urlString)
            if let url = url {
                var request = URLRequest(url: url)
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                
                URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                    store.items.removeAll()
                    
                    // we have the results, now remove the extra \ so JSON is valid
                    if let data = data {
                        let jsonWithInvalidChars = JSON(data: data)
                        
                        if let jsonWithInvalidCharsString = jsonWithInvalidChars.rawString() {
                            let jsonWithValidCharsString = jsonWithInvalidCharsString.replacingOccurrences(of: "\\'", with: "'")
                            
                            if let jsonWithValidCharsData = jsonWithValidCharsString.data(using: String.Encoding.utf8) {
                                do {
                                    // create the dictionary of objects
                                    if let responseJSON = try JSONSerialization.jsonObject(with: jsonWithValidCharsData, options: [.allowFragments]) as? [String: Any] {
                                        let itemsDict = responseJSON["items"] as! [[String:Any]]
                                        
                                        //unwrap the incoming data and populate item array in datastore
                                        for itemDict in itemsDict {
                                            if let titleEncoded = itemDict["title"] as? String {
                                                if let linkEncoded = itemDict["link"] as? String {
                                                    if let mediaDict = itemDict["media"] as? [String:String] {
                                                        if let media = mediaDict["m"] {
                                                            if let date_takenString = itemDict["date_taken"] as? String {
                                                                if let descriptionEncoded = itemDict["description"] as? String {
                                                                    
                                                                    // clean strings
                                                                    let charsToTrim = CharacterSet(charactersIn: " , :")
                                                                    
                                                                    var title = self.decodeCharactersIn(string: titleEncoded)
                                                                    title = title.trimmingCharacters(in: charsToTrim)
                                                                    title.characters.count == 0 ? title = "no title" : ()
                                                                    
                                                                    let link = self.decodeCharactersIn(string: linkEncoded)
                                                                    
                                                                    var description = self.decodeCharactersIn(string: descriptionEncoded)
                                                                    description = description.trimmingCharacters(in: charsToTrim)
                                                                    
                                                                    // get width and height from description
                                                                    let width = self.getValueFromDesc(descriptionEncoded: descriptionEncoded, imgTagAttribute: "width")
                                                                    let height = self.getValueFromDesc(descriptionEncoded: descriptionEncoded, imgTagAttribute: "height")
                                                                    
                                                                    // Convert date_takenString to Date
                                                                    let dateFormat = DateFormatter()
                                                                    dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss-SS:SS"
                                                                    if let date_taken = (dateFormat.date(from: date_takenString) as NSDate?) {
                                                                        
                                                                        // create object
                                                                        let itemInst = Item(title: title, link: link, media: media, date_taken: date_taken as Date, description: description, width: width, height: height)
                                                                        itemsUnsorted.append(itemInst)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            } // end for loop
                                            store.items = itemsUnsorted.sorted(by: { $0.title < $1.title }) // sort by title
                                        }
                                    }
                                    // return response
                                    store.items.count == 0 ? completion("noItemsFound") : completion("success")
                                } catch {
                                    // Invalid JSON is returned periodically even after slash is removed.
                                    // When this occurs, report the issue so the query can be issued again.
                                    if String(describing: error).contains("Code=3840") {
                                        completion("invalidJSON-Retry")
                                    } else {
                                        completion("error") // JSON is valid, but another error occurred.
                                    }
                                    print("error = \(error)")
                                }
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
        
        // the description contains the width and height of the image as attributes an HTML img 
        // tag, for example:  ... width="240" height="180" ...
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
