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
    var numberOfRepsExercise: String = ""
    var weightData: [WeightsRequest] = []
    var weightViewModel: WeightsViewModelProtocol!
    @IBOutlet weak var topSectionView: UIView!
    @IBOutlet weak var addWeigthButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var exerciseTopSectionLabel: UILabel!
    @IBOutlet weak var seriesTopSectionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        injectWeightsVMDepedecy()
        styleTopSectionView()
        loadWeightData(idCategory: categoryId, exerciseId: exerciseId)
        styleAddWeigthButton()
        implementTableView()
        showExerciseInfo()
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        backToPreviousView()
    }
    
    @IBAction func tapAddWeights(_ sender: Any) {
        goToRegisterWeigthView()
    }
    
    private func injectWeightsVMDepedecy() {
        if weightViewModel == nil {
            weightViewModel = WeightsViewModel()
        }
    }
    
    private func showExerciseInfo() -> Void {
        weightViewModel.getExerciseDataById(idCategory: categoryId, exerciseId: exerciseId) {  [weak self]  exerciseData, error in
            guard let self = self else { return }

            if let error = error {
                showCustomAlert(title: "Warning", message: error.localizedDescription)
                return
            }
            
            if let exerciseData = exerciseData {
                changeExerciseInfoTopSection(exerciseData: exerciseData)
            }
        }
    }
    
    
    func changeExerciseInfoTopSection(exerciseData: ExerciseRequest) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.exerciseTopSectionLabel.text = exerciseData.name
            self.seriesTopSectionLabel.text = "Series: \(exerciseData.series)"
        }

    }
    
    func loadWeightData(idCategory: String, exerciseId: String) {
        weightViewModel.getWeightData(idCategory: idCategory, exerciseId: exerciseId) {[weak self] weight, error in
            guard let self = self else { return }
            if let error = error {
                showCustomAlert(title: "Sorry, something is wrong :(", message: "\(error.localizedDescription)")
            }
            
            let weightData = weight.compactMap({ $0 })
            updateTableWeight(with: weightData)
        }
    }
    
    func updateTableWeight(with weight: [WeightsRequest]) {
        weightData.removeAll()
        weightData.append(contentsOf: weight)
                
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        
        }
    }
    
    func implementTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func styleTopSectionView() {
        topSectionView.layer.cornerRadius = 50.0
        topSectionView.layer.cornerRadius = 50.0
        topSectionView.layer.masksToBounds = true
        topSectionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    func styleAddWeigthButton() {
        addWeigthButton.layer.masksToBounds = true
        addWeigthButton.layer.cornerRadius = 20.0
    }
    
    func backToPreviousView() {
        navigationController?.popViewController(animated: true)
    }
    
    func goToRegisterWeigthView() {
        if let registerWeightVC = storyboard?.instantiateViewController(withIdentifier: "registerWeightVC") as? RegisterWeightViewController {
            registerWeightVC.numberOfSeriesOfExercise = self.numberOfRepsExercise
            registerWeightVC.categoryId = self.categoryId
            registerWeightVC.exerciseId = self.exerciseId
            registerWeightVC.delegate = self
            navigationController?.pushViewController(registerWeightVC, animated: true)
        }
    }
}

extension WeightsViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weightData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell") ?? UITableViewCell(style: .default, reuseIdentifier: "defaultCell")
        let weight = weightData[indexPath.row].weight
        let reps = weightData[indexPath.row].repetitions
        let difficult = weightData[indexPath.row].difficult.label
        cell.textLabel!.text = "Weight used: \(weight)kg - Difficult \(difficult)"
        return cell
    }
}

extension WeightsViewController: registerWeightsDelegate {
    func didRegisterWeights(registeredData: [WeightsRequest]) {
        weightData = registeredData
        tableView.reloadData()
    }
}
