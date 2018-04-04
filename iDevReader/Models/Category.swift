//
//  Category.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 3/25/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import Foundation

struct Category: Decodable {
    
    enum CategoryType: String {
        case official
        case development
        case design
        case marketing
        case companies
        case podcasts
        case youtube
        case inactive
        case newsletters
    }
    
    let title: String
    let type: CategoryType?
    let description: String
    let feeds: [Feed]
    
    private enum CodingKeys: String, CodingKey {
        case title
        case type = "slug"
        case description
        case feeds = "sites"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try values.decode(String.self, forKey: .title)
        type = CategoryType(rawValue: try values.decode(String.self, forKey: .type))
        description = try values.decode(String.self, forKey: .description)
        feeds = try values.decode([Feed].self, forKey: .feeds)
    }
    
}


struct Feed: Decodable {
    let title: String
    let author: String
    let url: URL
    let site: URL
    let twitter: URL?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case author
        case url = "feed_url"
        case site = "site_url"
        case twitter = "twitter_url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        title = try values.decode(String.self, forKey: .title)
        author = try values.decode(String.self, forKey: .author)
        url = URL(string: try values.decode(String.self, forKey: .url))!
        site = URL(string: try values.decode(String.self, forKey: .site))!
        twitter = URL(string: (try? values.decode(String.self, forKey: .twitter)) ?? "") ?? nil
    }
    
}
