//
//  Record.swift
//  HabitTracker
//
//  Created by Bing Kuo on 2021/10/17.
//

import Foundation

struct Record {
    let id: UUID
    let habit: Habit
    let value: Int
    let date: Date
    
    var isAchieve: Bool {
        value >= habit.goal
    }
}
