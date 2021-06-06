//
//  ViewController.swift
//  uniqueNumberMVVM
//
//  Created by Neria Jerafi on 23/02/2021.
//

import UIKit
// MARK:- TestingManager class for Dependency Injection example
final class TestingManager {
    private init() {}
    static let shared = TestingManager()
    //  Dependency Injection example  will present when  status of testMode variable change   to true 
    private let testMode: Bool = false
    private let numbers: [Number] = [Number(number: 3),
                             Number(number: 5),
                             Number(number: 2),
                             Number(number: -5),
                             Number(number: -2),
                             Number(number: 1)]
    
    func getNumbers() -> [Number]? {
        if testMode {
            return numbers
        }
        return nil
    }
}

class ViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var numberCollectionView: UICollectionView!{
        didSet{
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
   private var numberListVM:NumberListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK:-example of Dependency Injection
        if let numbers = TestingManager.shared.getNumbers() {
            numberListVM = NumberListViewModel(numbers)
        }
        else {
            numberListVM = NumberListViewModel()
            numberListVM.fetchNumber()
        }
        bindViews()
    }
    
    private func bindViews() {
        numberListVM.isNumbersReceived.bind { [weak self] _ in
            self?.numberCollectionView.reloadData()
        }
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
        if numberListVM.isNumberContains(index: indexPath.row) {
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
        let number = numberListVM.numberModel?.numbers?[indexPath.row].number ?? 0
        
        if numberListVM.uniqueNumbers.contains(number){
            return CGSize(width: width, height: Constants.bigCellHeight)
        }else{
            return CGSize(width: width, height: Constants.smallCellHeight)
        }
    }
}


