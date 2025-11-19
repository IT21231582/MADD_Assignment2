import SwiftUI
import CoreData
import Combine

@MainActor
class FitnessViewModel: ObservableObject {
    @Published var todaySteps: Int = 0
    @Published var todayCalories: Int = 0
    @Published var todayWorkoutMinutes: Int = 0

    @Published var summaries: [DailySummary] = []
    @Published var goal: Goal?

    private let hk = HealthKitManager.shared
    private let core = CoreDataManager.shared

    init() {
        loadGoal()
        requestHealth()
    }

    // MARK: - HealthKit Authorization
    func requestHealth() {
        hk.requestAuthorization { success in
            if success { self.refreshToday() }
        }
    }

    // MARK: - Refresh Today’s Data Safely
    func refreshToday() {
        Task {
            async let steps = hk.fetchTodayStepsAsync()
            async let calories = hk.fetchTodayCaloriesAsync()
            async let minutes = hk.fetchTodayExerciseMinutesAsync()

            let (s, c, m) = await (steps, calories, minutes)

            self.todaySteps = Int(s)
            self.todayCalories = Int(c)
            self.todayWorkoutMinutes = Int(m)

            saveToday()
        }
    }

    // MARK: - Goal Management
    func loadGoal() {
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()

        if let result = try? core.context.fetch(request), let g = result.first {
            self.goal = g
        } else {
            let newGoal = Goal(context: core.context)
            newGoal.steps = 6000
            newGoal.calories = 300
            newGoal.workoutMinutes = 20
            core.save()
            goal = newGoal
        }
    }

    func updateGoal(steps: Int, calories: Int, minutes: Int) {
        guard let goal = goal else { return }
        goal.steps = Int64(steps)
        goal.calories = Int64(calories)
        goal.workoutMinutes = Int64(minutes)
        core.save()
    }

    // MARK: - Save Today Summary (CRASH-PROOF)
    func saveToday() {
        let today = Calendar.current.startOfDay(for: Date())

        let request: NSFetchRequest<DailySummary> = DailySummary.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@", today as NSDate)

        // Fetch safely
        let existing = try? core.context.fetch(request)

        let summary = existing?.first ?? DailySummary(context: core.context)
        summary.date = today
        summary.steps = Int64(todaySteps)
        summary.calories = Int64(todayCalories)
        summary.workoutMinutes = Int64(todayWorkoutMinutes)
        summary.goalHit = todaySteps >= (goal?.steps ?? 0)

        core.save()
        loadHistory()
    }

    // MARK: - Load History
    func loadHistory() {
        let request: NSFetchRequest<DailySummary> = DailySummary.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        if let result = try? core.context.fetch(request) {
            self.summaries = result
        }
    }
}
