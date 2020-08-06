//
//  TaskRepository.swift
//  ToDoList
//
//  Created by Дмитрий Константинов on 06.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import CoreData

protocol DatabaseProtocol {

    associatedtype EntityType
    associatedtype EntityProperty

    func saveData(_ property: EntityProperty, completion: @escaping (Result<EntityType, Error>) -> Void)
    func loadData(completion: @escaping (Result<[EntityType], Error>) -> Void)
    func removeAllData(completion: @escaping (Error?) -> Void)
    func removeData(_ entity: EntityType, completion: @escaping (Result<EntityType, Error>) -> Void)
}

class TaskRepository: DatabaseProtocol {

    // MARK: - typealias
    typealias EntityType = Task
    typealias EntityProperty = String

    // MARK: - Property
    private let context: NSManagedObjectContext

    // MARK: - Initialization
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func saveData(_ property: String, completion: @escaping (Result<Task, Error>) -> Void) {

        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: Task.self),
                                                      in: context) else {
                completion(.failure(NSError(domain: "CoreData",
                                            code: 404,
                                            userInfo: [NSLocalizedDescriptionKey: "Cannot find entity"])))
                return
        }

        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.title = property

        do {
            try context.save()
            completion(.success(taskObject))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }

    func loadData(completion: @escaping (Result<[Task], Error>) -> Void) {

        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            completion(.success(try context.fetch(fetchRequest)))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }

    func removeAllData(completion: @escaping (Error?) -> Void) {

        loadData { result in

            switch result {
            case .success(let tasks):
                tasks.forEach {
                    self.context.delete($0)
                }

                do {
                    try self.context.save()
                    completion(nil)
                } catch let error as NSError {
                    completion(error)
                }

            case .failure(let error):
                completion(error)
            }
        }
    }

    func removeData(_ entity: Task, completion: @escaping (Result<Task, Error>) -> Void) {

        context.delete(entity)
        do {
            try context.save()
            completion(.success(entity))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
}
