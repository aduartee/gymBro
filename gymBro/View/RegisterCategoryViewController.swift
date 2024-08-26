//
//  RegisterCategoryViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 30/07/24.
//

import UIKit

class RegisterCategoryViewController: UIViewController {
    var idCategory: String?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerDescription: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    private let exerciseViewModel = ExerciseViewModel()
    var data:[ExerciseModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        styleView()
    }
    
    private func styleView() {
        headerView.layer.cornerRadius = 40.0
        headerView.layer.cornerRadius = 40.0
        headerView.layer.masksToBounds = true
        //        Set the radius only on the bottom leading and bottom trailing corners
        headerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        guard let idCategory = idCategory else { return }
        changeExerciseInfo(idCategory: idCategory)
    }
    
    func changeExerciseInfo(idCategory: String) -> Void {
        exerciseViewModel.fetchExerciceCategoryById(categoryId: idCategory) { [weak self] exerciceCategory, error in
            guard let self = self else { return }
            
            if let error = error {
                self.showCustomAlert(title: "Warning", message: "\(error)")
                return
            }
            guard let exerciceCategory = exerciceCategory else {
                self.showCustomAlert(title: "Warning", message: "Result was empty, review category")
                return
            }
            
            headerLabel.text = exerciceCategory.categoryName
            headerDescription.text = exerciceCategory.description
        }
    }
}

extension RegisterCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
      
        let model = data[indexPath.row]
        
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = "teste"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        
        return cell
    }
    
    
}
