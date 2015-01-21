//
//  Book.swift
//  CoreDataSwift
//
//  Created by Hoof on 1/20/15.
//  Copyright (c) 2015 Retinal Media. All rights reserved.
//

import Foundation
import CoreData

@objc(Book)
class Book: NSManagedObject {

    @NSManaged var author: String
    @NSManaged var title: String
    @NSManaged var publishdate: NSDate

}
