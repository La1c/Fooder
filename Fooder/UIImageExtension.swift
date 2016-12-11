//
//  UIImageExtension.swift
//  Fooder
//
//  Created by Vladimir on 21.11.16.
//  Copyright © 2016 Vladimir Ageev. All rights reserved.
//

import UIKit
import Alamofire


extension UIImageView{
    public func imageFromUrl(urlString: String) {
        Alamofire.request(urlString, method: HTTPMethod.get).response(completionHandler: {response in
            self.image = UIImage(data: response.data!, scale: 1)
        })
    }
}
