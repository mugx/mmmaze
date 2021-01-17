//
//  MazeInteractor.swift
//  mmmaze
//
//  Created by mugx on 17/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import Foundation

class MazeInteractor {
	private var maze: Maze?
	private var rows: Int = 0
	private var columns: Int = 0

	init() {
		maze = Maze(rows: rows, columns: columns)
	}
}
