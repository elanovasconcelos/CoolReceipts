//
//  ReceiptRealmModel.swift
//  CoolReceipts
//
//  Created by Elano Vasconcelos on 19/03/25.
//

import Foundation
import RealmSwift

class ReceiptRealmModel: Object, Identifiable {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var date: Date = Date()
    @objc dynamic var totalAmount: Double = 0.0
    @objc dynamic var currency: String = "€"
    @objc dynamic var storeName: String = ""
    @objc dynamic var imagePath: String = "" // Local file path for the stored image
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
