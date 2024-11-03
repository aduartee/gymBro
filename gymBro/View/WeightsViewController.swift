//
//  WeightsViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 01/11/24.
//

import UIKit

class WeightsViewController: UIViewController {
    var exerciseId: String = ""
    var categoryId: String = ""
    @IBOutlet weak var topSectionView: UIView!
    @IBOutlet weak var addWeigthButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleTopSectionView()
        styleAddWeigthButton()
        implementTableView()
        showExerciseInfo()
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        backToPreviousView()
    }
    
    private func showExerciseInfo() {
        // Call the weightsViewModel method
        
    }
    
    private func implementTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func styleTopSectionView() {
        topSectionView.layer.cornerRadius = 50.0
        topSectionView.layer.cornerRadius = 50.0
        topSectionView.layer.masksToBounds = true
        topSectionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    private func styleAddWeigthButton() {
        addWeigthButton.layer.masksToBounds = true
        addWeigthButton.layer.cornerRadius = 20.0
    }
    
    private func backToPreviousView() {
        navigationController?.popViewController(animated: true)
    }
}

extension WeightsViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = "Something in the way \(indexPath.row)"
        return cell
    }
    
    
    
    
}
