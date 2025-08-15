//
//  HomeViewController.swift
//  to-do
//
//  Created by Danilo Alves dos Santos on 22/03/25.
//

import UIKit

class HomeViewController: UIViewController {
    private lazy var todoField: TodoField = {
        return TodoField()
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [todoField])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 100, right: 20)
 
        return stackView
    }()
    
    @objc func addTodoField() {
        let newTodoField:TodoField = TodoField()
        newTodoField.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(newTodoField)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Home"
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        setupView()
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(addTodoField))
        doubleTapGesture.numberOfTapsRequired = 2
        self.stackView.addGestureRecognizer(doubleTapGesture)
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
