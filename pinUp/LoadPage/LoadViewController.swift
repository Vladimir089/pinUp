//
//  LoadViewController.swift
//  pinUp
//
//  Created by Владимир Кацап on 05.08.2024.
//

import UIKit
import SnapKit

class LoadViewController: UIViewController {
    
    var progressView: UIProgressView?
    var progress: Float = 0.0
    var timer: Timer?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .greenFigma
        createIterface()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(loadTimer), userInfo: nil, repeats: true)
    }
    
    @objc func loadTimer() {
        progress += 1  //менять на 0.03
        UIView.animate(withDuration: 0.1) { [self] in
            progressView?.setProgress(progress, animated: true)
        }
        
        if progress >= 1 {
            timer?.invalidate()
            timer = nil
            
            if isBet == false {
                if UserDefaults.standard.object(forKey: "tab") != nil {
                    self.navigationController?.setViewControllers([TabBarViewController()], animated: true)
                } else {
                   self.navigationController?.setViewControllers([OnbUserViewController()], animated: true)
                }
            } else {
                
            }
        }
    }
    

    func createIterface() {
        let imageView = UIImageView(image: UIImage(named: "LoadImage"))
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(390)
            make.centerY.equalToSuperview().offset(-50)
        }
        
        let loadLabel = UILabel()
        loadLabel.text = "Loading..."
        loadLabel.textColor = .white
        loadLabel.font = .systemFont(ofSize: 16, weight: .bold)
        view.addSubview(loadLabel)
        loadLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).inset(-100)
        }
        
        progressView = {
            let view = UIProgressView(progressViewStyle: .bar)
            view.setProgress(progress, animated: true)
            view.layer.cornerRadius = 6
            view.backgroundColor = UIColor(red: 68/255, green: 95/255, blue: 82/255, alpha: 1)
            view.progressTintColor = .white
            view.clipsToBounds = true
            return view
        }()
        view.addSubview(progressView!)
        progressView?.snp.makeConstraints({ make in
            make.height.equalTo(12)
            make.width.equalTo(176)
            make.centerX.equalToSuperview()
            make.top.equalTo(loadLabel.snp.bottom).inset(-15)
        })
    }

}
