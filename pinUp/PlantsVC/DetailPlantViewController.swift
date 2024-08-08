//
//  DetailPlantViewController.swift
//  pinUp
//
//  Created by Владимир Кацап on 06.08.2024.
//

import UIKit

protocol DetailPlantViewControllerDelegate: AnyObject {
    func reloadTables()
}

class DetailPlantViewController: UIViewController {
    
    let imageArr = [UIImage.hisOne, UIImage.hisTwo, UIImage.hisThree, UIImage.hisFour, UIImage.hisFive]
    
    var index = 0
    weak var delegate: PlantsViewControllerDelegate?
    var mainCollection: UICollectionView?
    var historyCollection: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        createInterface()
    }
    

    func createInterface() {
        
        let topLabel = UILabel()
        topLabel.text = plantsArr[index].name
        topLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        topLabel.textColor = .black
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(15)
        }
        
        let delButton = UIButton(type: .system)
        delButton.setTitle("Delete", for: .normal)
        delButton.setTitleColor(.systemRed, for: .normal)
        view.addSubview(delButton)
        delButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalTo(topLabel)
        }
        
        historyCollection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.showsVerticalScrollIndicator = false
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "2")
            collection.delegate = self
            collection.dataSource = self
            collection.backgroundColor = .clear
            return collection
        }()
        
        mainCollection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.showsVerticalScrollIndicator = false
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.delegate = self
            collection.dataSource = self
            collection.backgroundColor = .clear
            return collection
        }()
        view.addSubview(mainCollection!)
        mainCollection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(topLabel.snp.bottom).inset(-15)
        })
        
        delButton.addTarget(self, action: #selector(deletePlant), for: .touchUpInside)
        
    }
    
    func createCustomView(image: UIImage, text: String, greenText: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        
        let imageView = UIImageView(image: image.resize(targetSize: CGSize(width: 20, height: 21)))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.equalTo(21)
            make.width.equalTo(20)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
        }
        
        let blackLabel = UILabel()
        blackLabel.text = text
        blackLabel.font = .systemFont(ofSize: 16, weight: .bold)
        blackLabel.textColor = .black
        view.addSubview(blackLabel)
        blackLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView.snp.right).inset(-10)
        }
        
        let greenLabel = UILabel()
        greenLabel.text = greenText
        greenLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        greenLabel.textColor = .greenFigma
        view.addSubview(greenLabel)
        greenLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
        }
        
        return view
    }
    
    @objc func deletePlant() {
        plantsArr.remove(at: index)
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
    
    @objc func openNewHistory() {
       let vc = NewPlantHistoryViewController()
        vc.index = index
        vc.delegate = self
        self.present(vc, animated: true)
    }
    

}


