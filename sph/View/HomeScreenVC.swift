//
//  HomeScreenVC.swift
//  sph
//
//  Created by Sujewan Vijayakumar on 5/18/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import UIKit
import ESPullToRefresh
import Alamofire
import Lottie

class HomeScreenVC: UIViewController {

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var tableView: UITableView!

    lazy var viewModel: HomeScreenViewModel = {
        return DefaultHomeScreenViewModel(dataUsageUseCase: DataUsageRepository(apiManager: APIManager()))
   }()
    
    var items: [DataUsageItemViewModel] = [] {
        didSet {
            reload()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    private func bind(to viewModel: HomeScreenViewModel) {
        viewModel.items.observe(on: self) {
            [weak self] in self?.items = $0
        }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
        viewModel.loadingType.observe(on: self) {
            [weak self] _ in self?.updateViewsVisibility()
        }
    }
    
   func setupTableView() {
        tableView.register(UINib(nibName: "DataUsageCell", bundle: nil), forCellReuseIdentifier: "DataUsageCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    
        tableView.isAccessibilityElement = true
        tableView.accessibilityIdentifier = "TableView_Records"
    }
    
    func reload() {
        tableView.reloadData()
    }

    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showSnackBar(message: error)
    }
        
    private func updateViewsVisibility() {
        emptyView.isHidden = true
        tableView.isHidden = true
        hideLoadingAnimation()

        updateDataUsageListVisibility()
    }
    
    private func updateDataUsageListVisibility() {
        guard !viewModel.isEmpty else {
            emptyView.isHidden = false
            return
        }
        tableView.isHidden = false
    }
    
    private func showLoadingAnimation() {
        animationView.loopMode = .loop
        animationView.play()
    }

    private func hideLoadingAnimation() {
       self.animationView.stop()
       self.animationView.isHidden = true
    }
}

extension HomeScreenVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DataUsageCell", for: indexPath) as? DataUsageCell else {
            assertionFailure("Cannot dequeue reusable cell \(DataUsageCell.self) with reuseIdentifier: DataUsageCell")
            return .init()
        }

        cell.updateCellUI(with: items[indexPath.row])
        cell.isAccessibilityElement = true
        cell.accessibilityIdentifier = String(format: "dtTVC_%d_%d", indexPath.section, indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.items[indexPath.row]
        if !item.isAlertIconHidden {
            let breakdownPopup = storyboard?.instantiateViewController(withIdentifier: "BreakdownPopupVC") as! BreakdownPopupVC
            breakdownPopup.quarters = item.quarters
            self.addChild(breakdownPopup)
            self.view.addSubview(breakdownPopup.view)
            breakdownPopup.didMove(toParent: self)
        }
    }
}
