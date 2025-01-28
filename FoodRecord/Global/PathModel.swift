//
//  PathModel.swift
//  FoodRecord
//
//  Created by 곽서방 on 1/28/25.
//

import Foundation

class PathModel: ObservableObject {
  @Published var tabPaths: [PathType]
  
  init(paths: [PathType] = []) {
    self.tabPaths = paths
  }
}
