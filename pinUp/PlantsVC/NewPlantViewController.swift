//
//  NewPlantViewController.swift
//  pinUp
//
//  Created by Владимир Кацап on 05.08.2024.
//

import UIKit

class NewPlantViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    weak var delegate: PlantsViewControllerDelegate?
    
    var saveButton: UIButton?
    
    var imageView: UIImageView?
    var nameTextField, varietlyTextField, periodTextField: UITextField?
    var tempTextField, humidTextField, soilTextField: UITextField?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        createInterface()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.reloadCollection()
    }
    
    func createInterface() {
        
        
        let label = UILabel()
        label.text = "New plant"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(15)
        }
        
        imageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 12
            imageView.isUserInteractionEnabled = true
            imageView.image = .no.resize(targetSize: CGSize(width: 76, height: 76))
            return imageView
        }()
        view.addSubview(imageView!)
        imageView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
            make.top.equalTo(label.snp.bottom).inset(-15)
        })
        let gesture = UITapGestureRecognizer(target: self, action: #selector(setImage))
        imageView?.addGestureRecognizer(gesture)
        
        saveButton = {
            let button = UIButton(type: .system)
            button.setTitle("Save", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
            button.setTitleColor(.greenFigma, for: .normal)
            button.isEnabled = false
            button.alpha = 0.5
            return button
        }()
        view.addSubview(saveButton!)
        saveButton?.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(label)
        }
        
        let descriptionLabel: UILabel = {
            let label = UILabel()
            label.text = "Description"
            label.textColor = .black
            label.font = .systemFont(ofSize: 18, weight: .bold)
            return label
        }()
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(imageView!.snp.bottom).inset(-25)
        }
        
        nameTextField = createTextField(placeholder: "Name")
        view.addSubview(nameTextField!)
        nameTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(52)
            make.top.equalTo(descriptionLabel.snp.bottom).inset(-15)
        })
        
        varietlyTextField = createTextField(placeholder: "Variety")
        view.addSubview(varietlyTextField!)
        varietlyTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(52)
            make.top.equalTo(nameTextField!.snp.bottom).inset(-10)
        })
        
        periodTextField = createTextField(placeholder: "Growth period")
        view.addSubview(periodTextField!)
        periodTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(52)
            make.top.equalTo(varietlyTextField!.snp.bottom).inset(-10)
        })
        
        
        let conditionsLabel: UILabel = {
            let label = UILabel()
            label.text = "Planting conditions"
            label.textColor = .black
            label.font = .systemFont(ofSize: 18, weight: .bold)
            return label
        }()
        view.addSubview(conditionsLabel)
        conditionsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(periodTextField!.snp.bottom).inset(-15)
        }
        
        tempTextField = createTextField(placeholder: "Temperature")
        view.addSubview(tempTextField!)
        tempTextField?.snp.makeConstraints({ make in
            make.height.equalTo(52)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(conditionsLabel.snp.bottom).inset(-15)
        })
        
        humidTextField = createTextField(placeholder: "Humidity")
        view.addSubview(humidTextField!)
        humidTextField?.snp.makeConstraints({ make in
            make.height.equalTo(52)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(tempTextField!.snp.bottom).inset(-10)
        })
        
        soilTextField = createTextField(placeholder: "Soil type")
        view.addSubview(soilTextField!)
        soilTextField?.snp.makeConstraints({ make in
            make.height.equalTo(52)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(humidTextField!.snp.bottom).inset(-10)
        })
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideKeyboardGesture)
        saveButton?.addTarget(self, action: #selector(createPlant), for: .touchUpInside)
    }
    
    @objc func createPlant() {
        let name: String = nameTextField?.text ?? ""
        let varietly: String = varietlyTextField?.text ?? ""
        let period: String = periodTextField?.text ?? ""
        let temp: String = tempTextField?.text ?? ""
        let humidity: String = humidTextField?.text ?? ""
        let type: String = soilTextField?.text ?? ""
        
        
        let plant = Plant(image: imageView?.image?.jpegData(compressionQuality: 0.5) ?? Data(), name: name, variety: varietly, period: period, temp: temp, humidity: humidity, soil: type, history: [])
        
        plantsArr.append(plant)
        print(plantsArr)
        
        //передача в фунцию save
         do {
             let data = try JSONEncoder().encode(plantsArr) //тут мкассив конвертируем в дату
             try saveAthleteArrToFile(data: data)
             delegate?.reloadCollection()
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
    
   
    
    
    
    
    
    func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.rightViewMode = .always
        textField.placeholder = placeholder
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.delegate = self
        textField.layer.cornerRadius = 18
        return textField
    }
    
    @objc func setImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
        checkTextFields()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView?.image = pickedImage
        }
        checkTextFields()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        checkTextFields()
    }
    
    @objc func hideKeyboard() {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
        checkTextFields()
        view.endEditing(true)
    }
    
    func checkTextFields() {
        if nameTextField?.text?.count ?? 0 > 0 , varietlyTextField?.text?.count ?? 0 > 0, periodTextField?.text?.count ?? 0 > 0, tempTextField?.text?.count ?? 0 > 0, humidTextField?.text?.count ?? 0 > 0, soilTextField?.text?.count ?? 0 > 0 {
            saveButton?.alpha = 1
            saveButton?.isEnabled = true
        } else {
            saveButton?.alpha = 0.5
            saveButton?.isEnabled = false
        }
    }
    
}


extension NewPlantViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
        checkTextFields()
        view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        checkTextFields()
        if textField == tempTextField || textField == humidTextField || textField == soilTextField {
            UIView.animate(withDuration: 0.3) {
                self.view.transform = CGAffineTransform(translationX: 0, y: -400)
                
            }
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkTextFields()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkTextFields()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkTextFields()
        return true
    }
}
