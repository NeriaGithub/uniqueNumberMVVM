//
//  ViewController.swift
//  uniqueNumberMVVM
//
//  Created by Neria Jerafi on 23/02/2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var numberCollectionView: UICollectionView!{
        didSet{
            // MARK: -  collectionViewConfigure
            
            //MARK: - Orange cell configure
            numberCollectionView.register(NumberCell.nib(), forCellWithReuseIdentifier: NumberCell.cellIdentifier)
            // MARK:- CollectionView Configure
            let margin:CGFloat = 20
            numberCollectionView.delegate = self
            numberCollectionView.dataSource = self
            guard let flowLayout = numberCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return  }
            flowLayout.minimumInteritemSpacing = margin
            flowLayout.minimumLineSpacing = margin
            flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        }
    }
    var numberListVM:NumberListViewModel!{
        didSet{
            numberListVM.fetchNumber { [weak self] in
                guard let strongSelf = self else { return}
                strongSelf.numberCollectionView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        numberListVM = NumberListViewModel()
    }
    
    
}
// MARK:- Collection View Data Source methods
extension ViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberListVM.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumberCell.cellIdentifier, for: indexPath) as! NumberCell
        cell.numberVM = numberListVM.numberViewModel(atIndex: indexPath.row)
        let number = numberListVM.numberModel?.numbers[indexPath.row].number ?? 0
        if numberListVM.uniqueNumbers.contains(number) {
            cell.bgView.backgroundColor = .systemOrange
        }else{
            cell.bgView.backgroundColor = .systemRed
        }
        return cell
    }
}
// MARK:- Collection View Delegate method
extension ViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellInRaw:CGFloat = 3// number of column you want
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else{return CGSize(width: 0, height: 0)}
        let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right + (flowLayout.minimumInteritemSpacing * (noOfCellInRaw - 1))
        let width = Int((collectionView.bounds.width - totalSpace) / noOfCellInRaw)
        let number = numberListVM.numberModel?.numbers[indexPath.row].number ?? 0
        
        if numberListVM.uniqueNumbers.contains(number){
            return CGSize(width: width, height: 100)
        }else{
            return CGSize(width: width, height: 50)
        }
    }
}


