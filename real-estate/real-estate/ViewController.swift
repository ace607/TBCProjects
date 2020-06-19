//
//  ViewController.swift
//  real-estate
//
//  Created by Admin on 6/12/20.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var listCollection: UICollectionView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var findRoomLabel: UILabel!
    private weak var blurView: UIView?
    
    var isSearching = false
    
    @IBOutlet weak var searchBarTop: NSLayoutConstraint!
    let respone = APIResponse()
    var allvilla = [villaInfo]()
    var filterArray = [villaInfo]()
    
    var imageIndeces = Set<Int>()
    
    // Filter Collections
    @IBOutlet weak var typeFilterCollection: UICollectionView!
    
    @IBOutlet weak var priceFilterCollection: UICollectionView!
    
    @IBOutlet weak var bedroomFilterCollection: UICollectionView!
    
    // Filter Options
    
    let typeFilters = ["Sale", "Rent"]
    let priceFilters = ["$", "$$", "$$$"]
    let bedroomFilters = [1, 2, 3, 4, 5, 6, 7]
    
    var selectedFilters = [
        "type": -1,
        "price": -1,
        "bedroom": -1
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        listCollection.delegate = self
        listCollection.dataSource = self
        
        searchBar.delegate = self
        respone.getBands { (vila) in
            self.allvilla = vila.properties.filter({ (villa) -> Bool in
                villa.thumbnail != nil
            })
            
            self.filterArray = vila.properties.filter({ (villa) -> Bool in
                villa.thumbnail != nil
            })
            
            DispatchQueue.main.async {
                self.listCollection.reloadData()
                
                
            }
        }
        
        searchBtn.layer.cornerRadius = 20
        filterBtn.layer.cornerRadius = 24
        filterView.layer.cornerRadius = 30
        
        typeFilterCollection.delegate = self
        typeFilterCollection.dataSource = self
        priceFilterCollection.delegate = self
        priceFilterCollection.dataSource = self
        bedroomFilterCollection.delegate = self
        bedroomFilterCollection.dataSource = self
    }
    
    
    @IBAction func onSearch(_ sender: UIButton) {
        if isSearching {
            closeSearch()
            sender.setImage(UIImage(named: "search_icon"), for: .normal)
            isSearching = false
        } else {
            showsearch()
            self.searchBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
            isSearching = true
        }
    }
    
    
    func showsearch(){
        searchBarTop.constant = 53
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.findRoomLabel.alpha = 0
            self.view.layoutIfNeeded()
        }) { (f) in
        }
    }
    func closeSearch(){
        searchBarTop.constant = -47
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.findRoomLabel.alpha = 1
            self.view.layoutIfNeeded()
        }) { (f) in
        }
    }
    
    
    @IBAction func onFilterBtn(_ sender: UIButton) {
        animateView()
    }
    
    
    @IBAction func onApply(_ sender: UIButton) {
        filterArray = allvilla.filter({ (vila) -> Bool in
            var isTrue = true
            if selectedFilters["type"] != -1 {
                switch selectedFilters["type"] {
                case 0:
                    isTrue = vila.prop_status != "for_sale" ? false : isTrue
                case 1:
                    isTrue = vila.prop_status != "for_rent" ? false : isTrue
                default:
                    print("")
                }
            }
            
            if selectedFilters["price"] != -1 {
                switch selectedFilters["price"] {
                case 0:
                    isTrue = vila.price > 1000000 ? false : isTrue
                case 1:
                    isTrue = vila.price > 2000000 || vila.price < 1000000 ? false : isTrue
                case 2:
                    isTrue = vila.price > 10000000 || vila.price < 2000000 ? false : isTrue
                default:
                    print("")
                }
            }
            
            if selectedFilters["bedroom"] != -1 {
                switch selectedFilters["bedroom"] {
                case 0:
                    isTrue = vila.beds != 1 ? false : isTrue
                case 1:
                    isTrue = vila.beds != 2 ? false : isTrue
                case 2:
                    isTrue = vila.beds != 3 ? false : isTrue
                case 3:
                    isTrue = vila.beds != 4 ? false : isTrue
                case 4:
                    isTrue = vila.beds != 5 ? false : isTrue
                case 5:
                    isTrue = vila.beds != 6 ? false : isTrue
                case 6:
                    isTrue = vila.beds != 7 ? false : isTrue
                default:
                    print("")
                }
            }
            
            
            return isTrue
            
        })
        listCollection.reloadData()
        closeview()
    }
    
    
    func animateView() {
        UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: [], animations: {
            self.blureffect()
            self.blurView?.alpha = 0
        }) { (f) in
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
                self.blurView?.alpha = 1
                self.filterView.frame.origin.y -= 480
                self.filterBtn.isHidden = true
            }) { (f) in
            }
        }
    }
    
    @objc func closeview() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.filterView.frame.origin.y += 480
            self.filterBtn.isHidden = false
            self.blurView?.alpha = 0
        }) { (f) in
            UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: [], animations: {
                self.blurView?.removeFromSuperview()
            }) { (f) in
            }
        }
    }
    
    func blureffect(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurView = blurEffectView
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, belowSubview: filterView)
        blurEffectView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.closeview)))
        
        
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        if targetContentOffset.pointee.y < scrollView.contentOffset.y {
            self.filterBtn.isHidden = false
        } else {
            self.filterBtn.isHidden = true
        }

    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            selectedFilters["type"] = indexPath.row
        }
        if collectionView.tag == 2 {
            selectedFilters["price"] = indexPath.row
        }
        if collectionView.tag == 3 {
            selectedFilters["bedroom"] = indexPath.row
        }
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 0 {
            return filterArray.count
        }
        
        if collectionView.tag == 1 {
            return typeFilters.count
        }
        
        if collectionView.tag == 2 {
            return priceFilters.count
        }
        
        if collectionView.tag == 3 {
            return bedroomFilters.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = listCollection.dequeueReusableCell(withReuseIdentifier: "home_cell", for: indexPath) as! HomeCollectionViewCell
            
            if !imageIndeces.contains(indexPath.row) {
                cell.isLoading(true)
                self.imageIndeces.insert(indexPath.row)
            }
            if filterArray.count > 1 {
                cell.home_price.text = "$ \(NumberFormatter.localizedString(from: NSNumber(value: filterArray[indexPath.row].price), number: NumberFormatter.Style.decimal))"
                if filterArray[indexPath.row].prop_status == "for_sale" {
                    cell.home_type.text = "FOR SALE"
                } else {
                    cell.home_type.text = "FOR RENT"
                }
                cell.bath_count.text = "\(filterArray[indexPath.row].baths ?? 0) Bathroom"
                cell.bed_count.text = "\(filterArray[indexPath.row].beds ?? 0) Bedroom"
                
                if let size = filterArray[indexPath.row].building_size {
                    cell.sqr.text = "\(size.size) Sqft"
                } else {
                    cell.sqr.text = "0 Sqft"
                }
                
                if let title = filterArray[indexPath.row].address?.city {
                    cell.home_title.text = "\(title)"
                } else {
                    cell.home_title.text = filterArray[indexPath.row].agents[0].name
                }
                
                filterArray[indexPath.row].thumbnail?.downloadImage { (image) in
                    DispatchQueue.main.async {
                        cell.home_img.image = image
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            if self.imageIndeces.contains(indexPath.row) {
                                cell.isLoading(false)
                            }
                            
                        }
                    }
                }
                
                cell.home_img.layer.cornerRadius = 15
            }
            
            return cell
        }
        
        if collectionView.tag == 1 {
            let cell = typeFilterCollection.dequeueReusableCell(withReuseIdentifier: "filter_cell1", for: indexPath) as! FilterCollectionViewCell
            
            cell.filterCellLabel.text = typeFilters[indexPath.row]
            
            cell.layer.cornerRadius = 36/2
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor(red: 121/255, green: 144/255, blue: 246/255, alpha: 1).cgColor
            
            return cell
        }
        
        if collectionView.tag == 2 {
            let cell = priceFilterCollection.dequeueReusableCell(withReuseIdentifier: "filter_cell2", for: indexPath) as! FilterCollectionViewCell
            
            cell.filterCellLabel.text = priceFilters[indexPath.row]
            
            cell.layer.cornerRadius = 36/2
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor(red: 121/255, green: 144/255, blue: 246/255, alpha: 1).cgColor
            
            return cell
        }
        
        if collectionView.tag == 3 {
            let cell = bedroomFilterCollection.dequeueReusableCell(withReuseIdentifier: "filter_cell3", for: indexPath) as! FilterCollectionViewCell
            
            cell.filterCellLabel.text = String(bedroomFilters[indexPath.row])
            
            cell.layer.cornerRadius = 36/2
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor(red: 121/255, green: 144/255, blue: 246/255, alpha: 1).cgColor
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            return CGSize(width: 88, height: 36)
        }
        
        if collectionView.tag == 2 {
            return CGSize(width: 72, height: 36)
        }
        
        if collectionView.tag == 3 {
            return CGSize(width: 56, height: 36)
        }
        
        return CGSize(width: self.view.frame.width, height: 290)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            filterArray = allvilla
        } else {
            filterArray = allvilla.filter({$0.address?.city?.contains(searchText) ?? false})
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.listCollection.reloadData()
        }
    }
}

extension String {
    func downloadImage(completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: self) else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
            completion(UIImage(data: data))
        }.resume()
    }
}
