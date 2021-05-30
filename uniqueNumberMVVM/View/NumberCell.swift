//
//  OrangeCell.swift
//  uniqueNumberMVVM
//
//  Created by Neria Jerafi on 23/02/2021.
//

import UIKit

class NumberCell: UICollectionViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    var numberVM:NumberViewModel?{
        didSet{
            if let VM = numberVM{
                numberLabel.text = VM.numberString
            }
        }
    }
    static let cellIdentifier = "NumberCell"
     static func nib() -> UINib {
        return UINib(nibName: cellIdentifier, bundle: nil)
    }
}
