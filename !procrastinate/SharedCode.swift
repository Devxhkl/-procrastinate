//
//  SharedCode.swift
//  !procrastinate
//
//  Created by Zel Marko on 3/29/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import Foundation
import DeviceKit

func widthForScreenSize(big: Bool) -> CGFloat {
	switch Device() {
	case .iPhone5, .iPhone5s, .iPhoneSE, .Simulator(.iPhone5), .Simulator(.iPhone5s), .Simulator(.iPhoneSE):
		return big ? 260.0 : 222.0
	case .iPhone6, .iPhone6s, .Simulator(.iPhone6), .Simulator(.iPhone6s):
		return big ? 315.0 : 268.0
	case .iPhone6Plus, .iPhone6sPlus, .Simulator(.iPhone6Plus), .Simulator(.iPhone6sPlus):
		return big ? 354.0 : 301.0
	default:
		return big ? 260.0 : 222.0
	}
}

func textLabelBottomDistance() -> CGFloat {
	switch Device() {
	case .iPhone5, .iPhone5s, .iPhoneSE, .Simulator(.iPhone5), .Simulator(.iPhone5s), .Simulator(.iPhoneSE):
		return 110.0
	case .iPhone6, .iPhone6s, .Simulator(.iPhone6), .Simulator(.iPhone6s):
		return 130.0
	case .iPhone6Plus, .iPhone6sPlus, .Simulator(.iPhone6Plus), .Simulator(.iPhone6sPlus):
		return 150.0
	default:
		return 80.0
	}
}
