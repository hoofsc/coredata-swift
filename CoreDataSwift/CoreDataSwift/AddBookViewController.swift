//
//  AddBookViewController.swift
//  CoreDataSwift
//
//  Created by Hoof on 1/20/15.
//  Copyright (c) 2015 Retinal Media. All rights reserved.
//

import UIKit

protocol BookManagerDelegate {
    func didAddBook(entry: NSDictionary)
    func didCancelEntry()
}

class AddBookViewController: UIViewController {

    var delegate: BookManagerDelegate?
    @IBOutlet var titleField: UITextField?
    @IBOutlet var authorField: UITextField?
    @IBOutlet var yearField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitPressed (sender: AnyObject?) {
        var entry = NSMutableDictionary()
        entry["title"] = titleField?.text
        entry["author"] = authorField?.text
        entry["publishdate"] = yearField?.text
        delegate?.didAddBook(entry)
    }
    
    @IBAction func cancelPressed (sender: AnyObject?) {
        delegate?.didCancelEntry()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
