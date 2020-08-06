//
//  MainViewController.swift
//  ToDoList
//
//  Created by Дмитрий Константинов on 06.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Properties
    private let tableView = UITableView()
    private var tasks: [String] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        setupTableView()
        setupNavigationItem()
    }

    // MARK: - Module functions
    private func setupTableView() {

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        tableView.register(UINib(nibName: ToDoTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: ToDoTableViewCell.identifier)
    }

    private func setupNavigationItem() {

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = "To-Do List"
    }

    // MARK: - Actions
    @objc func addButtonTapped() {
        print(#function)

        let alertController = UIAlertController(title: "New Task",
                                                message: "Please add a new task",
                                                preferredStyle: .alert)

        alertController.addTextField { _ in }

        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in

            let textField = alertController.textFields?.first
            if let newTask = textField?.text {
                self.tasks.insert(newTask, at: 0)
                self.tableView.reloadData()
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default) { _ in }

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
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

        cell?.textLabel?.text = tasks[indexPath.row]
        return cell ?? UITableViewCell()
    }
}
