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
    var homeViewModel: HomeViewModel = HomeViewModel()
    var data: [CategoryExerciseRequest] = []
    
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
                self.usernameLabel.text = "\(username) 👋"
            }
        }
    }
    
    func showExercicesCategory() {
        homeViewModel.getAllCategoryExercices {[weak self] categorys, error in
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
    
    func goToSingInVC(){
        if let signInVc = storyboard?.instantiateViewController(withIdentifier: "singInViewController") as? ViewController {
            navigationController?.pushViewController(signInVc, animated: true)
        }
    }
    
    func animateUserLabel() {
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
        let selectedRowUid = data[indexPath.row].id
        print(selectedRowUid)
    }
}
