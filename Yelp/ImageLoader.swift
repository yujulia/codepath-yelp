//
//  ImageLoader.swift
//  Yelp
//
//  Created by Julia Yu on 2/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation

import Foundation
import AFNetworking

class ImageLoader {
    
    static func loadImage(urlString: String, imageview: UIImageView) {
        ImageLoader.loadImage(urlString, imageview: imageview, callback:nil)
    }
    
    static func loadImage(urlString: String, imageview: UIImageView, callback: (()->Void)?) {
        
        if let url = NSURL(string:urlString) {
            let urlRequest = NSURLRequest(URL: url)
            
            imageview.setImageWithURLRequest(
                urlRequest,
                placeholderImage: nil,
                success: {(req: NSURLRequest, response: NSURLResponse?, image: UIImage) -> Void in
                    
                    imageview.image = image
                    if let callback = callback {
                        callback()
                    }
                },
                failure: nil
            )
        }
    }
}