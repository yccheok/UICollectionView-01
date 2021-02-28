//
//  PlainNote.swift
//  UICollectionView-01
//
//  Created by Cheok Yan Cheng on 27/02/2021.
//

import Foundation

struct PlainNote: Codable, Hashable {
    var title: String
    var body: String
    var pinned: Bool
    var uuid: UUID = UUID()
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case pinned
    }
}

extension PlainNote {
    init(title: String, body: String, pinned: Bool) {
        self.init(title: title, body: body, pinned: pinned, uuid: UUID())
    }
}
