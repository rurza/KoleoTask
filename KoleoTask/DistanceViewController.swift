//
//  DistanceViewController.swift
//  KoleoTask
//
//  Created by rurza on 09/06/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

import UIKit
import MapKit

class DistanceViewController: UIViewController, UITableViewDataSource {
    
    //MARK: properties
    @IBOutlet var fromSearchTextField: UITextField!
    @IBOutlet var toSearchTextField: UITextField!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var distanceInfoLabel: UILabel!
    @IBOutlet var tableViewBottomConstraint: NSLayoutConstraint!
    
    let tableViewCellIdentifier = "stationNameCellIdentifier"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotifications()
    }

    
    //MARK: views setup
    func setupTableView() {
        tableView.tableFooterView = UIView()
    }
    
    //MARK: vc setup
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(DistanceViewController.textFieldTextDidChange(note:)), name: .UITextFieldTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DistanceViewController.keyboardWillShow(note:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DistanceViewController.keyboardWillHide(note:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    //MARK: UITableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath)
        
        return cell
    }
    
    //MARK: UITableView Delegate
    
    
    //MARK: Textfields
    func textFieldTextDidChange(note: Notification) {
        
    }
    
    func keyboardWillShow(note: Notification) {
        let userInfo = note.userInfo! as NSDictionary
        let keyboardFrame = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        tableViewBottomConstraint.constant = keyboardHeight
    }
    
    func keyboardWillHide(note: Notification) {
        tableViewBottomConstraint.constant = 0
    }
    
    //MARK
    
    
    
}
