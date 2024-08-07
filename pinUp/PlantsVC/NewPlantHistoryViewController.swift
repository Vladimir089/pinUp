//
//  NewPlantHistoryViewController.swift
//  pinUp
//
//  Created by Владимир Кацап on 07.08.2024.
//

import UIKit

class NewPlantHistoryViewController: UIViewController {
    
    var index = 0
    var delegate: DetailPlantViewControllerDelegate?
    
    let imageArr = [UIImage.hisOne, UIImage.hisTwo, UIImage.hisThree, UIImage.hisFour, UIImage.hisFive]
    
    var saveButton: UIButton?
    
    var nameActionTextField: UITextField?
    var buttonsArr: [UIButton] = []
    var selectedButton: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        createInterface()
    }
    
    func createInterface() {
        let hisLabel = UILabel()
        hisLabel.text = "History"
        hisLabel.font = .systemFont(ofSize: 17, weight: .bold)
        hisLabel.textColor = .black
        view.addSubview(hisLabel)
        hisLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(10)
        }
        
        saveButton = {
            let button = UIButton(type: .system)
            button.setTitle("Save", for: .normal)
            button.setTitleColor(.greenFigma, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
            button.alpha = 0.5
            button.isEnabled = false
            return button
        }()
        view.addSubview(saveButton!)
        saveButton?.snp.makeConstraints({ make in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(hisLabel)
        })
        saveButton?.addTarget(self, action: #selector(saveHistory), for: .touchUpInside)
        
        let addActionLabel: UILabel = {
            let label = UILabel()
            label.text = "Add an action"
            label.textColor = .black
            label.font = .systemFont(ofSize: 18, weight: .bold)
            return label
        }()
        view.addSubview(addActionLabel)
        addActionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(hisLabel.snp.bottom).inset(-30)
        }
        
        
        nameActionTextField = {
            let textField = UITextField()
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            textField.leftViewMode = .always
            textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            textField.rightViewMode = .always
            textField.backgroundColor = .white
            textField.borderStyle = .none
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.greenFigma.cgColor
            textField.layer.cornerRadius = 16
            textField.textColor = .black
            textField.delegate = self
            return textField
        }()
        view.addSubview(nameActionTextField!)
        nameActionTextField?.snp.makeConstraints({ make in
            make.height.equalTo(52)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(addActionLabel.snp.bottom).inset(-15)
        })
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        stackView.backgroundColor = .clear
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.height.equalTo(57)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(nameActionTextField!.snp.bottom).inset(-15)
        }
        
        createButtons()
        
        
        for i in buttonsArr {
            stackView.addArrangedSubview(i)
        }
        
        
        
    }
    
    
    @objc func saveHistory() {
        
        

        let history = PlantHistory(date: Date(), action: nameActionTextField?.text ?? "", indexImage: selectedButton ?? 0)
       
        plantsArr[index].history.append(history)
        
        do {
            let data = try JSONEncoder().encode(plantsArr) //тут мкассив конвертируем в дату
            try saveAthleteArrToFile(data: data)
            delegate?.reloadTables()
            self.dismiss(animated: true)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }

        
        
        
    }
    
    
    
    func saveAthleteArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("plantssss.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
    
    
    @objc func buttonTapped(sender: UIButton) {
        
        for i in buttonsArr {
            if i.backgroundColor == .greenFigma {
                i.backgroundColor = .white
                i.tintColor = .greenFigma
            }
        }
        
        sender.backgroundColor = .greenFigma
        sender.tintColor = .white
        selectedButton = sender.tag
        checkButton()
    }
    
    
    func checkButton() {
        if selectedButton != nil , nameActionTextField?.text?.count ?? 0 > 0 {
            saveButton?.alpha = 1
            saveButton?.isEnabled = true
        } else {
            saveButton?.alpha = 0.5
            saveButton?.isEnabled = false
        }
        
    }
    
    
    func createButtons() {
        
        var tag = 0
        
        for image in imageArr {
            let button = UIButton(type: .system)
            button.tag = tag
            button.setImage(image.resize(targetSize: CGSize(width: 25, height: 25)), for: .normal)
            button.backgroundColor = .white
            button.tintColor = .greenFigma
            button.layer.cornerRadius = 16
            buttonsArr.append(button)
            button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            tag += 1
        }
    }
    
}


extension NewPlantHistoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        checkButton()
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkButton()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkButton()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkButton()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkButton()
    }
    
    
}
