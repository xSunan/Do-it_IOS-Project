//
//  TasksTimeDelegate.swift
//  Time Arrangement
//
//  Created by sunan xiang on 2020/3/6.
//  Copyright © 2020 sunan xiang. All rights reserved.
//

import Foundation

protocol TasksTimeDelegate: class {
    func setTime(date: Date, isStart: Bool, indexPath: IndexPath) ->  Void
    
    
}
