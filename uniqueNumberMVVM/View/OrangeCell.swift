//
//  OrangeCell.swift
//  uniqueNumberMVVM
//
//  Created by Neria Jerafi on 23/02/2021.
//

import UIKit

class OrangeCell: UICollectionViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    
    var numberVM:NumberViewModel?{
        didSet{
            if let VM = numberVM{
                numberLabel.text = VM.numberString
            }
        }
    }
    
    static let cellIdentifier = "OrangeCell"
     static func nib() -> UINib {
        return UINib(nibName: cellIdentifier, bundle: nil)
    }


}
