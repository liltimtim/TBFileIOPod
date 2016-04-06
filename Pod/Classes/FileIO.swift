//
//  FileIO.swift
//  TBFileIO
//
//  Created by Timothy Barrett on 4/6/16.
//
//

import Foundation

public class FileIO:NSObject {
    public static let shared:FileIO = FileIO()
    private let fileManager = NSFileManager.defaultManager()
    public lazy private(set) var documentsDirectory:NSURL? = {
        return FileIO.shared.getDocumentDirectory()
    }()
    
    private override init() {
        
    }
    
    private struct ErrorMessages {
        static let NoDocumentsError = NSError(domain: "FileIO", code: 0, userInfo: ["error":"Could not determine default Document directory"])
        static let GeneralError = NSError(domain: "FileIO", code: 0, userInfo: ["error":"The operation could not be completed"])
    }
    
    public func createFolder(withName name:String) -> NSError?  {
        guard documentsDirectory != nil else { return ErrorMessages.NoDocumentsError }
        do {
            try fileManager.createDirectoryAtURL(documentsDirectory!.URLByAppendingPathComponent(name), withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            return error
        }
        return nil
    }
    
    public func removeFolder(withName name:String) -> NSError? {
        guard documentsDirectory != nil else { return ErrorMessages.NoDocumentsError }
        do {
            try fileManager.removeItemAtURL(documentsDirectory!.URLByAppendingPathComponent(name))
        } catch let error as NSError {
            return error
        }
        return nil
    }
    /** 
    Creates a file in the specified folder.  If the folder does not exist it will be created for you with the name provided. 
     
    - parameter destinationFolderName: Name of the destination folder
    - parameter object: NSData object to write to file
    - parameter fileName: Name of the file to be written
    
    - returns: NSError
    
    */
    public func writeObjectToFile(destinationFolder destinationFolderName:String, withObject object:NSData, withFileName fileName:String) -> NSError? {
        guard documentsDirectory != nil else { return ErrorMessages.NoDocumentsError }
        // check if folder exists
        if let pathToFolder = documentsDirectory!.URLByAppendingPathComponent(destinationFolderName).path {
            if !fileExists(pathToFolder) {
                // no folder create it
                if createFolder(withName: destinationFolderName) != nil {
                    return ErrorMessages.GeneralError
                }
            }
        } else {
            return ErrorMessages.GeneralError
        }
        if let pathToFile = documentsDirectory!.URLByAppendingPathComponent(destinationFolderName).URLByAppendingPathComponent(fileName).path {
            if !fileManager.createFileAtPath(pathToFile, contents: object, attributes: nil) {
                return ErrorMessages.GeneralError
            }
        } else {
            return ErrorMessages.GeneralError
        }
        return nil
    }
    
    public func removeFile(fromFolder folderName:String, fileName:String) -> NSError? {
        guard documentsDirectory != nil else { return ErrorMessages.NoDocumentsError }
        do {
            
            try fileManager.removeItemAtURL(documentsDirectory!.URLByAppendingPathComponent(folderName).URLByAppendingPathComponent(fileName))
        } catch let error as NSError {
            return error
        }
        return nil
    }
    
    public func listFolders() -> [NSURL]? {
        if let documentPath = documentsDirectory {
            do {
                let items = try fileManager.contentsOfDirectoryAtURL(documentPath, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles)
                return items
            } catch let error as NSError {
                print(error)
                return nil
            }
        }
        return nil
    }
    
    public func fileExists(path:String) -> Bool {
        return fileManager.fileExistsAtPath(path)
    }
    
    public func purgeAllCreatedFolders() -> NSError? {
        guard documentsDirectory != nil else { return ErrorMessages.NoDocumentsError }
        if let folders = listFolders() {
            for folder in folders {
                do {
                    try fileManager.removeItemAtURL(folder)
                } catch let error as NSError {
                    return error
                }
            }
        } else {
            return NSError(domain: "FileIO", code: 1, userInfo: ["error":"Could not get folders in Document directory"])
        }
        return nil
    }
    
    private func getDocumentDirectory() -> NSURL? {
        let paths = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        guard paths.count == 0 else {
            print("Document Path: \(paths.first)")
            return paths.first!
        }
        return nil
    }
}