//
//  RegisterCategoryViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 30/07/24.
//

import UIKit

protocol RegisterExerciseDelegate: AnyObject {
    func didRegisterExerciseDelegate(exerciseRequest: ExerciseRequest)
}
class RegisterCategoryViewController: UIViewController {
    var idCategory: String?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerDescription: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    private let exerciseViewModel = ExerciseViewModel()
    var data:[ExerciseRequest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        styleView()
        guard let idCategory = idCategory else { return }
        showExerciseList(idCategory: idCategory)
    }
    
    private func styleView() {
        showEmptyMessage()
        styleHeaderView()
        guard let idCategory = idCategory else { return }
        changeExerciseInfo(idCategory: idCategory)
    }
    
    private func styleHeaderView() {
        headerView.layer.cornerRadius = 40.0
        headerView.layer.cornerRadius = 40.0
        headerView.layer.masksToBounds = true
        //        Set the radius only on the bottom leading and bottom trailing corners
        headerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
    
    func showExerciseList(idCategory: String) -> Void {
        exerciseViewModel.fetchAllExercicesCategory(categoryId: idCategory) { [weak self] exercise, error in
            guard let self = self else { return }
            
            if let error = error {
                self.showCustomAlert(title: "Error", message: "\(error)")
                return
            }
            
            if let exercise = exercise {
                self.data.removeAll()
                self.data.append(contentsOf: exercise)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        backButton.tintColor = .gray
        backToHomeView()
    }
    
    func backToHomeView() {
        navigationController?.popViewController(animated: true)
    }
    
    func goToRegisterView(){
        if let registerExerciseVC = storyboard?.instantiateViewController(withIdentifier: "registerExerciseVC") as? RegisterExerciseViewController {
           
            if let sheet = registerExerciseVC.sheetPresentationController {
                let customDetent = UISheetPresentationController.Detent.custom { context in
                    return context.maximumDetentValue * 0.75
                }
                
                sheet.detents = [customDetent, .large()]
                sheet.preferredCornerRadius = 20
                sheet.prefersGrabberVisible = true
            }
            
            guard let idCategory = idCategory else { return }
            registerExerciseVC.delegate = self
            registerExerciseVC.idCategory = idCategory
            present(registerExerciseVC, animated: true)
        }
    }
    
    @IBAction func registerExerciseButton(_ sender: Any) {
        goToRegisterView()
    }
    
    func showEmptyMessage() {
        messageLabel.text = "No exercises added yet. Please add a new exercise to the list."
        messageLabel.textAlignment = .center
        messageLabel.textColor = .gray
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.numberOfLines = 0
        tableView.backgroundView = messageView
        
    }
}

extension RegisterCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = data.count
        tableView.backgroundView?.isHidden = rowCount > 0
        return rowCount
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

extension RegisterCategoryViewController: RegisterExerciseDelegate {
    func didRegisterExerciseDelegate(exerciseRequest: ExerciseRequest) {
        DispatchQueue.main.async {
            self.data.append(exerciseRequest)
            self.tableView.reloadData()
        }
    }
}
