//
//  ViewController.swift
//  tbc-branches
//
//  Created by Admin on 6/19/20.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit
import Localize

class ViewController: UIViewController {
    @IBOutlet weak var atmCollection: UICollectionView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var langBtn: UIButton!
    
    var atms = [ATMBranch]()
    
    let viewModel = ATMViewModel()
    
    var selectedItem: ATMBranch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        atmCollection.delegate = self
        atmCollection.dataSource = self
        
        view.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        
        topBarView.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        topBarView.layer.shadowOffset = CGSize(width: 0, height: 2)
        topBarView.layer.shadowRadius = 6
        topBarView.layer.shadowOpacity = 1
        
        viewModel.getObjects { (objects) in
            self.atms.append(contentsOf: objects)
            DispatchQueue.main.async {
                self.atmCollection.reloadData()
            }
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangeLang(with:)),
            name: NSNotification.Name("change_lang"),
            object: nil)
        

    }
    
    @objc func didChangeLang(with notification: Notification) {
        self.atmCollection.reloadData()
        self.langBtn.setImage(Localize.currentLanguage == "en" ? UIImage(named: "img-flag-uk") : UIImage(named: "img-flag-georgia"), for: .normal)
        view.layoutIfNeeded()
    }
    
    
    @IBAction func changeLang(_ sender: UIButton) {
        if langBtn.currentImage == UIImage(named: "img-flag-uk") {
            langBtn.setImage(UIImage(named: "img-flag-georgia"), for: .normal)
            Localize.update(language: "ge")
            NotificationCenter.default.post(name: NSNotification.Name("change_lang"), object: nil)
        } else {
            langBtn.setImage(UIImage(named: "img-flag-uk"), for: .normal)
            Localize.update(language: "en")
            NotificationCenter.default.post(name: NSNotification.Name("change_lang"), object: nil)
        }
    }
    
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = atms[indexPath.row]
        self.tabBarController?.selectedIndex = 2
        
        NotificationCenter.default.post(name: NSNotification.Name("show_pin"), object: nil, userInfo: ["selectedObj" : selectedItem!])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return atms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = atmCollection.dequeueReusableCell(withReuseIdentifier: "atm_cell", for: indexPath) as! BranchAtmCollectionViewCell
        
        cell.name.text = Localize.currentLanguage == "ge" ? atms[indexPath.row].nameGe : atms[indexPath.row].nameEn
        cell.address.text = Localize.currentLanguage == "ge" ? atms[indexPath.row].addressGe : atms[indexPath.row].addressEn
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width - 48, height: 87)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 26, left: 24, bottom: 26, right: 24)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
