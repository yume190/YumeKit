//
//  Date.swift
//  MaxwinBus
//
//  Created by 9S on 2019/4/8.
//  Copyright © 2019 Yume. All rights reserved.
//

import UIKit

extension String {
    public func transform(originFormat: String, targetFormat: String) -> String? {
        let origin: DateFormatter = DateFormatter.taiwan(format: originFormat)
        let target: DateFormatter = DateFormatter.taiwan(format: targetFormat)
        
        guard let date = origin.date(from: self) else {return nil}
        return target.string(from: date)
    }
}
