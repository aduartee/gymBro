//
//  RegisterWeightViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 06/11/24.
//

import UIKit

class RegisterWeightViewController: UIViewController {
    var numberOfSeriesOfExercise: String = ""
    var exerciseId: String = ""
    var actualRep: Int = 1
    var registeredWeightData: [WeightsRequest] = []
    private var weightLiftedValue: Int = 0
    private var dataOfEachSerie: [Int: WeightsRequest] = [:]
    private var registerWeightViewModel: RegisterWeigthViewModel!
    var numberOfReps: [Int] = []
    var selectedOptionRepsPicker: Int = 0
    var selectedDificult: String = ""
    let cardContent: [String]  = ["Easy 🐔", "Medium 🐯", "Hard 🔥"]
    let cardContentColors: [UIColor] = [
        UIColor(red: 173/255, green: 216/255, blue: 255/255, alpha: 1.0),
        UIColor(red: 70/255, green: 130/255, blue: 180/255, alpha: 1.0),
        UIColor(red: 28/255, green: 59/255, blue: 159/255, alpha: 1.0)
    ]
    var currentIndex: Int = 0
    
    @IBOutlet weak var weightRowView: UIView!
    @IBOutlet weak var repsRowView: UIView!
    @IBOutlet weak var diffcultRowView: UIView!
    @IBOutlet weak var weightLabelRow: UILabel!
    @IBOutlet weak var trackerRegistersTable: UITableView!
    @IBOutlet weak var numberOfSeriesRepsLabel: UILabel!
    @IBOutlet weak var difficultButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet var weightAddCollection: [UIButton]!
    @IBOutlet weak var numberOfrepsLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        registerTrackerXIBCell()
        injectWeightsVMDepedecy()
        styleBackgroundRowViews()
        styleDifficultButton()
        self.navigationItem.title = "Teste"
    }
    
    private func styleBackgroundRowViews() {
        weightRowView.layer.masksToBounds = true
        repsRowView.layer.masksToBounds = true
        diffcultRowView.layer.masksToBounds = true
        weightRowView.layer.cornerRadius = 20
        repsRowView.layer.cornerRadius = 20
        diffcultRowView.layer.cornerRadius = 20
    }
    private func configureTableView() {
        trackerRegistersTable.delegate = self
        trackerRegistersTable.dataSource = self
    }
    
    private func registerTrackerXIBCell() {
        trackerRegistersTable.register(UINib(nibName: "WeigthViewCellXib", bundle:  nil), forCellReuseIdentifier: "WeigthViewCellXib")
    }
    
    
    private func configureAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to register the new weights?", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.handleConfirmOption()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        return alert
    }
    
    private func showAlert() {
        let alert = configureAlert()
        present(alert, animated: true)
    }
    
    private func handleConfirmOption() {
        print("Hi")
    }
    
    private func convertSeriesForInt(with series: String) -> Int? {
        let seriesWithoutX = series.replacingOccurrences(of: "x", with: "")
        
        guard !seriesWithoutX.isEmpty else {
            return nil
        }
        
        return Int(seriesWithoutX)
    }
    
    private func injectWeightsVMDepedecy() {
        if registerWeightViewModel == nil {
            registerWeightViewModel = RegisterWeigthViewModel()
        }
    }
    
//    private func configurePickerData() {
//        self.numberOfRepsPicker.delegate = self
//        self.numberOfRepsPicker.dataSource = self
//        for number in 1...20 {
//            numberOfReps.append(number)
//        }
//    }
    
