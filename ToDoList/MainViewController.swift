//
//  MainViewController.swift
//  ToDoList
//
//  Created by Дмитрий Константинов on 06.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    // MARK: - Properties
    private lazy var tableView = UITableView(frame: view.frame)

    var database: TaskRepository?

    private var tasks: [Task] = [] {
        didSet { tableView.reloadData() }
    }

    // MARK: - Initialization
    convenience init(database: TaskRepository) {
        self.init()
        self.database = database
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigationItem()
        loadData()
    }

    // MARK: - Module functions
    private func setupTableView() {

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)

        tableView.register(UINib(nibName: ToDoTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: ToDoTableViewCell.identifier)
    }

    private func setupNavigationItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = "To-Do List"
    }

    private func loadData() {

        database?.loadData { [weak self] result in
            switch result {
            case .success(let tasks):
                self?.tasks = tasks
            case .failure(let error):
                print(error)
            }
        }
    }

    private func createAlertController() -> UIAlertController {

        let alertController = UIAlertController(title: "New Task",
                                                message: "Please add a new task",
                                                preferredStyle: .alert)

        alertController.addTextField { _ in }

        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { _ in

                let textField = alertController.textFields?.first
                if let property = textField?.text {
                    self.database?.saveData(property, completion: { result in
                        switch result {
                        case .success(let savedTask):
                            self.tasks.append(savedTask)
                        case .failure(let error):
                            print(error)
                        }
                    })
                }
        }

        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default) { _ in }

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        return alertController
    }

    // MARK: - Actions
    @objc func addButtonTapped() {
        let alertController = createAlertController()
        present(alertController, animated: true)
    }
}

// MARK: - TableView
extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView
            .dequeueReusableCell(withIdentifier: ToDoTableViewCell.identifier,
                                 for: indexPath) as? ToDoTableViewCell

        cell?.textLabel?.text = tasks[indexPath.row].title
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        database?.removeData(tasks[indexPath.row]) { [weak self] result in
            switch result {
            case .success(let removedTask):
                self?.tasks.removeAll { $0 == removedTask }
            case .failure(let error):
                print(error)
            }
        }
    }
}
