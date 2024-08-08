//
//  ExtensionEqVC.swift
//  pinUp
//
//  Created by Владимир Кацап on 08.08.2024.
//

import Foundation
import UIKit

extension EquimpetViewController {
    
    func loadPlantsArrFromFile() -> [Equipment]? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to get document directory")
            return nil
        }
        let filePath = documentDirectory.appendingPathComponent("equipment.plist")
        do {
            let data = try Data(contentsOf: filePath)
            let plantArr = try JSONDecoder().decode([Equipment].self, from: data)
            return plantArr
        } catch {
            print("Failed to load or decode athleteArr: \(error)")
            return nil
        }
    }
    
    func chechPlants() {
        if equipmentArr.count > 0 {
            noEqImageView?.alpha = 0
            collection?.alpha = 1
        } else {
            noEqImageView?.alpha = 1
            collection?.alpha = 0
        }
    }
    
    
    @objc func menuButtonTapped(_ sender: UIButton) {
        let firstAction = UIAction(title: "Edit", image: UIImage.editMenu.resize(targetSize: CGSize(width: 20, height: 20))) { _ in
            let vc = NewOrEditEquimpentViewController()
            vc.delegate = self
            vc.isNew = false
            vc.index = sender.tag
            self.present(vc, animated: true)
        }

        let secondAction = UIAction(title: "Delete", image: UIImage.del.resize(targetSize: CGSize(width: 20, height: 20))) { _ in
            equipmentArr.remove(at: sender.tag)
            do {
                let data = try JSONEncoder().encode(equipmentArr) //тут мкассив конвертируем в дату
                try self.saveAthleteArrToFile(data: data)
               
                self.reloadCollection()
            } catch {
                print("Failed to encode or save athleteArr: \(error)")
            }
        }
       

        let menu = UIMenu(title: "", children: [firstAction, secondAction])

        if #available(iOS 14.0, *) {
            sender.menu = menu
            sender.showsMenuAsPrimaryAction = true
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
    
    
}




extension EquimpetViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return equipmentArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "2", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 16

        let imageView = UIImageView(image: UIImage(data: equipmentArr[indexPath.row].image))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(90)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(8)
        }
        
        let nameLabel = UILabel()
        nameLabel.text = equipmentArr[indexPath.row].name
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        cell.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.left.equalTo(imageView.snp.right).inset(-10)
        }
        
        let statusTextLabel = UILabel()
        statusTextLabel.text = "Status: "
        statusTextLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        statusTextLabel.textColor = .black.withAlphaComponent(0.7)
        cell.addSubview(statusTextLabel)
        statusTextLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).inset(-10)
            make.centerY.equalToSuperview()
        }
        
        let statusLabel = UILabel()
        statusLabel.text = equipmentArr[indexPath.row].status
        statusLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        cell.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(statusTextLabel.snp.right)
        }
        
        if equipmentArr[indexPath.row].status == "Ok" {
            statusLabel.textColor = .greenFigma
        } else {
            statusLabel.textColor = .systemRed
        }
        
        let priceLabel = UILabel()
        priceLabel.text = "$ \(equipmentArr[indexPath.row].price)"
        priceLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        priceLabel.textColor = .black
        cell.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(15)
            make.left.equalTo(imageView.snp.right).inset(-10)
        }
        
       
        let button = UIButton(type: .system)
        button.tag = indexPath.row
        button.setImage(.menuBut, for: .normal)
        button.addTarget(self, action: #selector(menuButtonTapped(_:)), for: .touchUpInside)
        cell.addSubview(button)
        button.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 106)
    }
    
    
}



extension EquimpetViewController: EquimpetViewControllerDelegate {
    func reloadCollection() {
        chechPlants()
        collection?.reloadData()
        
        if equipmentArr.count > 0 {
            
            var total = 0
            var ok = 0
            var repair = 0
            
            
            for i in equipmentArr {
                total += i.price
                if i.status == "Ok" {
                    ok += 1
                }
                if i.status == "Under repair" {
                    repair += 1
                }
            }
            priceLabel?.text = "$\(total)"
            okLabel?.text = "\(ok)"
            repairLabel?.text = "\(repair)"
            
        } else {
            priceLabel?.text = "$ 0"
            okLabel?.text = "0"
            repairLabel?.text = "0"
        }
    }
    
    
    
    
}
