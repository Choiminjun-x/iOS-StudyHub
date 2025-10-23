//
//  TodoListViewController.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 9/4/25.
//

import UIKit
import SnapKit

protocol ViewControllable: AnyObject {
    var viewController: UIViewController { get }
}

protocol TodoListViewControllable: ViewControllable {
    var listener: TodoListPresentableListener? { get set }
    
    func displayTodos(_ viewModels: [TodoItemViewModel])
}

class TodoListViewController: UIViewController, TodoListViewControllable {
    
    var viewController: UIViewController { return self }
    
    weak var listener: TodoListPresentableListener?
    
    private var tableView: UITableView!
    
    private var todoViewModels: [TodoItemViewModel] = []
    
    deinit {
        print(type(of: self), #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation()
        self.setupUI()
    }
    
    private func setupNavigation() {
        self.title = "Todo List"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTodoTapped)
        )
    }
    
    private func setupUI() {
        self.view.do { superView in
            superView.backgroundColor = .systemBackground
            
            self.tableView = UITableView().do {
                $0.delegate = self
                $0.dataSource = self
                $0.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoCell")
                
                superView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.edges.equalTo(self.view.safeAreaLayoutGuide)
                }
            }
        }
    }
    
    @objc private func addTodoTapped() {
        self.listener?.didTapAddTodo()
    }
    
    func displayTodos(_ viewModels: [TodoItemViewModel]) {
        self.todoViewModels = viewModels
        self.tableView.reloadData()
    }
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoTableViewCell
        
        let viewModel = todoViewModels[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(with: viewModel)
        cell.onToggle = { [weak self] in
            self?.listener?.didToggleTodo(at: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.listener?.didDeleteTodo(at: indexPath.row)
        }
    }
}

// Custom TableView Cell
class TodoTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let checkButton = UIButton(type: .system)
    var onToggle: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(checkButton)
        contentView.addSubview(titleLabel)
        
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            checkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkButton.widthAnchor.constraint(equalToConstant: 30),
            checkButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // ViewModel을 받아서 UI 업데이트 (비즈니스 로직 없음)
    func configure(with viewModel: TodoItemViewModel) {
        titleLabel.text = viewModel.displayTitle
        checkButton.setTitle(viewModel.checkButtonTitle, for: .normal)
        titleLabel.textColor = viewModel.titleColor
        titleLabel.alpha = viewModel.titleAlpha
    }
    
    @objc private func checkButtonTapped() {
        onToggle?()
    }
}


/// RIBs Router를 강하게 보유하며 내부의 실제 화면을 child 로 붙여주는 호스트
final class TodoListHostViewController: UIViewController {
    
    // Router를 강하게 보유하여 RIBs 수명주기 유지
    private let router: TodoListRouting
    private let contentViewController: UIViewController
    
    init(router: TodoListRouting) {
        self.router = router
        self.contentViewController = router.viewControllable.viewController
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 내부 실제 화면을 child 로 추가
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Todo List"
        self.view.backgroundColor = .systemBackground
        
        self.addChild(self.contentViewController)
        self.view.addSubview(self.contentViewController.view)
        self.contentViewController.view.frame = self.view.bounds
        self.contentViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentViewController.didMove(toParent: self)
        
        // child 의 내비게이션 아이템을 호스트로 반영
        self.title = self.contentViewController.title
        self.navigationItem.rightBarButtonItem = self.contentViewController.navigationItem.rightBarButtonItem
        self.navigationItem.leftBarButtonItem = self.contentViewController.navigationItem.leftBarButtonItem
        self.navigationItem.titleView = self.contentViewController.navigationItem.titleView
    }
}
