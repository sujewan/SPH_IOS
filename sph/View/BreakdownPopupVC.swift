//
//  BreakdownPopupVC.swift
//  sph
//
//  Created by Sujewan Vijayakumar on 5/19/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import UIKit
import Lottie
import Alamofire
import RealmSwift

class BreakdownPopupVC: UIViewController {
    
    @IBOutlet weak var layoutPopup: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var animationView: AnimationView!

    var alertController = UIAlertController()
    
    @IBOutlet weak var lblPopupTitle: UILabel!
    @IBOutlet weak var lblQuarter01Title: UILabel!
    @IBOutlet weak var lblQuarter02Title: UILabel!
    @IBOutlet weak var lblQuarter03Title: UILabel!
    @IBOutlet weak var lblQuarter04Title: UILabel!

    @IBOutlet weak var lblQuarter01: UILabel!
    @IBOutlet weak var lblQuarter02: UILabel!
    @IBOutlet weak var lblQuarter03: UILabel!
    @IBOutlet weak var lblQuarter04: UILabel!
    
    var quarters = List<Quarter>()
    var titlesArray = [UILabel]()
    var labelsArray = [UILabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.popupBgColor
        btnClose.layer.cornerRadius    = 8.0
        layoutPopup.layer.cornerRadius  = 8.0

        
        self.setUpUIElements()
        self.updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.showLoadingAnimation()
    }
    
    private func showLoadingAnimation() {
        animationView.loopMode = .autoReverse
        animationView.play()
    }

    private func hideLoadingAnimation() {
       self.animationView.stop()
       self.animationView.isHidden = true
    }
    
    @IBAction func close(_ sender: Any) {
        removeAnimate()
    }
    
    func removeAnimate() {
        self.hideLoadingAnimation()
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            self.view.alpha = 0.0
        }, completion: {(finished: Bool) in
            if finished {
                self.view.removeFromSuperview()
            }
        })
    }
    
    func setUpUIElements() {
        titlesArray.removeAll()
        labelsArray.removeAll()
        
        titlesArray.append(lblQuarter01Title)
        titlesArray.append(lblQuarter02Title)
        titlesArray.append(lblQuarter03Title)
        titlesArray.append(lblQuarter04Title)
        
        labelsArray.append(lblQuarter01)
        labelsArray.append(lblQuarter02)
        labelsArray.append(lblQuarter03)
        labelsArray.append(lblQuarter04)
    }
    
    func updateUI() {
        if (!quarters.isEmpty) {
            self.lblPopupTitle.text = "Usage Breakdown - " + quarters[0].year.description
            
            var index = 0
            quarters.forEach({ (quarter) in
                labelsArray[index].text = quarter.volume.description
                labelsArray[index].textColor = quarter.isDecrease ? Colors.redBgColor : Colors.greenBgColor
                titlesArray[index].textColor = quarter.isDecrease ? Colors.redBgColor : Colors.greenBgColor

                index += 1
            })
        }
    }
}
