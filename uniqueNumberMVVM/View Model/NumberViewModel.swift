//
//  NumberViewModel.swift
//  uniqueNumberMVVM
//
//  Created by Neria Jerafi on 23/02/2021.
//

import Foundation

protocol NumberListViewModelProtocol {
    var isNumbersReceived: Observable<Bool> { get }
    var uniqueNumbers: [Int] { get set }
    func createUniqueNumbers(numberModel:NumberModel)
}


class NumberListViewModel: NumberListViewModelProtocol {
    //MARK: - Properties
    var isNumbersReceived: Observable<Bool> = Observable(false)
    var numberModel: NumberModel? {
        didSet {
            if let unWrappedNumberModel = numberModel {
                createUniqueNumbers(numberModel: unWrappedNumberModel)
                isNumbersReceived.value = true
            }
        }
    }
    var uniqueNumbers: [Int] = []
    
    var count: Int {
        return numberModel?.numbers?.count ?? 0
    }
    
    convenience init(_ numbers: [Number]) {
        self.init()
        self.numberModel = NumberModel(numbers: numbers)
        createUniqueNumbers(numberModel: numberModel!)
        isNumbersReceived.value = true
    }
    // MARK:- NumberListViewModel methods
    func createUniqueNumbers(numberModel: NumberModel) {
        guard let modelArray = numberModel.numbers else{return}
        let targetNumber = 0
        var dictionary:[Int:Int] = [:]
        for item in modelArray {
            guard let number = item.number else { return  }
            let difference = targetNumber - number
            if let _ = dictionary[difference] {
                uniqueNumbers.append(difference)
                uniqueNumbers.append(number)
            }
            dictionary[number] = number
        }
    }
    func fetchNumber(completion:@escaping ()->() = {}) {
        WebService.getRequest(stringURL: "\(Constants.baseURL)\(Constants.paste_key)") {[weak self] (result:Result<NumberModel,WebServiceError>) in
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
    
    func numberViewModel(atIndex index:Int) -> NumberViewModel? {
        guard let number = numberModel?.numbers?[index] else { return nil }
        return NumberViewModel(withNumber: number)
    }
    
    
    func isNumberContains(index: Int)->Bool{
        if let number = numberModel?.numbers?[index].number {
            return uniqueNumbers.contains(number)
        }
        return false
    }
}

class NumberViewModel {
    //MARK: - Property
    var number:Number
    init(withNumber number:Number) {
        self.number = number
    }
    
    var numberString: String {
        guard let number = number.number else { return "" }
        return String(number)
    }
}
