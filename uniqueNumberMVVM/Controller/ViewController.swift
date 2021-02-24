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
            collectionViewConfigure()
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
    
   private func collectionViewConfigure() {
    //MARK: - Orange cell configure
    numberCollectionView.register(OrangeCell.nib(), forCellWithReuseIdentifier: OrangeCell.cellIdentifier)
    //MARK: - Red cell configure
    numberCollectionView.register(RedCell.nib(), forCellWithReuseIdentifier: RedCell.cellIdentifier)
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

extension ViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberListVM.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let number = numberListVM.numberModel?.numbers[indexPath.row].number ?? 0
        if numberListVM.uniqueNumbers.contains(number) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrangeCell.cellIdentifier, for: indexPath) as! OrangeCell
            cell.numberVM = numberListVM.numberViewModel(atIndex: indexPath.row)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RedCell.cellIdentifier, for: indexPath) as! RedCell
            cell.numberVM = numberListVM.numberViewModel(atIndex: indexPath.row)
            return cell
        }
    }
}

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

