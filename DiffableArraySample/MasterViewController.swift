//
//  MasterViewController.swift
//  DiffableArray
//
//  Created by Safx Developer on 2015/01/09.
//  Copyright (c) 2015年 Safx Developers. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet var searchBar: UITableView!

    var detailViewController: DetailViewController? = nil
    var states: FilterableArray<State>?


    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        /*if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }*/

        weak var tableView = self.tableView
        let diffSink = SinkOf<ArrayDiffer<State>> { diff in
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                let d = diff.diffAsIndexPath()
                if d.added.count + d.removed.count + d.modified.count > 0 {
                    dispatch_async(dispatch_get_main_queue()) {
                        if let t = tableView {
                            t.beginUpdates()
                            t.insertRowsAtIndexPaths(d.added   , withRowAnimation: .Left)
                            t.deleteRowsAtIndexPaths(d.removed , withRowAnimation: .Right)
                            t.reloadRowsAtIndexPaths(d.modified, withRowAnimation: .Left)
                            t.endUpdates()
                        }
                    }
                }
            }
        }

        // http://simple.wikipedia.org/wiki/List_of_U.S._states
        states = FilterableArray(diffSink: diffSink, initialValue: [
            State(name: "Alabama"        , abbreviation: "AL", capital: "Montgomery"     , becameDate: "December 14, 1819"),
            State(name: "Alaska"         , abbreviation: "AK", capital: "Juneau"         , becameDate: "January 3, 1959"),
            State(name: "Arizona"        , abbreviation: "AZ", capital: "Phoenix"        , becameDate: "February 14, 1912"),
            State(name: "Arkansas"       , abbreviation: "AR", capital: "Little Rock"    , becameDate: "June 15, 1836"),
            State(name: "California"     , abbreviation: "CA", capital: "Sacramento"     , becameDate: "September 9, 1850"),
            State(name: "Colorado"       , abbreviation: "CO", capital: "Denver"         , becameDate: "August 1, 1876"),
            State(name: "Connecticut"    , abbreviation: "CT", capital: "Hartford"       , becameDate: "January 9, 1788"),
            State(name: "Delaware"       , abbreviation: "DE", capital: "Dover"          , becameDate: "December 7, 1787"),
            State(name: "Florida"        , abbreviation: "FL", capital: "Tallahassee"    , becameDate: "March 3, 1845"),
            State(name: "Georgia"        , abbreviation: "GA", capital: "Atlanta"        , becameDate: "January 2, 1788"),
            State(name: "Hawaii"         , abbreviation: "HI", capital: "Honolulu"       , becameDate: "August 21, 1959"),
            State(name: "Idaho"          , abbreviation: "ID", capital: "Boise"          , becameDate: "July 3, 1890"),
            State(name: "Illinois"       , abbreviation: "IL", capital: "Springfield"    , becameDate: "December 3, 1818"),
            State(name: "Indiana"        , abbreviation: "IN", capital: "Indianapolis"   , becameDate: "December 11, 1816"),
            State(name: "Iowa"           , abbreviation: "IA", capital: "Des Moines"     , becameDate: "December 28, 1846"),
            State(name: "Kansas"         , abbreviation: "KS", capital: "Topeka"         , becameDate: "January 29, 1861"),
            State(name: "Kentucky"       , abbreviation: "KY", capital: "Frankfort"      , becameDate: "June 1, 1792"),
            State(name: "Louisiana"      , abbreviation: "LA", capital: "Baton Rouge"    , becameDate: "April 30, 1812"),
            State(name: "Maine"          , abbreviation: "ME", capital: "Augusta"        , becameDate: "March 15, 1820"),
            State(name: "Maryland"       , abbreviation: "MD", capital: "Annapolis"      , becameDate: "April 28, 1788"),
            State(name: "Massachusetts"  , abbreviation: "MA", capital: "Boston"         , becameDate: "February 6, 1788"),
            State(name: "Michigan"       , abbreviation: "MI", capital: "Lansing"        , becameDate: "January 26, 1837"),
            State(name: "Minnesota"      , abbreviation: "MN", capital: "Saint Paul"     , becameDate: "May 11, 1858"),
            State(name: "Mississippi"    , abbreviation: "MS", capital: "Jackson"        , becameDate: "December 10, 1817"),
            State(name: "Missouri"       , abbreviation: "MO", capital: "Jefferson City" , becameDate: "August 10, 1821"),
            State(name: "Montana"        , abbreviation: "MT", capital: "Helena"         , becameDate: "November 8, 1889"),
            State(name: "Nebraska"       , abbreviation: "NE", capital: "Lincoln"        , becameDate: "March 1, 1867"),
            State(name: "Nevada"         , abbreviation: "NV", capital: "Carson City"    , becameDate: "October 31, 1864"),
            State(name: "New Hampshire"  , abbreviation: "NH", capital: "Concord"        , becameDate: "June 21, 1788"),
            State(name: "New Jersey"     , abbreviation: "NJ", capital: "Trenton"        , becameDate: "December 18, 1787"),
            State(name: "New Mexico"     , abbreviation: "NM", capital: "Santa Fe"       , becameDate: "January 6, 1912"),
            State(name: "New York"       , abbreviation: "NY", capital: "Albany"         , becameDate: "July 26, 1788"),
            State(name: "North Carolina" , abbreviation: "NC", capital: "Raleigh"        , becameDate: "November 21, 1789"),
            State(name: "North Dakota"   , abbreviation: "ND", capital: "Bismarck"       , becameDate: "November 2, 1889"),
            State(name: "Ohio"           , abbreviation: "OH", capital: "Columbus"       , becameDate: "March 1, 1803"),
            State(name: "Oklahoma"       , abbreviation: "OK", capital: "Oklahoma City"  , becameDate: "November 16, 1907"),
            State(name: "Oregon"         , abbreviation: "OR", capital: "Salem"          , becameDate: "February 14, 1859"),
            State(name: "Pennsylvania"   , abbreviation: "PA", capital: "Harrisburg"     , becameDate: "December 12, 1787"),
            State(name: "Rhode Island"   , abbreviation: "RI", capital: "Providence"     , becameDate: "May 19, 1790"),
            State(name: "South Carolina" , abbreviation: "SC", capital: "Columbia"       , becameDate: "May 23, 1788"),
            State(name: "South Dakota"   , abbreviation: "SD", capital: "Pierre"         , becameDate: "November 2, 1889"),
            State(name: "Tennessee"      , abbreviation: "TN", capital: "Nashville"      , becameDate: "June 1, 1796"),
            State(name: "Texas"          , abbreviation: "TX", capital: "Austin"         , becameDate: "December 29, 1845"),
            State(name: "Utah"           , abbreviation: "UT", capital: "Salt Lake City" , becameDate: "January 4, 1896"),
            State(name: "Vermont"        , abbreviation: "VT", capital: "Montpelier"     , becameDate: "March 4, 1791"),
            State(name: "Virginia"       , abbreviation: "VA", capital: "Richmond"       , becameDate: "June 25, 1788"),
            State(name: "Washington"     , abbreviation: "WA", capital: "Olympia"        , becameDate: "November 11, 1889"),
            State(name: "West Virginia"  , abbreviation: "WV", capital: "Charleston"     , becameDate: "June 20, 1863"),
            State(name: "Wisconsin"      , abbreviation: "WI", capital: "Madison"        , becameDate: "May 29, 1848"),
            State(name: "Wyoming"        , abbreviation: "WY", capital: "Cheyenne"       , becameDate: "July 10, 1890"),
        ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = states![indexPath.row]
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.text = states![indexPath.row].name
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    // MARK: - UISearchBarDelegate

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        states!.filterFunction = createFilterFunc(searchText)
    }

    func createFilterFunc(word: String)(s: State) -> Bool {
        if (word == "") {
            return true
        }
        return s.name.lowercaseString.rangeOfString(word.lowercaseString) != nil
            || s.abbreviation.lowercaseString.rangeOfString(word.lowercaseString) != nil
    }
}

struct State : Equatable {
    let name: String
    let abbreviation: String
    let capital: String
    let becameDate: String
}

func == (lhs: State, rhs: State) -> Bool {
    return lhs.name == rhs.name
}
