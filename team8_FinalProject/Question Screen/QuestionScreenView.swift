import UIKit

class QuestionScreenView: UIView {
    
    var searchPic: UIImageView!
    var textFieldSearch: UITextField!
    var tableViewQuestions: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupSearchPic()
        setupTextFieldSearch()
        setupTableViewQuestions()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSearchPic(){
        searchPic = UIImageView()
        searchPic.image = UIImage(systemName: "magnifyingglass.circle")?.withRenderingMode(.alwaysOriginal)
        searchPic.contentMode = .scaleToFill
        searchPic.clipsToBounds = true
        searchPic.layer.masksToBounds = true
        searchPic.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(searchPic)
    }
    
    
    func setupTextFieldSearch(){
        textFieldSearch = UITextField()
        textFieldSearch.placeholder = "Search Now"
        textFieldSearch.keyboardType = .default
        textFieldSearch.borderStyle = .roundedRect
        textFieldSearch.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldSearch)
        
    }
    
    func setupTableViewQuestions(){
        tableViewQuestions = UITableView()
        tableViewQuestions.register(QuestionTableViewCell.self, forCellReuseIdentifier: Configs.tableViewQuestion)
        tableViewQuestions.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewQuestions)
        
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            
            searchPic.widthAnchor.constraint(equalToConstant: 32),
            
            searchPic.heightAnchor.constraint(equalToConstant: 32),
            
            searchPic.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            
            searchPic.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            textFieldSearch.topAnchor.constraint(equalTo: searchPic.topAnchor),
            
            textFieldSearch.bottomAnchor.constraint(equalTo: searchPic.bottomAnchor),
            
            textFieldSearch.leadingAnchor.constraint(equalTo: searchPic.trailingAnchor, constant: 8),
            
            tableViewQuestions.topAnchor.constraint(equalTo: searchPic.bottomAnchor, constant: 8),
            
            tableViewQuestions.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            
            tableViewQuestions.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            tableViewQuestions.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
        ])
    }
    
}

