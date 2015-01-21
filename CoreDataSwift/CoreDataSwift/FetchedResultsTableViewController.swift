//
//  FetchedResultsTableViewController.swift
//  CDTest
//
//  Created by David Hoofnagle on 9/5/14.
//  Copyright (c) 2014 David Hoofnagle. All rights reserved.
//

import UIKit
import CoreData

class FetchedResultsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var myFetchedResultController: NSFetchedResultsController?
    
    var theEntityName: String
    var theSortDescriptor: String
    var isAscending: Bool
    
    var beganUpdates:Bool = false
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    required init(coder aDecoder: NSCoder) {
        self.theEntityName = ""
        self.theSortDescriptor = ""
        self.isAscending = false
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didSaveManagedObjectContext:"), name: NSManagedObjectContextDidSaveNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSManagedObjectContextDidSaveNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSaveManagedObjectContext(notification:NSNotification) {
        
        var context:NSManagedObjectContext = notification.object as NSManagedObjectContext
        
        if (appDelegate.managedObjectContext == context) {
            println("Did save foreground context.")
            return
        }
        
        if (appDelegate.managedObjectContext!.persistentStoreCoordinator != context.persistentStoreCoordinator) {
            println("Not same store, exiting!")
            return
        }
        
        println("Did Save Background Context Notification")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.appDelegate.managedObjectContext!.mergeChangesFromContextDidSaveNotification(notification)
            self.appDelegate.saveContext()
            self.tableView.reloadData()
        })
    }
    
    func getFetchedResultsController (predicate:NSPredicate?) -> NSFetchedResultsController {
        if (myFetchedResultController != nil) {
            return myFetchedResultController!
        }
        
        let fetchRequest = NSFetchRequest(entityName: self.theEntityName)
        let sortDescriptor = NSSortDescriptor(key: self.theSortDescriptor, ascending: self.isAscending)
        
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        myFetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        myFetchedResultController!.delegate = self
        
        return myFetchedResultController!
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
        if (myFetchedResultController != nil) {
            return myFetchedResultController!.sections!.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
            let info = myFetchedResultController!.sections?[section] as NSFetchedResultsSectionInfo
            return info.numberOfObjects
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case NSFetchedResultsChangeType.Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        case NSFetchedResultsChangeType.Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        case NSFetchedResultsChangeType.Update:
            self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        default:
            println("unknown type")
        }
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        self.tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
 
}
