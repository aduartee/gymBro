//
//  addDifficultViewController.swift
//  gymBro
//
//  Created by Arthur Duarte on 24/11/24.
//

import UIKit

protocol addDifficultDelegate: AnyObject {
    func didAddDifficult(selectedDifficult: Difficult)
}

class addDifficultViewController: UIViewController {
    weak var delegate: addDifficultDelegate?
    var selectedDificult: Difficult = Difficult(emoji: "🐔", label: "Easy", color: UIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 1.0))
    var currentIndex: Int = 0
    
    let difficultObjectOptions = [
        Difficult(emoji: "🐔", label: "Easy", color: UIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 1.0)),
        Difficult(emoji: "🐯", label: "Medium", color: UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1.0)),
        Difficult(emoji: "🔥", label: "Hard", color: UIColor(red: 178/255, green: 34/255, blue: 34/255, alpha: 1.0))
    ]

    @IBOutlet weak var chooseDiffucultButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleDifficultButton()
        setupPresentationController()
    }
    
    func setupPresentationController() {
        presentationController?.delegate = self
    }
    private func styleDifficultButton() {
        chooseDiffucultButton.layer.cornerRadius = chooseDiffucultButton.frame.height / 2
        chooseDiffucultButton.clipsToBounds = true
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 28, weight: .medium)
        ]
        let attributedTitle = NSAttributedString(string: chooseDiffucultButton.title(for: .normal) ?? "Easy 🐔", attributes: attributes)
        chooseDiffucultButton.setAttributedTitle(attributedTitle, for: .normal)
        UIButton.transition(with: chooseDiffucultButton, duration: 0.3, options: .transitionCurlUp) { [weak self] in
            guard let self = self else { return }
            self.chooseDiffucultButton.backgroundColor = self.difficultObjectOptions[self.currentIndex].color
        }
    }
    
    private func changeButtonContent(){
        let currentValue = difficultObjectOptions[currentIndex]
        let label = "\(currentValue.label) \(currentValue.emoji)"
        chooseDiffucultButton.setTitle(label, for: .normal)
        selectedDificult = currentValue
        styleDifficultButton()
    }
    
    
    @IBAction func difficultButtonTap(_ sender: Any) {
        currentIndex = (currentIndex + 1) % difficultObjectOptions.count
        changeButtonContent()
    }
}

extension addDifficultViewController: UISheetPresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.delegate?.didAddDifficult(selectedDifficult: selectedDificult)
    }
}
