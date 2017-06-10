//
//  DistanceViewController.swift
//  KoleoTask
//
//  Created by rurza on 09/06/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

import UIKit
import MapKit

class DistanceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: properties
    @IBOutlet var fromSearchTextField: UITextField!
    @IBOutlet var toSearchTextField: UITextField!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var distanceInfoLabel: UILabel!
    @IBOutlet var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var mapViewBottomConstraint: NSLayoutConstraint!
    
    let tableViewCellIdentifier = "stationNameCellIdentifier"
    let viewModel = DistanceViewModel()
    
    weak var currentTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        setupNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .UITextFieldTextDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)

        super.viewWillDisappear(animated)
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
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(DistanceViewController.textFieldTextDidChange(note:)), name: .UITextFieldTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DistanceViewController.keyboardWillShow(note:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DistanceViewController.keyboardWillHide(note:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    //MARK: UITableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfFilteredStations()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath)
        cell.textLabel?.text = viewModel.stationName(forIndexPath: indexPath)
        return cell
    }
    
    //MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentTextField.resignFirstResponder()
        tableView.isHidden = true
        let annotations = viewModel.addStation(atIndexPath: indexPath, withPoint: currentTextField == fromSearchTextField ? .from : .to)
        currentTextField.text = viewModel.stationName(forIndexPath: indexPath)
        if let annotationToDelete = annotations.toDelete {
            mapView.removeAnnotation(annotationToDelete)
        }
        mapView.addAnnotation(annotations.toAdd)
        if let distance = viewModel.distanceString() {
            distanceInfoLabel.text = distance
            UIView.animate(withDuration: 0.4, delay: 0, options: .beginFromCurrentState, animations: {
                self.mapViewBottomConstraint.constant = self.distanceInfoLabel.frame.size.height
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: .beginFromCurrentState, animations: {
                self.mapViewBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
            distanceInfoLabel.text = nil
        }
        mapView.showAnnotations(self.mapView.annotations, animated: true)

    }
    
    //MARK: Textfields
    func textFieldTextDidChange(note: Notification) {
        if let textField = note.object {
            if let text = (textField as! UITextField).text {
                viewModel.filterStations(phrase: text, handler: { (numberOfResults) in
                    if numberOfResults > 0 {
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    } else {
                        self.tableView.isHidden = true
                    }
                })
            }
        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let filteredStations = viewModel.filteredStations {
            if filteredStations.count > 0 {
                self.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
                if textField == fromSearchTextField && !viewModel.bothStations() {
                    toSearchTextField.becomeFirstResponder()
                    return true
                }
                if textField == toSearchTextField {
                    textField.resignFirstResponder()
                    if viewModel.bothStations() {
                        return true
                    }
                }
            }
        }

        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
        currentTextField = textField
    }
    
    //MARK: mapView
    @IBAction func mapWasTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    
}