extension DetailPlantViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainCollection {
            return 1
        } else {
            if plantsArr[index].history.count ?? 0 > 0 {
                return (plantsArr[index].history.count ?? 0) + 1
            } else {
                return 1
            }
           
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            
            let imageView = UIImageView(image: UIImage(data: plantsArr[index].image))
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 12
            imageView.clipsToBounds = true
            cell.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview()
                make.height.equalTo(209)
            }
            
            let nameLabel = UILabel()
            nameLabel.text = plantsArr[index].name
            nameLabel.font = .systemFont(ofSize: 34, weight: .bold)
            nameLabel.textColor = .black
            cell.addSubview(nameLabel)
            nameLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(imageView.snp.bottom).inset(-15)
            }
            
            let varietlyLabel = UILabel()
            varietlyLabel.text = plantsArr[index].variety
            varietlyLabel.font = .systemFont(ofSize: 17, weight: .regular)
            varietlyLabel.textColor = .black.withAlphaComponent(0.7)
            cell.addSubview(varietlyLabel)
            varietlyLabel.snp.makeConstraints { make in
                make.left.equalTo(nameLabel)
                make.top.equalTo(nameLabel.snp.bottom).inset(-5)
            }
            
            let tempView = createCustomView(image: .temp, text: "Temperature", greenText: "\(plantsArr[index].temp)°С")
            cell.addSubview(tempView)
            tempView.snp.makeConstraints { make in
                make.height.equalTo(53)
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(varietlyLabel.snp.bottom).inset(-15)
            }
            
            let humView = createCustomView(image: .hum, text: "Humidity", greenText: plantsArr[index].humidity)
            cell.addSubview(humView)
            humView.snp.makeConstraints { make in
                make.height.equalTo(53)
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(tempView.snp.bottom).inset(-5)
            }
            
            let typeView = createCustomView(image: .type, text: "Soil type", greenText: plantsArr[index].soil)
            cell.addSubview(typeView)
            typeView.snp.makeConstraints { make in
                make.height.equalTo(53)
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(humView.snp.bottom).inset(-5)
            }
            
            
            let periodLabel = UILabel()
            periodLabel.text = "Growth period: \(plantsArr[index].period) days"
            periodLabel.font = .systemFont(ofSize: 15, weight: .regular)
            periodLabel.textColor = .black.withAlphaComponent(0.4)
            cell.addSubview(periodLabel)
            periodLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(typeView.snp.bottom).inset(-15)
            }
            
            let whiteView = UIView()
            whiteView.backgroundColor = .white
            whiteView.layer.cornerRadius = 24
            cell.addSubview(whiteView)
            whiteView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.top.equalTo(periodLabel.snp.bottom).inset(-15)
            }
            
            let hisLabel = UILabel()
            hisLabel.text = "History"
            hisLabel.font = .systemFont(ofSize: 20, weight: .bold)
            hisLabel.textColor = .black
            whiteView.addSubview(hisLabel)
            hisLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(15)
                make.top.equalToSuperview().inset(15)
            }
            
            whiteView.addSubview(historyCollection!)
            historyCollection?.snp.makeConstraints({ make in
                make.left.right.equalToSuperview().inset(15)
                make.bottom.equalToSuperview()
                make.top.equalTo(hisLabel.snp.bottom).inset(-10)
            })
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "2", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            
            if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
                let addButton = UIButton(type: .system)
                addButton.backgroundColor = .greenFigma
                addButton.layer.cornerRadius = 20
                
                let imageView = UIImageView(image: UIImage.addHis)
                imageView.contentMode = .scaleAspectFit
                addButton.addSubview(imageView)
                imageView.snp.makeConstraints { make in
                    make.centerX.centerY.equalToSuperview()
                    make.width.equalTo(100)
                    make.height.equalToSuperview()
                }
                cell.backgroundColor = .clear
                cell.addSubview(addButton)
                addButton.snp.makeConstraints { make in
                    make.height.equalTo(56)
                    make.left.right.equalToSuperview()
                    make.centerX.centerY.equalToSuperview()
                }
                addButton.addTarget(self, action: #selector(openNewHistory), for: .touchUpInside)
                
            } else {
                cell.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
                cell.layer.cornerRadius = 16
                
                
                let image = imageArr[plantsArr[index].history[indexPath.row].indexImage]
                let newImage = image.withRenderingMode(.alwaysTemplate)
                newImage.withTintColor(.black)
                let imageView = UIImageView(image: newImage)
                imageView.tintColor = .black
                imageView.contentMode = .scaleAspectFit
                cell.addSubview(imageView)
                imageView.snp.makeConstraints { make in
                    make.height.width.equalTo(20)
                    make.centerY.equalToSuperview()
                    make.left.equalToSuperview().inset(15)
                }
                
                
                let nameLabel = UILabel()
                nameLabel.text = plantsArr[index].history[indexPath.row].action
                nameLabel.textColor = .black
                nameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
                cell.addSubview(nameLabel)
                nameLabel.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.left.equalTo(imageView.snp.right).inset(-15)
                }
                
                let dateLabel = UILabel()
                dateLabel.text =  dateFormatter(date: plantsArr[index].history[indexPath.row].date)
                dateLabel.textColor = .black.withAlphaComponent(0.4)
                dateLabel.font = .systemFont(ofSize: 13, weight: .regular)
                cell.addSubview(dateLabel)
                dateLabel.snp.makeConstraints { make in
                    make.right.equalToSuperview().inset(15)
                    make.centerY.equalToSuperview()
                }
                
                
                
            }
            
            return cell
        }
    }
    
    
    
    
    func dateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainCollection {
            return CGSize(width: collectionView.bounds.width, height: 680 + CGFloat((Float(plantsArr[index].history.count ?? 1) * 65.5)))
        } else {
            return CGSize(width: 358, height: 56)
        }
    }
    
   
    
}


extension DetailPlantViewController: DetailPlantViewControllerDelegate {
    
    
    func reloadTables() {
//        print(plantsArr[index].history?.count)
//        print(plantsArr[index].history, "dop")
        mainCollection?.reloadData()
        historyCollection?.reloadData()
    }
    
    
}
