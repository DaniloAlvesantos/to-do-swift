import UIKit

class ToDoViewController: UIViewController {
    private let controller: TodoController = TodoController()
    private var state: ToDoCollection
    private var isNewToDo: Bool = true
    
    init(id: String? = nil, title: String) {
        var finalId: String
        
        if let providedId = id, !providedId.isEmpty {
            finalId = providedId
            self.isNewToDo = false
        } else {
            let id = self.controller.createToDo().data
            
            finalId = id ?? UUID().uuidString
        }
        
        self.state = ToDoCollection(data: [], title: title)
        self.state.id = finalId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadExistingData() {
        Task {
            let response = await controller.getToDo(self.state.safeId)
            
            if let todoCollection = response.data {
                self.state = todoCollection
                
                await MainActor.run {
                    self.title = self.state.title
                    self.rebuildStackView()
                }
            }
        }
    }
    
    private func rebuildStackView() {
        stackView.arrangedSubviews.forEach { view in
            if view is TodoField { view.removeFromSuperview() }
        }
        
        for item in state.data {
            let field = TodoField()
            field.identifier = item.id!
            field.configure(id: item.id ?? UUID().uuidString, text: item.text, isCompleted: item.isCompleted)
            let index = max(0, stackView.arrangedSubviews.count - 1)
            stackView.insertArrangedSubview(field, at: index)
        }
    }
    
    private func saveToDo() {
        let updatedList: [ToDoType] = stackView.arrangedSubviews.compactMap { view in
            if let field = view as? TodoField {
                let currentId = field.identifier.isEmpty ? UUID().uuidString : field.identifier
                let currentState = field.state
                
                return ToDoType(id: currentId,
                                text: currentState.text,
                                isCompleted: currentState.isCompleted,
                                date: Date.now)
            }
            return nil
        }
        
        let collectionData = ToDoCollection(data: updatedList, title: self.state.title, updatedAt: nil)
        
        Task {
            let response = await self.controller.updateToDo(collectionData, id: self.state.safeId)
            
            if response.isError {
                await MainActor.run {
                    self.showAlert(title: "Error", message: response.message)
                }
            }
        }
    }
    
    private lazy var todoField: TodoField = {
        return TodoField()
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var buttonAddTodoField: CustomUIButton = {
        let button = CustomUIButton(title: "add", icon: .add)
        // button.configuration cause on setUpIcon it's using button.configuration
        button.configuration?.baseBackgroundColor = .clear
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        
        button.addTarget(self, action: #selector(addTodoField), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [todoField, buttonAddTodoField])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 100, right: 20)
        
        return stackView
    }()
    
    @objc private func addTodoField() {
        let newTodoField:TodoField = TodoField()
        let index = max(0, stackView.arrangedSubviews.count - 1)
        stackView.insertArrangedSubview(newTodoField, at: index)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if !isNewToDo { loadExistingData() }
        
        title = state.title
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.saveToDo()
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}

extension ToDoViewController {
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View fills the view
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Stack View inside Scroll View
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            
            // Stack View width matches scroll view’s frame width (minus margins)
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
        ])
    }
}
