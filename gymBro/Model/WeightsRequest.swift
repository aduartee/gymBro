import Foundation

struct WeightsRequest {
    var exerciseId: String
    var weightId: String
    var weight: Int
    var repetitions: Int
    var sets: Int
    var difficult: Difficult
    var registerAt: Date
}
