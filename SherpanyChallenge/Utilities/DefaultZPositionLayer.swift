//
//  DefaultZPositionLayer.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 03/01/2018.
//  Copyright © 2018 Higher Order. All rights reserved.
//

import UIKit

/// Layer which has always default zPosition (0)
/// - seealso: https://stackoverflow.com/a/46737582
class DefaultZPositionLayer: CALayer {
    override var zPosition: CGFloat {
        get { return 0 }
        set {}
    }
}
