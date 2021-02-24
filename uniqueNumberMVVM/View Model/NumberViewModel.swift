//
//  NumberViewModel.swift
//  uniqueNumberMVVM
//
//  Created by Neria Jerafi on 23/02/2021.
//

import Foundation

class NumberListViewModel {
    var numberModel:NumberModel?
    
    func fetchNumber(completion:@escaping ()->()) {
        WebService.getRequest {[weak self] (result:Result<NumberModel,WebServiceError>) in
            guard let strongSelf = self else { return}
            switch result {
            case .success(let data):
                strongSelf.numberModel = data
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    var count: Int {
       return numberModel?.numbers.count ?? 0
    }
    
    func numberViewModel(atIndex index:Int) -> NumberViewModel? {
        guard let number = numberModel?.numbers[index] else { return nil }
        return NumberViewModel(withNumber: number)
    }
    
    var uniqueNumbers: [Int] {
        var intArray:[Int] = []
        guard let modelArray = numberModel?.numbers else { return intArray }
        let sum = 0
        var dictionary:[Int:Int] = [:]
        for item in modelArray {
            let difference = sum - item.number
            if let _ = dictionary[difference] {
                intArray.append(difference)
                intArray.append(item.number)
            }
            dictionary[item.number] = item.number
        }
        return intArray
    }
}

class NumberViewModel {
    var number:Number
    init(withNumber number:Number) {
        self.number = number
    }
   
    var numberString: String {
        return String(number.number)
    }
}
