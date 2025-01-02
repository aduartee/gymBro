//
//  WeightsViewModel.swift
//  gymBro
//
//  Created by Arthur Duarte on 03/11/24.
//

import Foundation

class WeightsViewModel: WeightsViewModelProtocol {
    //Depedency Injection
    private var exerciseService: ExerciseServiceProtocol
    private var weightService: WeightsServiceProtocol
    
    init (exerciseService: ExerciseServiceProtocol = ExerciseService.shared, weightService: WeightsServiceProtocol = WeightService.shared) {
        self.exerciseService = exerciseService
        self.weightService = weightService
    }
    
    func getExerciseDataById(idCategory: String, exerciseId: String, completion: @escaping (ExerciseRequest?, Error?) -> Void) {
        exerciseService.fetchExerciseById(idCategory: idCategory, exerciseId: exerciseId) { data, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            completion(data, nil)
        }
    }
    
    func getWeightData(idCategory: String, exerciseId: String, completion: @escaping ([WeightsSection?], Error?) -> Void) {
        weightService.fetchWeightData(categoryId: idCategory, exerciseId: exerciseId) { weightData, error in
            if let error = error {
                completion([nil], error)
            }
            
            let validWeightData = weightData.compactMap({$0})
            let result = self.createSectionsFromWeights(weightData: validWeightData)
            completion(result, nil)
        }
    }
    
    func createSectionsFromWeights(weightData: [WeightsRequest]) -> [WeightsSection] {
        let sortedWeightData = weightData.sorted {$0.registerAt > $1.registerAt}
        let sections = createDictonaryForSection(from: sortedWeightData)
        let orderSection = orderWeightsByAsc(with: sections)
        
        let result = orderSection.map { (date) -> WeightsSection in
            let formattedDate = DateFormatterHelper.shared.formatDateToDayAndMonth(with: date)
            let weights = sections[date] ?? []
            return WeightsSection(registeredMonth: formattedDate, weigthData: weights)
        }
        
        return result
    }
    
    func createDictonaryForSection(from sortedData: [WeightsRequest]) ->  [Date: [WeightsRequest]] {
        let sections = Dictionary(grouping: sortedData) { (weight: WeightsRequest) -> Date in
           return DateFormatterHelper.shared.removeTime(from: weight.registerAt)
       }
        
        return sections
    }
    
    func orderWeightsByAsc(with sections: [Date : [WeightsRequest]]) -> [Dictionary<Date, [WeightsRequest]>.Keys.Element] {
        return sections.keys.sorted { $0 > $1}
    }
}
