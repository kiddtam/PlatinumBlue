//
//  FeedInfo.swift
//  PlatinumBlue
//
//  Created by 林涛 on 15/12/8.
//  Copyright © 2015年 林涛. All rights reserved.
//

// Feed Info see http://www.runoob.com/rss/rss-reference.html

import UIKit

class FeedInfo: NSObject {
 /// 为 feed 定义所属的一个或多个种类。
    var category : String?
 /// 注册进程，以获得 feed 更新的立即通知。
    var cloud : String?
 /// 可选。告知版权资料。
    var copyright : String?
 /// 描述频道。
    var feedDescription : String?
 /// 规定指向当前 RSS 文件所用格式说明的 URL
    var docs : String?
 /// 在聚合器呈现某个 feed 时，显示一个图像
    var image : String?
 /// 规定编写 feed 所用的语言
    var language : String?
 /// 定义 feed 内容的最后修改日期
    var lastBuildDate : String?
 /// 定义指向频道的超链接
    var link : String?
 /// 定义 feed 内容编辑的电子邮件地址
    var managingEditor : String?
 /// 为 feed 的内容定义最后发布日期
    var pubDate : String?
 /// feed 的 PICS 级别
    var rating : String?
 /// 规定忽略 feed 更新的天
    var skipDays : String?
 /// 规定忽略 feed 更新的小时
    var skipHours : String?
 /// 定义频道的标题
    var title : String?
 /// 指定从 feed 源更新此 feed 之前，feed 可被缓存的分钟数。
    var ttl : String?
 /// 定义此 feed 的 web 管理员的电子邮件地址
    var webMaster : String?
}
