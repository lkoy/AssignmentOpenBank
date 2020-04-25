//
//  UIImage+Url.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 06/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import UIKit.UIImage
import Alamofire
import AlamofireImage

public extension UIImage {
    
    enum Source {
        case cache
        case server
    }
    
    private static let imageCache = AutoPurgingImageCache()
    private static let imageCacheDisk = AutoPurgingImageCacheDisk()
    
    class func getCacheImageFrom(url: String?) -> Image? {
    
        guard let url = url else {
            return nil
        }
        
        if let memoryImage = imageCache.image(withIdentifier: url) {
            
            return memoryImage
            
        } else if let diskImage = imageCacheDisk.image(withIdentifier: url) {
            
            imageCache.add(diskImage, withIdentifier: url)
            return diskImage
            
        } else {
            
            return nil
        }
        
    }
    
    class func getCacheImageFrom(url: String, handler: @escaping (Image?) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
            
            if let memoryImage = imageCache.image(withIdentifier: url) {
                
                DispatchQueue.main.async {
                    handler(memoryImage)
                }
                
            } else if let diskImage = imageCacheDisk.image(withIdentifier: url) {
                
                imageCache.add(diskImage, withIdentifier: url)
                
                DispatchQueue.main.async {
                    handler(diskImage)
                }
                
            } else {
                
                DispatchQueue.main.async {
                    handler(nil)
                }
            }
        }
    }
    
    class func getImageFrom(url: String, handler: @escaping (Image?, Source) -> Void) {
        
        getCacheImageFrom(url: url) { (image) in
            
            if let image = image {
                handler(image, .cache)
                return
            }
            
            Alamofire.request(url).responseImage { response in
                
                guard let image = response.result.value else {
                    handler(nil, .server)
                    return
                }
                
                DispatchQueue.global(qos: .background).async {
                    
                    imageCache.add(image, withIdentifier: url)
                    imageCacheDisk.add(image, withIdentifier: url)
                    
                    DispatchQueue.main.async {
                        handler(image, .server)
                    }
                }
            }
        }
    }
    
}

public class AutoPurgingImageCacheDisk: ImageRequestCache {
    
    private let synchronizationQueue: DispatchQueue
    private func imageCacheKey(for request: URLRequest, withIdentifier identifier: String?) -> String {
        
        var key = request.url?.absoluteString ?? ""
        
        if let identifier = identifier {
            key += "-\(identifier)"
        }
        
        return key
    }
    
    public init() {
        
        self.synchronizationQueue = {
            let name = String(format: "AutoPurgingImageCacheDisk", arc4random(), arc4random())
            return DispatchQueue(label: name, attributes: .concurrent)
        }()
    }
    
    public func add(_ image: Image, for request: URLRequest, withIdentifier identifier: String?) {
        
        let requestIdentifier = imageCacheKey(for: request, withIdentifier: identifier)
        add(image, withIdentifier: requestIdentifier)
    }
    
    @discardableResult
    public func removeImage(for request: URLRequest, withIdentifier identifier: String?) -> Bool {
        
        let requestIdentifier = imageCacheKey(for: request, withIdentifier: identifier)
        return removeImage(withIdentifier: requestIdentifier)
    }
    
    public func image(for request: URLRequest, withIdentifier identifier: String?) -> Image? {
        
        let requestIdentifier = imageCacheKey(for: request, withIdentifier: identifier)
        return image(withIdentifier: requestIdentifier)
    }
    
    public func add(_ image: Image, withIdentifier identifier: String) {
        
        synchronizationQueue.async {
            do {
                let documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
                let id = (identifier as NSString).lastPathComponent
                let fileURL = documentsURL.appendingPathComponent("\(id).png")
                if let pngImageData = image.pngData() {
                    try pngImageData.write(to: fileURL, options: .atomic)
                }
            } catch {
                print("Couldn't save the image in the disk \(identifier)")
            }
        }
    }
    
    @discardableResult
    public func removeImage(withIdentifier identifier: String) -> Bool {
        
        var removed = false
        
        synchronizationQueue.sync {
            let documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let id = (identifier as NSString).lastPathComponent
            let filePath = documentsURL.appendingPathComponent("\(id).png").path
            if FileManager.default.fileExists(atPath: filePath) {
                do {
                    try FileManager.default.removeItem(atPath: filePath)
                    removed = true
                } catch {
                    removed = false
                    print("Couldn't remove the image from the disk \(identifier)")
                }
            }
        }
        
        return removed
    }
    
    @discardableResult
    public func removeAllImages() -> Bool {
        fatalError("Method not implemented removeAllImages")
    }
    
    public func image(withIdentifier identifier: String) -> Image? {
        
        var image: Image?
        synchronizationQueue.sync {
            
            let documentsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let id = (identifier as NSString).lastPathComponent
            let filePath = documentsURL.appendingPathComponent("\(id).png").path
            if FileManager.default.fileExists(atPath: filePath) {
                image = UIImage(contentsOfFile: filePath)
            }
        }
        
        return image
    }
    
}
