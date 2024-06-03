//
//  UIImage+Extensions.swift
//  RichEditorViewSample
//
//  Created by Ayyarappan K on 01/06/24.
//  Copyright © 2024 Caesar Wirth. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    func uploadData()->Data{
//        return UIImageJPEGRepresentation(self.compress(), 1)!
        return self.compressData()
    }
    
    func compress()->UIImage{
        let w = self.size.width
        let h = self.size.height
        var s: CGFloat = 1
        
        if w > 1024 || h > 1024{
            s = 1024 / max(w, h)
        }
        
        if s == 1{
            return self
        }else{
            return UIImage(data: self.jpegData(compressionQuality: 1)!, scale: s)!
        }
    }
    
    //maxSize KB
    func compressData(maxSize: Int = 2048)-> Data{
        //先判断当前质量是否满足要求，不满足再进行压缩
        var finallImageData = self.jpegData(compressionQuality: 1.0)
        let sizeOrigin      = finallImageData?.count
        let sizeOriginKB    = sizeOrigin! / 1024
        if sizeOriginKB <= maxSize {
            return finallImageData! as Data
        }
        
        //先调整分辨率
        var defaultSize = CGSize(width: 1024, height: 1024)
        let newImage = self.scaleToSize(defaultSize)
        
        finallImageData = newImage.jpegData(compressionQuality: 1.0);
        
        //保存压缩系数
        let compressionQualityArr = NSMutableArray()
        let avg = CGFloat(1.0/250)
        var value = avg
        
        var i = 250
        repeat {
            i -= 1
            value = CGFloat(i)*avg
            compressionQualityArr.add(value)
        } while i >= 1
        
        
        /*
         调整大小
         说明：压缩系数数组compressionQualityArr是从大到小存储。
         */
        //思路：使用二分法搜索
        finallImageData = self.halfFuntion(arr: compressionQualityArr.copy() as! [CGFloat], image: newImage, sourceData: finallImageData!, maxSize: maxSize)
        //如果还是未能压缩到指定大小，则进行降分辨率
        while finallImageData?.count == 0 {
            //每次降100分辨率
            if defaultSize.width-100 <= 0 || defaultSize.height-100 <= 0 {
                break
            }
            defaultSize = CGSize(width: defaultSize.width-100, height: defaultSize.height-100)
            let image = UIImage.init(data: newImage.jpegData(compressionQuality: compressionQualityArr.lastObject as! CGFloat)!)!.scaleToSize(defaultSize)
            finallImageData = self.halfFuntion(arr: compressionQualityArr.copy() as! [CGFloat], image: image, sourceData: image.jpegData(compressionQuality: 1.0)!, maxSize: maxSize)
        }
        
        return finallImageData! as Data
    }
    
    // MARK: - 二分法
    private func halfFuntion(arr: [CGFloat], image: UIImage, sourceData finallImageData: Data, maxSize: Int) -> Data? {
        var tempFinallImageData = finallImageData
        
        var tempData = Data.init()
        var start = 0
        var end = arr.count - 1
        var index = 0
        
        var difference = Int.max
        while start <= end {
            index = start + (end - start)/2
            
            tempFinallImageData = image.jpegData(compressionQuality: arr[index])!
            
            let sizeOrigin = tempFinallImageData.count
            let sizeOriginKB = sizeOrigin / 1024
            
            print("当前降到的质量：\(sizeOriginKB)\n\(index)----\(arr[index])")
            
            if sizeOriginKB > maxSize {
                start = index + 1
            } else if sizeOriginKB < maxSize {
                if maxSize-sizeOriginKB < difference {
                    difference = maxSize-sizeOriginKB
                    tempData = tempFinallImageData
                }
                end = index - 1
            } else {
                break
            }
        }
        return tempData
    }
    
    func scaleToSize(_ size: CGSize)->UIImage{
        var newImage : UIImage?
        
        UIGraphicsBeginImageContext(size)
        
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        if newImage == nil {
            print("could not scale image")
        }
        
        //pop the context to get back to the default
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
    
    func scalingAndCropping(_ targetSize: CGSize)->UIImage?{
        var newImage : UIImage?
        let imageSize = self.size
        let width = imageSize.width
        let height = imageSize.height
        let targetWidth = targetSize.width
        let targetHeight = targetSize.height
        var scaleFactor: CGFloat = 0.0
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var thumbnailPoint = CGPoint(x: 0, y: 0)
        
        if !imageSize.equalTo(targetSize) {
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight  / height
            
            if widthFactor > heightFactor{
                scaleFactor = widthFactor // scale to fit height
            }else {
                scaleFactor = heightFactor // scale to fit width
            }
            
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            
            //center the image
            if widthFactor > heightFactor{
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            }else if widthFactor < heightFactor{
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
        }
        
        // this will crop
        UIGraphicsBeginImageContext(targetSize)
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width  = scaledWidth;
        thumbnailRect.size.height = scaledHeight;
        
        self.draw(in: thumbnailRect)
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        if newImage == nil {
            print("could not scale image")
        }
        
        //pop the context to get back to the default
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    static var appIcon:UIImage?{
        if let icon = ((Bundle.main.infoDictionary as NSObject?)?.value(forKeyPath: "CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles") as? Array<Any>)?.last as? String{
            return UIImage(named: icon)
        }
        return nil
    }
    
    static var placeholder:UIImage?{
        return UIImage(named: "placeholder_loading.png")
    }
    
    class func create(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}
