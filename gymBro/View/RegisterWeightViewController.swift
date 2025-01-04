//
//  RegisterWeightViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 06/11/24.
//

import UIKit

protocol registerWeightsDelegate: AnyObject{
    func didRegisterWeights(registeredData: [WeightsRequest])
}

class RegisterWeightViewController: UIViewController {
    weak var delegate: registerWeightsDelegate?
    var numberOfSeriesOfExercise: String = ""
    var exerciseId: String = ""
    var categoryId: String?
    var actualRep: Int = 1
    var registeredWeightData: [WeightsRequest] = []
    var selectedDifficultEmoji: String = ""
    private var weightLiftedValue: Int = 1
    private var dataOfEachSerie: [Int: WeightsRequest] = [:]
    private var registerWeightViewModel = RegisterWeigthViewModel()
    var numberOfReps: [Int] = []
    var selectedOptionReps: Int = 1
    var selectedDificultObject: Difficult?
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
    @IBOutlet var weightAddCollection: [UIButton]!
    @IBOutlet weak var numberOfrepsLabel: UILabel!
    @IBOutlet weak var difficultLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        registerTrackerXIBCell()
        styleBackgroundRowViews()
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
        handleRegisterExercise()
    }
    
    func handleRegisterExercise() {
        guard let categoryId = categoryId else { return }
        registerWeightViewModel.registerNewWeight(exerciseId: exerciseId, categoryId: categoryId, WeightRequestArray: dataOfEachSerie) { [weak self] registerData, error in
            
            guard let self = self else { return }
            
            if let error = error {
                showCustomAlert(title: "Error", message: error.localizedDescription)
                return
            }

            let data = registerData.compactMap({ $0 })
            print(data)
            self.delegate?.didRegisterWeights(registeredData: data)
            self.goToBackView()
        }
    }
    
    private func convertSeriesForInt(with series: String) -> Int? {
        let seriesWithoutX = series.replacingOccurrences(of: "x", with: "")
        
        guard !seriesWithoutX.isEmpty else {
            return nil
        }
        
        return Int(seriesWithoutX)
    }
    
    private func changeNumberOfSeriesLabelContent(with actualRep: Int) {
        UILabel.transition(with: numberOfSeriesRepsLabel, duration: 1.0, options: .transitionCrossDissolve) { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.numberOfSeriesRepsLabel.text = String(actualRep)
            }
            
        }
    }
    
    func changeButtonAddTitle() -> Void {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.addButton.setTitle("Register", for: .normal)
        }
    }
    
    private func buildWeigthData() -> WeightsRequest? {
        if let selectedDificult = selectedDificultObject {
            return WeightsRequest(exerciseId: exerciseId,
                                  weightId: "", weight: weightLiftedValue, repetitions: selectedOptionReps, sets: actualRep, difficult: selectedDificult, registerAt: Date.now)
        }
        
        return nil
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
    
    func goToAddDifficultVC() {
        if let addDifficultVC = storyboard?.instantiateViewController(withIdentifier: "addDiffcultVC") as? addDifficultViewController {
            addDifficultVC.delegate = self
            
            if let sheetController = addDifficultVC.sheetPresentationController {
                let customDetent = UISheetPresentationController.Detent.custom { _ in
                    return 200
                }
                
                sheetController.detents = [customDetent]
                sheetController.prefersGrabberVisible = false
                sheetController.preferredCornerRadius = 20
            }
            present(addDifficultVC, animated: true)
        }
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        guard let seriesNumber = convertSeriesForInt(with: numberOfSeriesOfExercise) else {
            return
        }
    
        print(actualRep)
        print(seriesNumber)
        handleSeriesProgression(seriesNumber: seriesNumber)
        
//        if actualRep <= seriesNumber {
//            changeNumberOfSeriesLabelContent(with: actualRep)
//            guard let data = buildWeigthData() else { return }
//            
//            buildWeigthRequestBySerie(data: data, serie: actualRep)
//            trackerRegistersTable.reloadData()
//            actualRep += 1
//            
//        } else {
//            changeButtonAddTitle()
//            showAlert()
//        }
    }
    
    func handleSeriesProgression(seriesNumber: Int) {
        if actualRep <= seriesNumber {
            changeNumberOfSeriesLabelContent(with: actualRep)
            guard let data = buildWeigthData() else { return }
            
            buildWeigthRequestBySerie(data: data, serie: actualRep)
            trackerRegistersTable.reloadData()
            actualRep += 1
            
        } else {
            changeButtonAddTitle()
            showAlert()
        }
    }
    
    func goToBackView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapCancelButton(_ sender: Any) {
        self.goToBackView()
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
    
    
    @IBAction func addDifficultTap(_ sender: Any) {
        goToAddDifficultVC()
    }
    
    
    @IBAction func tapAddRepetitionsButton(_ sender: Any) {
        goToAddRepetionsVC()
    }
    
}

extension RegisterWeightViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataOfEachSerie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = trackerRegistersTable.dequeueReusableCell(withIdentifier: "WeigthViewCellXib", for: indexPath) as? WeigthViewCellXib else {
            return UITableViewCell()
        }
        
        let keys = dataOfEachSerie.keys.sorted()
        let key = keys[indexPath.row]
        
        if let weightData = dataOfEachSerie[key] {
            let weightValue: String = String(weightData.weight)
            let repsValue: String = String(weightData.repetitions)
            let difficult: String = weightData.difficult.emoji
            cell.changeNumberOfSeriesTitle(numberOfSeries: weightData.sets)
            cell.changeInfoRegistered(weight: weightValue, reps: repsValue, difficult: difficult)
        }
        
        return cell
    }
}

extension RegisterWeightViewController: AddWeightDelegate, addRepsDelegate, addDifficultDelegate {
    func didAddDifficult(selectedDifficult: Difficult) {
        if selectedDifficult.label != "" {
            selectedDifficultEmoji = selectedDifficult.emoji
            difficultLabel.text = "\(selectedDifficult.label) \(selectedDifficultEmoji)"
            selectedDificultObject = selectedDifficult
        }
    }
    
    func didAddWeight(selectedRowPicker: String) {
        if selectedRowPicker != "" {
            weightLabelRow.text = "\(selectedRowPicker) kg"
            weightLiftedValue = Int(selectedRowPicker) ?? 1
        }
    }
    
    func didAddReps(selectedRepsValue: Int) {
        numberOfrepsLabel.text = "\(selectedRepsValue)x"
        selectedOptionReps = selectedRepsValue
    }
}
