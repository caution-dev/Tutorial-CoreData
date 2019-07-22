//
//  Folder+CoreDataProperties.swift
//  CautionMemo
//
//  Created by juhee on 20/07/2019.
//  Copyright © 2019 caution-dev. All rights reserved.
//
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var title: String?
    @NSManaged public var memos: NSSet?

}

// MARK: Generated accessors for memos
extension Folder {

    @objc(addMemosObject:)
    @NSManaged public func addToMemos(_ value: Memo)

    @objc(removeMemosObject:)
    @NSManaged public func removeFromMemos(_ value: Memo)

    @objc(addMemos:)
    @NSManaged public func addToMemos(_ values: NSSet)

    @objc(removeMemos:)
    @NSManaged public func removeFromMemos(_ values: NSSet)

}
