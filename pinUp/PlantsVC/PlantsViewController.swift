//
//  PlantsViewController.swift
//  pinUp
//
//  Created by Владимир Кацап on 05.08.2024.
//

import UIKit

protocol PlantsViewControllerDelegate: AnyObject {
    func reloadCollection()
}

class PlantsViewController: UIViewController {
    
    var noPlantsImageView: UIImageView?
    var collection: UICollectionView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        plantsArr = loadPlantsArrFromFile() ?? [Plant]()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        createInterface()
        chechPlants()
    }
    
    func createInterface() {
        
        let settingsButton = UIButton(type: .system)
        settingsButton.backgroundColor = .clear
        settingsButton.tintColor = .greenFigma
        settingsButton.setImage(.settings.resize(targetSize: CGSize(width: 27, height: 22)), for: .normal)
        view.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { make in
            make.height.width.equalTo(44)
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        let plantsLabel = UILabel()
        plantsLabel.text = "Plants"
        plantsLabel.textColor = .black
        plantsLabel.font = .systemFont(ofSize: 34, weight: .bold)
        view.addSubview(plantsLabel)
        plantsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(settingsButton.snp.bottom)
        }
        
        noPlantsImageView = {
            let imageView = UIImageView(image: .noPlants)
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        view.addSubview(noPlantsImageView!)
        noPlantsImageView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.height.equalTo(183)
            make.centerY.equalToSuperview()
        })
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.showsVerticalScrollIndicator = false
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.delegate = self
            collection.dataSource = self
            collection.backgroundColor = .clear
            return collection
        }()
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(plantsLabel.snp.bottom).inset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
    }
    

    func loadPlantsArrFromFile() -> [Plant]? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to get document directory")
            return nil
        }
        let filePath = documentDirectory.appendingPathComponent("plantssss.plist")
        do {
            let data = try Data(contentsOf: filePath)
            let plantArr = try JSONDecoder().decode([Plant].self, from: data)
            return plantArr
        } catch {
            print("Failed to load or decode athleteArr: \(error)")
            return nil
        }
    }
    
    
    func chechPlants() {
        if plantsArr.count > 0 {
            noPlantsImageView?.alpha = 0
            //показываем коллекцию
        } else {
            noPlantsImageView?.alpha = 1
            //скрыаем коллекцию
        }
    }
    
    
   

}


extension PlantsViewController: PlantsViewControllerDelegate {
    func reloadCollection() {
        print(23)
        collection?.reloadData()
    }
}


extension PlantsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plantsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 16
        
        let imageView = UIImageView(image: UIImage(data: plantsArr[indexPath.row].image))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(10)
            make.height.equalTo(156)
        }
        
        let nameLabel = UILabel()
        nameLabel.text = plantsArr[indexPath.row].name
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        cell.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(15)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 173, height: 210)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailPlantViewController()
        vc.index = indexPath.row
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    
}



//ДОДЕЛАТЬ ПРОСМОТР УДАЛЕНИЕ И ДОБАВЛЕНИЕ ИСТОРИИ К РАСТЕНИЮ
