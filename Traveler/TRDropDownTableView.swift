//
//  TRDropDownTableView.swift
//  Traveler
//
//  Created by Ashutosh on 8/10/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import pop

protocol DropDownTableProtocol {
    func didSelectRowAtIndex(index: Int)
}


private let DROP_DOWN_CELL_ID      = "dropDownCellIdentifier"

class TRDropDownTableView: UIView, UITableViewDataSource, UITableViewDelegate {

    //Delegate
    var delegate: DropDownTableProtocol?
    
    var dataArray: [AnyObject] = [] {
        didSet{
            self.dropDownTable?.reloadData()
        }
    }
    
    @IBOutlet weak var dropDownTable: UITableView!

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = 2.0
        
        //TableView
        self.dropDownTable?.registerNib(UINib(nibName: "TrDropDownTableCell", bundle: nil), forCellReuseIdentifier: DROP_DOWN_CELL_ID)
        self.dropDownTable?.round([.BottomLeft, .BottomRight], radius: self.layer.cornerRadius)
    }
    
    
    func addDropDownAnimation () {
        let popAnimation:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleY)
        popAnimation.toValue = NSValue(CGSize: CGSizeMake(1, 1))
        popAnimation.springBounciness = 20
        self.pop_addAnimation(popAnimation, forKey: "slideIn")
    }
    
    //MARK:- Table Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.dataArray.count > 0 else {
            return 0
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 3/255, green: 81/255, blue: 102/255, alpha: 1)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(DROP_DOWN_CELL_ID) as! TrDropDownTableCell
        cell.titleLabel?.text = self.dataArray[indexPath.section] as? String
        cell.round([.AllCorners], radius: self.layer.cornerRadius)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.delegate?.didSelectRowAtIndex(indexPath.section)
    }
}
