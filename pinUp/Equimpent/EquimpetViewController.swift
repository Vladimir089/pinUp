//
//  EquimpetViewController.swift
//  pinUp
//
//  Created by Владимир Кацап on 08.08.2024.
//

import UIKit

var equipmentArr: [Equipment] = []

protocol EquimpetViewControllerDelegate: AnyObject {
    func reloadCollection()
}

class EquimpetViewController: UIViewController {
    
    var priceLabel, okLabel, repairLabel: UILabel?
    
    var noEqImageView: UIImageView?
    
    var collection: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        equipmentArr = loadPlantsArrFromFile() ?? [Equipment]()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        createInterface()
        reloadCollection()
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
        plantsLabel.text = "Equipment"
        plantsLabel.textColor = .black
        plantsLabel.font = .systemFont(ofSize: 34, weight: .bold)
        view.addSubview(plantsLabel)
        plantsLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(settingsButton.snp.bottom)
        }
        
        priceLabel = createLabel()
        priceLabel?.text = "$ 0"
        
        okLabel = createLabel()
        repairLabel = createLabel()
        
        
        let priceView = createView(image: UIImage.dollar, label: priceLabel ?? UILabel(), text: "Total price")
        let okView = createView(image: UIImage.okEq, label: okLabel ?? UILabel(), text: "Ok")
        let repView = createView(image: UIImage.rep, label: repairLabel ?? UILabel(), text: "Under repair")
        
        
        let stackView = UIStackView(arrangedSubviews: [priceView, okView, repView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(118)
            make.top.equalTo(plantsLabel.snp.bottom).inset(-15)
        }
        
        noEqImageView = {
            let imageView = UIImageView(image: .noEq)
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        view.addSubview(noEqImageView!)
        noEqImageView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.centerX.centerY.equalToSuperview()
        })
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "2")
            collection.backgroundColor = .clear
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).inset(-15)
        })
        
    }
    
    
    
    
    func createView(image: UIImage, label: UILabel, text: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        
        let imageView = UIImageView(image: image.resize(targetSize: CGSize(width: 32, height: 27)))
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.equalTo(27)
            make.width.equalTo(32)
            make.left.top.equalToSuperview().inset(15)
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.centerY.equalToSuperview().offset(15)
        }
        
        let textLabel = UILabel()
        textLabel.font = .systemFont(ofSize: 12, weight: .regular)
        textLabel.text = text
        textLabel.textColor = .black.withAlphaComponent(0.4)
        view.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview().inset(15)
        }
        view.clipsToBounds = true
        
        return view
    }
    
    func createLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.text = "0"
        return label
    }

}

