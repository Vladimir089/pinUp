//
//  NewOrEditEquimpentViewController.swift
//  pinUp
//
//  Created by Владимир Кацап on 08.08.2024.
//

import UIKit

class NewOrEditEquimpentViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    weak var delegate: EquimpetViewControllerDelegate?
    
    //red
    var index = 0
    var isNew = true
    
    //interface
    var topLabel: UILabel?
    var saveButton: UIButton?
    
    var imageView: UIImageView?
    var nameTextField, priceTextField: UITextField?
    var selectedStat = "Ok"
    
    
    var arrButtons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        createInterface()
        checkIsNew()
    }
    
    func checkIsNew() {
        if isNew == true {
            topLabel?.text = "New equipment"
            
        } else {
            topLabel?.text = "Edit equipment"
            imageView?.image = UIImage(data: equipmentArr[index].image)
            nameTextField?.text = equipmentArr[index].name
            priceTextField?.text = "\(equipmentArr[index].price)"
        }
    }
    
    func createInterface() {
        
        topLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 17, weight: .semibold)
            label.textColor = .black
            return label
        }()
        view.addSubview(topLabel!)
        topLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(15)
        })
        
        saveButton = UIButton(type: .system)
        saveButton!.setTitle("Save", for: .normal)
        saveButton!.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        saveButton!.setTitleColor(.greenFigma, for: .normal)
        saveButton?.isEnabled = false
        saveButton?.alpha = 0.5
        view.addSubview(saveButton!)
        saveButton?.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(topLabel!)
        }
        
        imageView = {
            let imageView = UIImageView(image: .no.resize(targetSize: CGSize(width: 47, height: 35)))
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            imageView.layer.cornerRadius = 12
            imageView.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
            return imageView
        }()
        view.addSubview(imageView!)
        imageView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.height.equalTo(209)
            make.top.equalTo(topLabel!.snp.bottom).inset(-20)
        })
        let gesture = UITapGestureRecognizer(target: self, action: #selector(setImage))
        imageView?.addGestureRecognizer(gesture)
        
        let deskLabel = createLabel(text: "Description")
        view.addSubview(deskLabel)
        deskLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(imageView!.snp.bottom).inset(-15)
        }
        
        nameTextField = createTextFields(placeholder: "Name:")
        view.addSubview(nameTextField!)
        nameTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(52)
            make.top.equalTo(deskLabel.snp.bottom).inset(-15)
        })
        
        priceTextField = createTextFields(placeholder: "Price:")
        priceTextField?.text = "0"
        priceTextField?.keyboardType = .numberPad
        view.addSubview(priceTextField!)
        priceTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(52)
            make.top.equalTo(nameTextField!.snp.bottom).inset(-5)
        })
        
        let statLabel = createLabel(text: "Status")
        view.addSubview(statLabel)
        statLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(priceTextField!.snp.bottom).inset(-15)
        }
        
        createButtons()
        
        view.addSubview(arrButtons[0])
        arrButtons[0].snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.equalToSuperview().inset(15)
            make.right.equalTo(view.snp.centerX).offset(-5)
            make.top.equalTo(statLabel.snp.bottom).inset(-15)
        }
        
        view.addSubview(arrButtons[1])
        arrButtons[1].snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.equalTo(view.snp.centerX).offset(5)
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(statLabel.snp.bottom).inset(-15)
        }
        
        let hideKBGesture = UITapGestureRecognizer(target: self, action: #selector(hideKB))
        view.addGestureRecognizer(hideKBGesture)
        saveButton?.addTarget(self, action: #selector(saveEq), for: .touchUpInside)
    }
    
    @objc func saveEq() {
        
        let newImage = imageView?.image?.jpegData(compressionQuality: 0.5) ?? Data()
        let newName = nameTextField?.text ?? ""
        let price = Int(priceTextField?.text ?? "0") ?? 0
        let status = selectedStat
        
        let newEq = Equipment(image: newImage, name: newName, price: price, status: status)
        
        if isNew == true {
            equipmentArr.append(newEq)
        } else {
            equipmentArr[index] = newEq
        }
        
        do {
            let data = try JSONEncoder().encode(equipmentArr) //тут мкассив конвертируем в дату
            try saveAthleteArrToFile(data: data)
           
            self.delegate?.reloadCollection()
            self.dismiss(animated: true)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
    }
    
    
    func saveAthleteArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("equipment.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
    
    
    
    func createButtons() {
        let okButton = UIButton(type: .system)
        okButton.backgroundColor = .greenFigma
        okButton.layer.cornerRadius = 16
        okButton.setTitleColor(.white, for: .normal)
        
        okButton.contentHorizontalAlignment = .center
        okButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 90)
        okButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 80)
        okButton.addTarget(self, action: #selector(butTabbed(sender:)), for: .touchUpInside)
        
        if let image = UIImage(named: "ok")?.resize(targetSize: CGSize(width: 24, height: 22)) {
            let originalImage = image.withRenderingMode(.alwaysOriginal)
            okButton.setImage(originalImage, for: .normal)
        }
        okButton.setTitle("Ok", for: .normal)
        arrButtons.append(okButton)
        
        let repairButton = UIButton(type: .system)
        repairButton.backgroundColor = .white
        repairButton.layer.cornerRadius = 16
        repairButton.setTitleColor(.black, for: .normal)
        repairButton.setImage(.unsel.resize(targetSize: CGSize(width: 24, height: 22)), for: .normal)
        repairButton.setTitle("Under repair", for: .normal)
        repairButton.contentHorizontalAlignment = .center
        repairButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        repairButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        repairButton.addTarget(self, action: #selector(butTabbed(sender:)), for: .touchUpInside)
        arrButtons.append(repairButton)
    }
    
    @objc func butTabbed(sender: UIButton) {
        for i in arrButtons {
            if i.backgroundColor == .greenFigma {
                i.backgroundColor = .white
                i.setImage(.unsel.resize(targetSize: CGSize(width: 24, height: 22)), for: .normal)
                i.setTitleColor(.black, for: .normal)
            }
        }
        
        if let image = UIImage(named: "ok")?.resize(targetSize: CGSize(width: 24, height: 22)) {
            let originalImage = image.withRenderingMode(.alwaysOriginal)
            sender.setImage(originalImage, for: .normal)
        }
        selectedStat = sender.titleLabel?.text ?? ""
        print(selectedStat)
        sender.backgroundColor = .greenFigma
        sender.setTitleColor(.white, for: .normal)
    }
    
    func createTextFields(placeholder: String) -> UITextField {
        let textField = UITextField()
        let label = UILabel()
        label.text = "    \(placeholder)"
        label.textColor = .black.withAlphaComponent(0.4)
        label.font = .systemFont(ofSize: 15, weight: .regular)
        textField.leftView = label
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.delegate = self
        
        textField.backgroundColor = .white
        textField.textAlignment = .right
        textField.layer.cornerRadius = 16
        return textField
    }
    
    func checkSave() {
        if nameTextField?.text?.count ?? 0 > 0 , priceTextField?.text?.count ?? 0 > 0 {
            saveButton?.alpha = 1
            saveButton?.isEnabled = true
        } else {
            saveButton?.alpha = 0.5
            saveButton?.isEnabled = false
        }
    }
    
    
    func createLabel(text: String) -> UILabel {
        let deskLabel = UILabel()
        deskLabel.text = text
        deskLabel.textColor = .black
        deskLabel.font = .systemFont(ofSize: 18, weight: .bold)
        return deskLabel
    }
    
    @objc func hideKB() {
        view.endEditing(true)
    }
    
    
    @objc func setImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView?.image = pickedImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        checkSave()
    }
    
    
    
}


extension NewOrEditEquimpentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        checkSave()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkSave()
        return true
    }
}
