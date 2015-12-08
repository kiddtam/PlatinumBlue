//
//  PlatinumBlue.swift
//  PlatinumBlue
//
//  Created by 林涛 on 15/12/7.
//  Copyright © 2015年 林涛. All rights reserved.
//

import UIKit

class PlatinumBlue: NSObject,NSURLSessionDelegate {
    
    private var request:NSURLRequest
    private var URL:NSURL
    
    var feedInfo:FeedInfo?
    var feedItems = [FeedItem]()
    
    init(url :NSURL) {
        let request = NSMutableURLRequest(URL: url, cachePolicy: .ReloadRevalidatingCacheData, timeoutInterval: 60)
        request.setValue("PlatinumBlue", forHTTPHeaderField: "User-Agent")
       // request.HTTPMethod = "GET"
        
        self.request = request
       
        self.URL = url
    }
 
    convenience init(urlStr :String) {
        
        print("Rss Web site is : \(urlStr)")
        
        let url:NSURL = NSURL(string: urlStr)!
        self.init(url:url);
        //TODO:
        
    }
   
    /**
     `shape` 是测
     :param: str
     //!!!:
     - returns:
     */
    func parse()->Bool {
        //TODO: //FIXME:
        self.sendRequest()
        return true
    }

    func sendRequest() {
        /* Configure session, choose between:
        * defaultSessionConfiguration
        * ephemeralSessionConfiguration
        * backgroundSessionConfigurationWithIdentifier:
        And set session-wide properties, such as: HTTPAdditionalHeaders,
        HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
        */
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()

        
        /* Create session, and optionally set a NSURLSessionDelegate. */
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

        let task = session.dataTaskWithURL(self.URL) { (date: NSData?, response:NSURLResponse?,error:NSError?) -> Void in
            if let error = error {
                print("\(error.localizedDescription)")
            }
            
            self.startParsing(date, textEncodingName: response?.textEncodingName)
        }
       
        task.resume()
    }

    

    func startParsing( data : NSData! ,textEncodingName : String?) {
        guard let _:NSData = data else {
            return
        }
        
        if textEncodingName?.lowercaseString != "utf-8" {
            //data = self.convertUnknownEncoding(data, encodingName: textEncodingName!)
        }
        
        if let data = data where data.length > 0 {
            let xmlDoc = Ji(xmlData: data)
            let channel = xmlDoc?.rootNode?.firstChildWithName("channel")
            let children = channel?.childrenWithName("item")
            
            let feedInfo = FeedInfo()
            feedInfo.title = channel?.firstChildWithName("title")?.content
            feedInfo.feedDescription = channel?.firstChildWithName("description")?.content
            feedInfo.link = channel?.firstChildWithName("link")?.content
            feedInfo.language = channel?.firstChildWithName("language")?.content
            feedInfo.lastBuildDate = channel?.firstChildWithName("lastBuildDate")?.content
            feedInfo.pubDate = channel?.firstChildWithName("pubDate")?.content
            feedInfo.copyright = channel?.firstChildWithName("copyright")?.content
            feedInfo.webMaster = channel?.firstChildWithName("webMaster")?.content
            feedInfo.managingEditor = channel?.firstChildWithName("managingEditor")?.content
            
            self.feedInfo = feedInfo
            
           
            for node:JiNode in children! {
                let feedItem = FeedItem()
                feedItem.title = node.firstChildWithName("title")?.content
                feedItem.feedItemDescription = node.firstChildWithName("description")?.content
                feedItem.author = node.firstChildWithName("author")?.content
                feedItem.pubDate = node.firstChildWithName("pubDate")?.content
                feedItem.link = node.firstChildWithName("link")?.content
                feedItem.guid = node.firstChildWithName("guid")?.content
                feedItem.category = node.firstChildWithName("category")?.content
                self.feedItems.append(feedItem)
            }
             print("解析完成 \(self.feedItems))")
        } else {
            print("解析失败")
        }
        
        //if data
        
    }
    
    func convertUnknownEncoding(data : NSData!,encodingName :String) ->NSData? {
        var string:NSString?
        
        var nsEncoding:UInt = 0
        
        
        if let encoding:String = encodingName {
            let cfEncoding:CFStringEncoding = CFStringConvertIANACharSetNameToEncoding(encoding as CFString)
            
            if cfEncoding != kCFStringEncodingInvalidId {
                nsEncoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding)
            }
            
            if nsEncoding != 0 {
                string = NSString(data: data, encoding: nsEncoding)
            }
            
        }
        
        if ((string?.length) == nil) {
            string = NSString(data: data, encoding:NSUTF8StringEncoding)
            if ((string?.length) == nil) {
                string = NSString(data: data, encoding:NSISOLatin1StringEncoding)
                if ((string?.length) == nil) {
                    string = NSString(data: data, encoding:NSMacOSRomanStringEncoding)
                }
            }
            
        }
        
        if ((string?.length) != nil) {
            if (string!.hasPrefix("?xml")) {
                let a = string?.rangeOfString("?>")
                if a?.location != NSNotFound {
                    let xlmDec:NSString = NSString(string: (string?.substringToIndex((a?.location)!))!)
                    
                    if xlmDec.rangeOfString("encoding=\"UTF-8\"", options: .CaseInsensitiveSearch).location == NSNotFound {
                        let b = xlmDec.rangeOfString("encoding=\"")
                        
                        if b.location != NSNotFound {
                            let s = b.location + b.length
                            let c = xlmDec.rangeOfString("\"", options: .CaseInsensitiveSearch, range: NSMakeRange(s, xlmDec.length - s))
                            if c.location != NSNotFound {
                                let temp = string?.stringByReplacingCharactersInRange(NSMakeRange(b.location, c.location + c.length - b.location), withString: "encoding=\"UTF-8\"")
                                string = temp
                            }
                            
                            
                        }
                        
                    }
                }
            }
        }
        
        if ((string?.length) != nil) {
            let tempData:NSData = (string?.dataUsingEncoding(NSUTF8StringEncoding))!
            return tempData
        }
        
        return nil
    }
    
    
}



