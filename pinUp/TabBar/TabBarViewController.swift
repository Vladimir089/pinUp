//
//  TabBarViewController.swift
//  pinUp
//
//  Created by Владимир Кацап on 05.08.2024.
//

var plantsArr: [Plant] = []

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    let plantsVC = PlantsViewController()
    let eqimpVC = EquimpetViewController()
    
    let newPlantVC = NewPlantViewController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.setValue(true, forKey: "tab")

        tabBar.backgroundColor = .white
        tabBar.layer.cornerRadius = 20
        tabBar.layer.cornerRadius = 16
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.25
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        tabBar.layer.shadowRadius = 4
        tabBar.layer.masksToBounds = false
        tabBar.unselectedItemTintColor = .black.withAlphaComponent(0.2)
        tabBar.tintColor = .greenFigma
        
        settingsTB()
        self.delegate = self
    }
    
    
    func settingsTB() {
        
        let plantsTabBarItem = UITabBarItem(title: "", image: .tab1.resize(targetSize: CGSize(width: 24, height: 21)), tag: 0)
        plantsVC.tabBarItem = plantsTabBarItem
        
        let eqimpTabBarItem = UITabBarItem(title: "", image: .tab2.resize(targetSize: CGSize(width: 23, height: 21)), tag: 1)
        eqimpVC.tabBarItem = eqimpTabBarItem
        
        let imageNew = UIImage(named: "addNewPlant")!
        let imageOriginal = imageNew.withRenderingMode(.alwaysOriginal)
        let newPlantItem = UITabBarItem(title: "", image: imageOriginal, tag: 3)
        newPlantVC.tabBarItem = newPlantItem
        viewControllers = [plantsVC, eqimpVC, newPlantVC]
    }

    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
           if viewController.tabBarItem.tag == 3 {// Модальное представление NewPlantViewController
               
               switch tabBarController.selectedIndex {
               case 0:
                   let newPlantVC = NewPlantViewController()
                   newPlantVC.delegate = plantsVC.self
                   self.present(newPlantVC, animated: true, completion: nil)
               case 1:
                   let newEqVC = NewOrEditEquimpentViewController()
                   newEqVC.delegate = eqimpVC.self
                   newEqVC.isNew = true
                   self.present(newEqVC, animated: true, completion: nil)
               default:
                   break
               }

               
               return false 
           }
       
           return true // Для других табов возвращаем true
       }

}


extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


extension UIViewController {
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
