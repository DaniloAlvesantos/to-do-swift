import UIKit
import FirebaseFirestore

class HomeViewController: UIViewController {
    private var controller = TodoController()
    
    lazy var createToDoButton: CustomUIButton = {
        let button = CustomUIButton(title:"Add new")
        button.backgroundColor = .clear
        button.setTitleColor(.systemBlue, for: .normal)
        
        button.addTarget(self, action: #selector(handleAddToDo), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func handleAddToDo() {
        let alert = UIAlertController(title:"Todo title", message: "Add a title for your Todo list", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Shoping list"
            textField.autocapitalizationType = .words
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            if let textField = alert.textFields?.first, let text = textField.text, !text.isEmpty {
                self?.navigateToToDo(id: nil, title: text)
            }
        }
        
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title:"Cancel", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    private func navigateToToDo(id: String?, title: String) {
        let vc = ToDoViewController(id: id, title: title)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 12
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        return stack
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Home"
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        setupView()
    }
    
    private func getData() -> Void {
        Task {
            let response = await self.controller.getToDos()
            
            guard let data = response.data else {
                self.showAlert(title: "Error", message: response.message)
                return
            }
            
            displayData(data)
        }
    }
    
    private func displayData(_ data: [ToDoCollection]) {
        Task { @MainActor in
            stackView.arrangedSubviews.forEach{ $0.removeFromSuperview() }
            
            for item in data {
                var config = UIButton.Configuration.filled()
                
                config.title = item.title.isEmpty ? "Untitled List" : item.title
                config.titleAlignment = .leading
                
                let button = UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in
                    self?.navigateToToDo(id: item.id, title: item.title)
                })
                
                button.translatesAutoresizingMaskIntoConstraints = false
                stackView.addArrangedSubview(button)
                // add the button first...
                button.heightAnchor.constraint(equalToConstant: 38).isActive = true
            }
        }
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        view.addSubview(createToDoButton)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            createToDoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            createToDoButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            scrollView.topAnchor.constraint(equalTo: createToDoButton.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            

            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
}
