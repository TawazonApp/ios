//
//  FileUtils.swift
//  NewLife
//
//  Created by Shadi on 14/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

class FileUtils: NSObject {
    
    static  func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func createDirectory(directoryName: String){
        let fileManager = FileManager.default
        let directoryPath = getDocumentsDirectory().stringByAppendingPathComponent(path: directoryName)
        
        if !fileManager.fileExists(atPath: directoryPath) {
            try? fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    static func getFilePath(fileName: String) -> String {
        return  getDocumentsDirectory().stringByAppendingPathComponent(path: fileName)
    }
    
    static func saveFile(fileData: Data, fileName: String) -> Bool {
        
        let fileManager = FileManager.default
        
        let filePath = getFilePath(fileName: fileName)
        return fileManager.createFile(atPath: filePath, contents: fileData, attributes: nil)
    }
    
    static func deleteFile(fileName: String) -> Bool {
        let fileManager = FileManager.default
        
        let filePath = getFilePath(fileName: fileName)
        return ((try? fileManager.removeItem(atPath: filePath)) != nil) ? true: false
    }
    
    static func deleteFile(filePath: String) -> Bool {
        let fileManager = FileManager.default
        return ((try? fileManager.removeItem(atPath: filePath)) != nil) ? true: false
    }
}
