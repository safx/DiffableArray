//
//  DetailViewController.swift
//  DiffableArray
//
//  Created by Safx Developer on 2015/01/09.
//  Copyright (c) 2015年 Safx Developers. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    var detailItem: State? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            self.title = "\(detail.abbreviation): \(detail.name)"
            if let label = self.detailDescriptionLabel {
                label.text = "\(detail.capital) (\(detail.becameDate))"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

