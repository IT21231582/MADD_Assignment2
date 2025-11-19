import HealthKit

class HealthKitManager {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()

    private init() {}

    // MARK: - HealthKit Authorization
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }

        guard
            let steps = HKObjectType.quantityType(forIdentifier: .stepCount),
            let calories = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
            let exercise = HKObjectType.quantityType(forIdentifier: .appleExerciseTime)
        else {
            completion(false)
            return
        }

        let readTypes: Set<HKObjectType> = [
            steps,
            calories,
            exercise,
            HKObjectType.workoutType()
        ]

        healthStore.requestAuthorization(toShare: [], read: readTypes) { success, _ in
            DispatchQueue.main.async { completion(success) }
        }
    }

    // MARK: - Fetch Today's Steps
    func fetchTodaySteps(completion: @escaping (Double) -> Void) {
        guard let type = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(0)
            return
        }

        let start = Calendar.current.startOfDay(for: Date())

        let predicate = HKQuery.predicateForSamples(
            withStart: start,
            end: Date(),
            options: .strictStartDate
        )

        let query = HKStatisticsQuery(
            quantityType: type,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            let count = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
            completion(count)
        }

        healthStore.execute(query)
    }

    // MARK: - Fetch Today's Active Calories
    func fetchTodayCalories(completion: @escaping (Double) -> Void) {
        guard let type = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(0)
            return
        }

        let start = Calendar.current.startOfDay(for: Date())

        let predicate = HKQuery.predicateForSamples(
            withStart: start,
            end: Date(),
            options: .strictStartDate
        )

        let query = HKStatisticsQuery(
            quantityType: type,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            let cals = result?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
            completion(cals)
        }

        healthStore.execute(query)
    }

    // MARK: - Fetch Today's Exercise Minutes
    func fetchTodayExerciseMinutes(completion: @escaping (Double) -> Void) {
        guard let type = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else {
            completion(0)
            return
        }

        let start = Calendar.current.startOfDay(for: Date())

        let predicate = HKQuery.predicateForSamples(
            withStart: start,
            end: Date(),
            options: .strictStartDate
        )

        let query = HKStatisticsQuery(
            quantityType: type,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            let mins = result?.sumQuantity()?.doubleValue(for: .minute()) ?? 0
            completion(mins)
        }

        healthStore.execute(query)
    }

    // MARK: - Async Versions (for modern concurrency)
    func fetchTodayStepsAsync() async -> Double {
        await withCheckedContinuation { continuation in
            fetchTodaySteps { value in continuation.resume(returning: value) }
        }
    }

    func fetchTodayCaloriesAsync() async -> Double {
        await withCheckedContinuation { continuation in
            fetchTodayCalories { value in continuation.resume(returning: value) }
        }
    }

    func fetchTodayExerciseMinutesAsync() async -> Double {
        await withCheckedContinuation { continuation in
            fetchTodayExerciseMinutes { value in continuation.resume(returning: value) }
        }
    }
}
