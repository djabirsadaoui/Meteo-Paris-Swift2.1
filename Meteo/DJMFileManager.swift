//
//  DJMFileManager.swift
//  Meteo
//
//  Created by djabir sadaoui on 25/11/2015.
//  Copyright © 2015 djabir. All rights reserved.
//

import UIKit

class DJMFileManager: NSObject {
    static var fileManager:DJMFileManager?
    
    /***** create singleton instance ******/
    class func sharedFileManager()->DJMFileManager{
        self.fileManager = (self.fileManager ?? DJMFileManager())
        return fileManager!
        
    }
    
    /************ return path of icon *********/
    func fileInDocumentsDirectory(filename: String) -> String {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
        let fileURL = documentsURL.URLByAppendingPathComponent(filename)
        return fileURL.path!
    }
    
    
    
    /***** save icon ******/
    func saveImage (image: UIImage, path: String ) -> Bool{
        let pngImageData = UIImagePNGRepresentation(image)
        let result = pngImageData!.writeToFile(path, atomically: true)
        return result
        
    }
    
    
    /***** load icon ******/
    func loadImageFromPath(nameFile: String) -> UIImage? {
        let path = fileInDocumentsDirectory(nameFile)
        let image = UIImage(contentsOfFile: path)
        if image == nil {
            print("missing image at: \(path)")
        }
        // this is just for you to see the path in case you want to go to the directory, using Finder.
        print("Loading image from path: \(path)")
        return image
        
    }

}
