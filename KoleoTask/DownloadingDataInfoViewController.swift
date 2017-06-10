//
//  DownloadingDataInfoViewController.swift
//  KoleoTask
//
//  Created by rurza on 10/06/2017.
//  Copyright © 2017 Adam Różyński. All rights reserved.
//

import UIKit
import NVActivityIndicatorView



class DownloadingDataInfoViewController: UIViewController {
    
    var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet var tryAgainButton: RoundedButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .orbit, color: UIColor.white, padding: 0)
        activityIndicatorView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        view.addSubview(activityIndicatorView)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadStations()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }

    func downloadStations() {
        activityIndicatorView.startAnimating()
        DataController.shared.downloadStations { (error) in
            if (error != nil) {
                let alertViewController = UIAlertController(title: "Nie mogę pobrać zdjęć", message: error?.localizedDescription, preferredStyle: .alert)
                alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    UIView.animate(withDuration: 0.4, animations: {
                        self.tryAgainButton.alpha = 0
                    })
                    
                }))
                self.present(alertViewController, animated: true, completion: {
                    self.activityIndicatorView.stopAnimating()
                })
            } else {
                self.performSegue(withIdentifier: "showDistanceViewController", sender: self)
            }
        }
    }
    
    
    @IBAction func tryAgainWasTapped(_ sender: UIButton) {
        downloadStations()
    }

}
