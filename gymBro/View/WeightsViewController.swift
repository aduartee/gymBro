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
    var data: [WeightsRequest] = []
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
        weightViewModel.getExerciseData(idCategory: categoryId, exerciseId: exerciseId) {  [weak self]  exerciseData, error in
            guard let self = self else { return }
            
            if let error = error {
                self.showCustomAlert(title: "Warning", message: error.localizedDescription)
                return
            }
            
            if let exerciseData = exerciseData {
                DispatchQueue.main.async {
                    self.exerciseTopSectionLabel.text = exerciseData.name
                    self.seriesTopSectionLabel.text = "Series: \(exerciseData.series)"
                    return
                }
            }
        }
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
    
    private func goToRegisterWeigthView() {
        if let registerWeightVC = storyboard?.instantiateViewController(withIdentifier: "registerWeightVC") as? RegisterWeightViewController {
            
            if let sheet = registerWeightVC.sheetPresentationController {
                let customDetent = UISheetPresentationController.Detent.custom { context in
                    return context.maximumDetentValue * 0.85
                }
                
                sheet.detents = [customDetent, .large()]
                sheet.preferredCornerRadius = 20
                sheet.prefersGrabberVisible = true
            }
            
            present(registerWeightVC, animated: true)
        }
        
        return
    }
}

extension WeightsViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let info = data[indexPath.row].weight
        cell.textLabel!.text = "\(info) - \(indexPath.row)"
        return cell
    }
}
