import UIKit
import Foundation

class ViewController: UIViewController {
    private lazy var headerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var heading: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "To do"
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.textColor = .systemBlue
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var subHeading: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Manage your tasks here"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var nextPageButton: CustomUIButton = {
        let button = CustomUIButton(title: "Next")
        button.addTarget(
            self,
            action: #selector(goToHomeView),
            for: .touchUpInside)

        return button
    }()
    
    @objc func goToHomeView() {
        navigationController?.pushViewController(HomeViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupView()
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        view.addSubview(headerView)
        
        headerView.addSubview(heading)
        headerView.addSubview(subHeading)
        
        view.addSubview(nextPageButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 350)
        ])
        
        NSLayoutConstraint.activate([
            heading.heightAnchor.constraint(equalToConstant: 30),
            heading.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            heading.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            heading.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            subHeading.topAnchor.constraint(equalTo: heading.bottomAnchor, constant: 10),
            subHeading.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            subHeading.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            nextPageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextPageButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            nextPageButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            nextPageButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
    }
}
