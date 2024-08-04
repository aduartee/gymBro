//
//  HomeViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 18/07/24.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewCategoryButton: UIButton!
    var homeViewModel: HomeViewModel = HomeViewModel()
    var data: [CategoryExerciseRequest] = []
    var selectedRowId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        showExercicesCategory()
    }
    
    @IBAction func logoutButtonTap(_ sender: Any) {
        AuthService.shared.logoutUser { error in
            if let error = error {
                print(error)
                return
            }
            
            self.goToSingInVC()
        }
    }
    
    @IBAction func tapAddNewCategory(_ sender: Any) {
        print("Hello")
    }
    
    func configureLayout() {
        self.navigationItem.hidesBackButton = true
        usernameLabel.alpha = 0
        showUsernameLabel()
    }
    
    func showUsernameLabel() {
        homeViewModel.getUsernameCurretUser { [weak self] username, error in
            guard let self = self else { return }
            
            if error != nil {
                self.usernameLabel.text = "Unknown"
                return
            }
            
            if let username = username {
                animateUserLabel()
                self.usernameLabel.text = "Welcome, \(username) 👋"
            }
        }
    }
    
    func showExercicesCategory() {
        homeViewModel.getAllCategoryExercices { [weak self] categorys, error in
            guard let self = self else { return}
            
            if error != nil {
                return
            }
            
            if let categorys = categorys {
                self.data.append(contentsOf: categorys)
                self.tableView.reloadData()
            }
        }
    }
    
    private func goToSingInVC(){
        if let signInVc = storyboard?.instantiateViewController(withIdentifier: "singInViewController") as? ViewController {
            navigationController?.pushViewController(signInVc, animated: true)
        }
    }
    
    private func sendValuesAndGoToRegisterCategoryView(with idSelected: String) {
        if let registerCategoryVC = storyboard?.instantiateViewController(withIdentifier: "RegisterCategoryView") as? RegisterCategoryViewController {
            registerCategoryVC.idCategory = idSelected
            navigationController?.pushViewController(registerCategoryVC, animated: true)
        }
    }
    
    private func sendValuesAndGoToEditCategoryVC(with idSelected: String) {
        if let editCategoryVC = storyboard?.instantiateViewController(withIdentifier: "editCategoryViewController") as? EditCategoryViewController {
            editCategoryVC.idCategory = idSelected
            present(editCategoryVC, animated: true)
        }
    }
    
    private func editRow(indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, _) in
            guard let self = self else {return}
            selectedRowId = data[indexPath.row].id
            self.sendValuesAndGoToEditCategoryVC(with: selectedRowId)
        }
        
        action.backgroundColor = .blue
        return action
    }
    
    private func removeRow(indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, _) in
            guard let self = self else { return}
            print("Remove")
        }
        
        return action
    }
    
    private func animateUserLabel() {
        UILabel.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.usernameLabel.alpha = 1.0
        }, completion: nil)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let model = data[indexPath.item]
        cell.textLabel?.text = model.categoryName
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Exercices"
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRowId = data[indexPath.row].id
        sendValuesAndGoToRegisterCategoryView(with: selectedRowId)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = editRow(indexPath: indexPath)
        let deleteAction = removeRow(indexPath: indexPath)
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return swipeAction
    }
}
