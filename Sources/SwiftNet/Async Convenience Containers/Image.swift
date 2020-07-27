//
//  File.swift
//  
//
//  Created by SamuelIH on 7/27/20.
//

import Foundation
import SwiftUI
import UIKit
public struct SNetImage : View {
    
    public init(url: URL, retryTimes: Int = 5) {
        self._url = State.init(initialValue: url)
        self.retryTimes = retryTimes
    }
    
    @State private var url : URL
    var retryTimes : Int
    
    public var body: some View {
        SNetContent(initialView: {
            globalActivityIndicator
        }, request: {
            var i = 0
            var image: UIImage? = nil
            while i < self.retryTimes && image == nil {
                image = Self.downloadImage(from: self.url)
                i += 1
            }
            return image
        }) { img in
            if img != nil {
                Image(uiImage: img!)
                .resizable()
            }
        }
    }
    
    static func downloadImage(from url: URL) -> UIImage? {
        var image : UIImage? = nil
        let delayer = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: url, completionHandler: {data, response, url  in
            if let data = data {
                image = UIImage(data: data)
            }
            delayer.signal()
        }).resume()
        delayer.wait()
        return image
    }
}
