//
//  WeightsViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 01/11/24.
//

import UIKit

protocol registerWeightsDelegate: AnyObject{
    func didRegisterWeights(registeredData: [WeightsRequest], date: Date)
}

class WeightsViewController: UIViewController {
    var exerciseId: String = ""
    var categoryId: String = ""
    var numberOfRepsExercise: String = ""
    var weightData: [WeightsRequest] = []
    var weightSection: [WeightsSection] = []
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
        tableView.estimatedRowHeight = 200
        registerWeightXIBCell()
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
    
    func registerWeightXIBCell() {
        self.tableView.register(UINib(nibName:"WeightTableViewCell", bundle: nil), forCellReuseIdentifier: "weightInfoCellXib")
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
        weightViewModel.getWeightData(idCategory: idCategory, exerciseId: exerciseId) {[weak self] weightSection, error in
            guard let self = self else { return }
            if let error = error {
                showCustomAlert(title: "Sorry, something is wrong :(", message: "\(error.localizedDescription)")
            }
            
//            let weightData = weight.compactMap({ $0 })
            let weightSection = weightSection.compactMap { $0 }
            updateTableWeight(with: weightSection)
        }
    }
    
    func updateTableWeight(with weightSectionData: [WeightsSection]) {
        weightSection.append(contentsOf: weightSectionData)
                
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
        return weightSection[section].weigthData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return weightSection.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weightInfoCellXib", for: indexPath) as? WeightTableViewCell else {
            return UITableViewCell()
        }
        
        let weight = weightSection[indexPath.section].weigthData[indexPath.row].weight
        let reps = weightSection[indexPath.section].weigthData[indexPath.row].repetitions
        let difficult = weightSection[indexPath.section].weigthData[indexPath.row].difficult.label
        let difficultColor = weightSection[indexPath.section].weigthData[indexPath.row].difficult.color
        let serie = String(indexPath.row + 1)
        let registerAt = weightSection[indexPath.section].weigthData[indexPath.row].registerAt
        let dayAbbreviation = DateFormatterHelper.shared.toWeekdayAbbreviation(with: registerAt)
        cell.changeInfoWeight(weight: weight, reps: reps, serie: serie, day: dayAbbreviation)
        cell.styleDifficult(difficult: difficult, difficultColor: difficultColor)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        label.font = UIFont(name: "Montserrat-Medium", size: 26.0)
        label.textColor = UIColor(.white)
        label.text = weightSection[section].registeredMonth
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = weightSection[section].registeredMonth
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

extension WeightsViewController: registerWeightsDelegate {
    func didRegisterWeights(registeredData: [WeightsRequest], date: Date) {
        DispatchQueue.main.async {
            let value = self.weightViewModel.createSectionsFromWeights(weightData: registeredData)
            self.weightSection.append(contentsOf: value)
            self.tableView.reloadData()
        }
    }
}
