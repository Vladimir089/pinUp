//
//  OnbUserViewController.swift
//  pinUp
//
//  Created by Владимир Кацап on 05.08.2024.
//

import UIKit

class OnbUserViewController: UIViewController {
    
    var topLabel: UILabel?
    var imageView: UIImageView?
    
    var taps = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .greenFigma
        createInterface()
    }
    
    func createInterface() {
        
        topLabel = {
            let label = UILabel()
            label.text = "Keep records and statistics of your plants"
            label.numberOfLines = 2
            label.font = .systemFont(ofSize: 28, weight: .bold)
            label.textColor = .white
            label.textAlignment = .center
            return label
        }()
        view.addSubview(topLabel!)
        topLabel?.snp.makeConstraints({ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(30)
        })
        
        imageView = {
            let image = UIImage.page1
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        view.addSubview(imageView!)
        imageView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topLabel!.snp.bottom).inset(-30)
            make.height.equalTo(520)
        })
        
        let shadowImageView = UIImageView()
        let shadowImage = UIImage.shadow
        shadowImageView.image = shadowImage
        shadowImageView.contentMode = .scaleAspectFit
        view.addSubview(shadowImageView)
        shadowImageView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(169)
        }
        
        let nextButton = UIButton(type: .system)
        nextButton.backgroundColor = .white
        nextButton.layer.cornerRadius = 20
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        nextButton.setTitleColor(UIColor(red: 3/255, green: 136/255, blue: 104/255, alpha: 1), for: .normal)
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            
        }
        nextButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
    }
    

    @objc func buttonTap() {
        taps += 1
        switch taps {
        case 1:
            UIView.animate(withDuration: 0.2) { [self] in
                topLabel?.text = "Keep records of agricultural machinery"
                imageView?.image = .page2
            }
        case 2:
            UIView.animate(withDuration: 0.2) { [self] in
                topLabel?.text = "Leave important notes for better results"
                imageView?.image = .page3
            }
        case 3:
            self.navigationController?.setViewControllers([TabBarViewController()], animated: true)
        default:
            return
        }
        
        
    }
   

}
