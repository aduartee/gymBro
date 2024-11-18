import Foundation

struct WeightsRequest {
    var exerciseId: String
    var weightId: String
    var weight: Int
    var repetitions: Int
    var sets: String
    var difficult: String
    var registerAt: Date?
}
