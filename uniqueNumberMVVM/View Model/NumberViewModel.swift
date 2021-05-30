//
//  NumberViewModel.swift
//  uniqueNumberMVVM
//
//  Created by Neria Jerafi on 23/02/2021.
//

import Foundation

class NumberListViewModel {
    var numberModel:NumberModel?
    private (set) var uniqueNumbers:[Int] = []
    func fetchNumber(completion:@escaping ()->()) {
        WebService.getRequest {[weak self] (result:Result<NumberModel,WebServiceError>) in
            guard let strongSelf = self else { return}
            switch result {
            case .success(let data):
                strongSelf.numberModel = data
                strongSelf.createUniqueNumbers()
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
    
    func createUniqueNumbers() {
        guard let modelArray = numberModel?.numbers else { return}
        let sum = 0
        var dictionary:[Int:Int] = [:]
        for item in modelArray {
            let difference = sum - item.number
            if let _ = dictionary[difference] {
                uniqueNumbers.append(difference)
                uniqueNumbers.append(item.number)
            }
            dictionary[item.number] = item.number
        }
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
