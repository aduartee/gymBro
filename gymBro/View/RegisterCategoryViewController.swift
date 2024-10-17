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

protocol EditExerciseDelegate: AnyObject {
    func didEditExerciseDelegate(exerciseRequest: ExerciseRequest)
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
    let seriesArray: [String] = ["2x", "3x", "4x"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        styleView()
        
        tableView.register(UINib(nibName: "ExerciseViewRow", bundle: nil), forCellReuseIdentifier: "ExerciseCell")

        guard let idCategory = idCategory else { return }
        showExerciseList(idCategory: idCategory)
    }
    
    private func styleView() {
        showEmptyMessage()
        styleHeaderView()
        guard let idCategory = idCategory else { return }
//        changeExerciseInfo(idCategory: idCategory)
    }
    
    private func styleHeaderView() {
        headerView.layer.cornerRadius = 40.0
        headerView.layer.cornerRadius = 40.0
        headerView.layer.masksToBounds = true
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
            
            DispatchQueue.main.async {
                self.headerLabel.text = exerciceCategory.categoryName
                self.headerDescription.text = exerciceCategory.description
            }
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
            
//            for i in 0..<data.count {
//                print("\(i): \(data[i])")
//            }
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
    
    func goToEditView(selectedRowexerciseId: String) {
        if let editExerciseVC = storyboard?.instantiateViewController(withIdentifier: "editExerciseVC") as? EditExerciseViewController {
            
            if let sheet = editExerciseVC.sheetPresentationController {
                let customDetent = UISheetPresentationController.Detent.custom { context in
                    return context.maximumDetentValue * 0.75
                }
                
                sheet.detents = [customDetent, .large()]
                sheet.preferredCornerRadius = 20
                sheet.prefersGrabberVisible = true
            }
            
            guard let idCategory = idCategory else { return }
            editExerciseVC.delegate = self
            editExerciseVC.idCategory = idCategory
            editExerciseVC.exerciseId = selectedRowexerciseId
            present(editExerciseVC, animated: true)
        }
    }
    
    @IBAction func registerExerciseButton(_ sender: Any) {
        goToRegisterView()
    }
    
    private func showEmptyMessage() {
        messageLabel.text = "No exercises added yet. Please add a new exercise to the list."
        messageLabel.textAlignment = .center
        messageLabel.textColor = .gray
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.numberOfLines = 0
        tableView.backgroundView = messageView
    }
    
    private func editRow(indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Edit") {  [weak self] (_, _, _) in
            guard let self = self else { return }
            let selectedRowId = data[indexPath.row].id
            goToEditView(selectedRowexerciseId: selectedRowId)
        }

        action.backgroundColor = .blue
        return action
    }
    
    
    private func removeRow(indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Remove") {  [weak self] (_, _, _) in
            guard let self = self else { return }
            let selectedRowId = data[indexPath.row].id
            goToEditView(selectedRowexerciseId: selectedRowId)
        }
        
        action.backgroundColor = .red
        return action
    }
}

extension RegisterCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = data.count
        tableView.backgroundView?.isHidden = rowCount > 0
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as? ExerciseTableViewCell else {
            return UITableViewCell()
        }
        
        let exercise = data[indexPath.row]
        let exerciseName = exercise.name
        let series = String(exercise.series)
        let order = String(indexPath.row + 1)
        cell.configureCell(name: exerciseName, series: series, orderNumber: order)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = editRow(indexPath: indexPath)
        let removeAction = removeRow(indexPath: indexPath)
        let swipeActions = UISwipeActionsConfiguration(actions: [removeAction, editAction])
        return swipeActions
    }
}

extension RegisterCategoryViewController: RegisterExerciseDelegate, EditExerciseDelegate {
    func didRegisterExerciseDelegate(exerciseRequest: ExerciseRequest) {
        DispatchQueue.main.async {
            self.data.append(exerciseRequest)
            self.tableView.reloadData()
        }
    }
    
    func didEditExerciseDelegate(exerciseRequest: ExerciseRequest) {
        if let indexToEdit = data.firstIndex(where: {$0.id == exerciseRequest.id}) {
            data[indexToEdit] = exerciseRequest
            let indexPath = IndexPath(row: indexToEdit, section: 0)
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
}
