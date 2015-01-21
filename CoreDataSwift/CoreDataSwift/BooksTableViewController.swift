//
//  BooksTableViewController.swift
//  CoreDataSwift
//
//  Created by Hoof on 1/20/15.
//  Copyright (c) 2015 Retinal Media. All rights reserved.
//

import UIKit
import CoreData

class BooksTableViewController: FetchedResultsTableViewController, BookManagerDelegate {

    var fetchedResultController:NSFetchedResultsController?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.theEntityName = "Book"
        self.theSortDescriptor = "publishdate"
        self.isAscending = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Books"
        
        if (NSUserDefaults.standardUserDefaults().boolForKey("InitialLoad") == false) {
            loadInitialBooks()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey:"InitialLoad")
            NSUserDefaults.standardUserDefaults().synchronize()
        }

        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addPressed:"))
        
        self.fetchedResultController = self.getFetchedResultsController(nil)
        var error:NSError?
        self.fetchedResultController!.performFetch(&error)
        if (error != nil) {
            println("FETCH ERROR")
            println(error!)
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addPressed (sender: AnyObject?) {
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("AddBookNavigationController") as? UINavigationController
       
        self.navigationController?.presentViewController(vc!, animated: true, completion: { () -> Void in
            var avc = vc!.topViewController as AddBookViewController
            avc.delegate = self
        })
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BookTableViewCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        var book = self.myFetchedResultController!.objectAtIndexPath(indexPath) as? Book
        cell.textLabel?.text = book?.title
        cell.detailTextLabel?.text = book?.author

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            var book = self.myFetchedResultController?.objectAtIndexPath(indexPath) as Book
            appDelegate.managedObjectContext!.deleteObject(book)
            appDelegate.saveContext()
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    func loadInitialBooks() {
        var books = [
            [
                "title": "Alice in Wonderland",
                "author": "Lewis Carroll",
                "publishdate": "1865"
            ],
            [
                "title": "Treasure Island",
                "author": "Robert Louis Stevenson",
                "publishdate": "1883"
            ],
            [
                "title": "East of Eden",
                "author": "John Steinbeck",
                "publishdate": "1952"
            ],
        ]
        
        for book in books as [NSDictionary] {
            didAddBook(book)
        }
    }
    
    func didAddBook(entry: NSDictionary) {
        
        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            var entityDescription = NSEntityDescription.entityForName("Book", inManagedObjectContext: self.appDelegate.managedObjectContext!)
            var bk = Book(entity: entityDescription!, insertIntoManagedObjectContext: self.appDelegate.managedObjectContext!)
            bk.title = entry["title"] as String
            bk.author = entry["author"] as String
            var formatter = NSDateFormatter()
            formatter.dateFormat = "YY"
            let date = formatter.dateFromString(entry["publishdate"] as String)
            bk.publishdate = date!
            
            self.appDelegate.saveContext()
        })
    }
    
    func didCancelEntry() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
}
