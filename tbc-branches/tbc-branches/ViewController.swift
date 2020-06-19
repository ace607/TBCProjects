//
//  ViewController.swift
//  tbc-branches
//
//  Created by Admin on 6/19/20.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var atmCollection: UICollectionView!
    
    var atms = [ATMBranch]()
    
    let viewModel = ATMViewModel()
    
    var selectedItem: ATMBranch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        atmCollection.delegate = self
        atmCollection.dataSource = self
        
        viewModel.getObjects { (objects) in
            self.atms.append(contentsOf: objects)
            DispatchQueue.main.async {
                self.atmCollection.reloadData()
            }
        }
    }

    

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = atms[indexPath.row]
        self.tabBarController?.selectedIndex = 2

        NotificationCenter.default.post(name: NSNotification.Name("show_pin"), object: nil, userInfo: ["selectedObj" : selectedItem])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return atms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = atmCollection.dequeueReusableCell(withReuseIdentifier: "atm_cell", for: indexPath) as! BranchAtmCollectionViewCell
        
        cell.name.text = atms[indexPath.row].nameGe
        cell.address.text = atms[indexPath.row].addressGe
        
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
