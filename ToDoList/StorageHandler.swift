//
//  StorageHandler.swift
//  Project3
//
//  Created by cpsc on 10/23/20.
//
import Foundation

struct StorageHandler {
    
    static var defaultStorage: UserDefaults = UserDefaults.standard;
    
    static let defaultKey = "TaskCollection"

    static func getStorage()  {
        if isSet(key: self.defaultKey) {
            let encodedString = UserDefaults.standard.dictionaryRepresentation()[self.defaultKey] as! String
            
            TaskManager.taskCollection = decodeCollection(encodedString.data(using: .utf8)!)
        }
    }
    
    static func isSet(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    static func set() {
        defaultStorage.set(encodeCollection(), forKey: self.defaultKey)
    }
    
    static func set(value: Task) {
        TaskManager.taskCollection.append(value)
        
        defaultStorage.set(encodeCollection(), forKey: self.defaultKey)
    }
    
    static func edit(index: Int, value: Task) {
        TaskManager.taskCollection[index] = value
        
        defaultStorage.set(encodeCollection(), forKey: self.defaultKey)
    }
    
    static func delete(index: Int) {
        TaskManager.taskCollection.remove(at: index)
        
        defaultStorage.set(encodeCollection(), forKey: self.defaultKey)
    }
    
    static func encodeCollection() -> String {
        //json encoder
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(TaskManager.taskCollection)
        else {
            return ""
        }
        //if encoding worked, convert json to a simple string and return
        guard let stringEncoded = String(data: encoded, encoding: .utf8)
        else {
            return ""
        }
        return stringEncoded
    }
    
    static func decodeCollection(_ encodedString: Data) -> [Task] {
        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode([Task].self, from: encodedString)
        else {
            let newTaskCollection: [Task] = []
            return newTaskCollection
        }
        return decoded
    }
    
    static func storageCount() -> Int {
        return TaskManager.taskCollection.count
    }

    
    static func reset() {
        UserDefaults.standard.dictionaryRepresentation().keys.forEach(UserDefaults.standard.removeObject(forKey:))
        
        TaskManager.taskCollection = []
    }
}