//    private func configureWeightLiftedField() {
//        UIView.transition(with: weightLiftedField, duration: 0.1, options: .transitionCrossDissolve, animations: {
//            self.weightLiftedField.text = "\(self.weightLiftedValue) kg"
//        })
//    }
    
    private func styleDifficultButton() {
        difficultButton.layer.cornerRadius = difficultButton.frame.height / 2
        difficultButton.clipsToBounds = true
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 28, weight: .medium)
        ]
        let attributedTitle = NSAttributedString(string: difficultButton.title(for: .normal) ?? "Easy 🐔", attributes: attributes)
        difficultButton.setAttributedTitle(attributedTitle, for: .normal)
        UIButton.transition(with: difficultButton, duration: 0.3, options: .transitionCurlUp) { [weak self] in
            guard let self = self else { return }
            self.difficultButton.backgroundColor = self.cardContentColors[self.currentIndex]
        }
    }
    
    private func changeButtonContent(){
        let buttonContent = cardContent[currentIndex]
        difficultButton.setTitle(buttonContent, for: .normal)
        selectedDificult = buttonContent
        styleDifficultButton()
    }
    
    private func changeNumberOfSeriesLabelContent(with actualRep: Int) {
        UILabel.transition(with: numberOfSeriesRepsLabel, duration: 1.0, options: .transitionCrossDissolve) { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.numberOfSeriesRepsLabel.text = String(actualRep)
            }
            
        }
    }
    
    private func buildWeigthData() -> WeightsRequest {
        return WeightsRequest(exerciseId: exerciseId,
                       weightId: "", weight: weightLiftedValue, repetitions: selectedOptionRepsPicker, sets: numberOfSeriesOfExercise, difficult: selectedDificult, registerAt: Date.now)        
    }
    
    private func buildWeigthRequestBySerie(data: WeightsRequest, serie: Int) {
        dataOfEachSerie[serie] = data
    }

    private func goToAddRepetionsVC() {
        if let addRepsVC = storyboard?.instantiateViewController(withIdentifier: "addRepsVC") as? addRepsViewController {
            addRepsVC.delegate = self
            
            if let sheetController = addRepsVC.sheetPresentationController {
                let customDetent = UISheetPresentationController.Detent.custom { _ in
                    return 320
                }
                
                sheetController.detents = [customDetent]
                sheetController.prefersGrabberVisible = false
                sheetController.preferredCornerRadius = 20
            }
            
            present(addRepsVC, animated: true)
        }
        
    }
    
    @IBAction func tapChangeDifficult(_ sender: Any) {
        currentIndex = (currentIndex + 1) % cardContent.count
        changeButtonContent()
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        guard let seriesNumber = convertSeriesForInt(with: numberOfSeriesOfExercise) else {
            return
        }
    
        if actualRep <= seriesNumber {
            changeNumberOfSeriesLabelContent(with: actualRep)
            let data = buildWeigthData()
            
            buildWeigthRequestBySerie(data: data, serie: actualRep)
            trackerRegistersTable.reloadData()
            actualRep += 1
            
        } else {
            showAlert()
        }
    }
    
    @IBAction func tapCancelButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapAddWeigthButton(_ sender: Any) {
        if let addWeightVC = storyboard?.instantiateViewController(withIdentifier: "addNewWeightModalVC") as? addNewWeightModalViewController {
            addWeightVC.delegate = self
            if let sheetController = addWeightVC.sheetPresentationController {
                let customDetent = UISheetPresentationController.Detent.custom { _ in
                    return 320
                }
                
                sheetController.detents = [customDetent]
                sheetController.preferredCornerRadius = 20
                sheetController.prefersGrabberVisible = false
            }
           
            present(addWeightVC, animated: true)
        }
    }
    
    
    @IBAction func tapAddRepetitionsButton(_ sender: Any) {
        goToAddRepetionsVC()
    }
    
}

extension RegisterWeightViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        numberOfReps.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(numberOfReps[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = view as? UILabel ?? UILabel()
        pickerLabel.text = String(numberOfReps[row])
        pickerLabel.font = UIFont(name: "Helvetica", size: 30)
        pickerLabel.textColor = .systemBlue
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOptionRepsPicker = numberOfReps[row]
    }
}

extension RegisterWeightViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataOfEachSerie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = trackerRegistersTable.dequeueReusableCell(withIdentifier: "MyCellTest") ?? UITableViewCell(style: .default, reuseIdentifier: "MyCellTest")
        
        guard let cell = trackerRegistersTable.dequeueReusableCell(withIdentifier: "WeigthViewCellXib", for: indexPath) as? WeigthViewCellXib else {
            return UITableViewCell()
        }
        
        let keys = dataOfEachSerie.keys.sorted()
        let key = keys[indexPath.row]
        
        if let weightData = dataOfEachSerie[key] {
            let weightValue: String = String(weightData.weight)
            let repsValue: String = String(weightData.repetitions)
            let difficult: String = "🔥"
            print(difficult)
            
            cell.changeInfoRegistered(weight: weightValue, reps: repsValue, difficult: difficult)
        }
        
        return cell
    }
}

//extension RegisterWeightViewController: UIAdaptivePresentationControllerDelegate {
//    func presentationController(_ presentationController: UIPresentationController,
//                                willPresentWithAdaptiveStyle style: UIModalPresentationStyle,
//                                transitionCoordinator: UIViewControllerTransitionCoordinator?) {
//        
//        if let sheetController = presentationController as? UISheetPresentationController {
//            let customDentent = UISheetPresentationController.Detent.custom { _ in
//                return 320
//            }
//            sheetController.detents = [customDentent]
//            sheetController.largestUndimmedDetentIdentifier = .medium
//            sheetController.prefersGrabberVisible = false
//        }
//    }
//}

extension RegisterWeightViewController: AddWeightDelegate, addRepsDelegate {
    func didAddWeight(selectedRowPicker: String) {
        if selectedRowPicker != "" {
            weightLabelRow.text = selectedRowPicker
        }
    }
    
    func didAddReps(selectedRepsValue: String) {
        print(selectedRepsValue)
        if selectedRepsValue != "" {
            numberOfrepsLabel.text = selectedRepsValue
        }
    }
}
