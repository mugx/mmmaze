//
//  GameSession+Items.swift
//  mmmaze
//
//  Created by mugx on 31/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

extension GameSession {
	@objc func makeItem(col: Int, row: Int) -> Tile? {
		let col = Double(col)
		let row = Double(row)
		let frame = CGRect(x: col * TILE_SIZE, y: row * TILE_SIZE, width: TILE_SIZE, height: TILE_SIZE)
		let item = Tile(frame: frame)
		item.tag = -1

		let rand = Int.random(in: 0 ..< 100)
		switch rand {
		case 99 ... 100:
			item.tag = Int(TyleType.TTHearth.rawValue)
			item.image = UIImage(named: "hearth")
		case 98 ... 100:
			item.tag = Int(TyleType.TTTime.rawValue)
			item.animationImages = UIImage(named: "time")?.sprites(with: frame.size)
			item.animationDuration = 1
			item.startAnimating()
		case 90 ... 100:
			item.tag = Int(TyleType.TTWhirlwind.rawValue)
			item.image = UIImage(named: "whirlwind")?.colored(with: UIColor.white)
			item.spin()
		case 80 ... 100:
			item.tag = Int(TyleType.TTBomb.rawValue)
			item.image = UIImage(named: "bomb")?.colored(with: UIColor.red)
		case 50 ... 100:
			item.tag = Int(TyleType.TTCoin.rawValue)
			item.image = UIImage(named: "coin")?.colored(with: UIColor.yellow)
			item.spin()
		default:
			break
		}

		if item.tag != -1 {
			item.x = Int32(col)
			item.y = Int32(row)
			mazeView.addSubview(item)
			items.add(item)
			return item
		} else {
			return nil
		}
	}
}