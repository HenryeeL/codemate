import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var labelTitle: UILabel!
    var labelDifficulty: UILabel!
    var starStackView: UIStackView!
    var labelTime: UILabel!
    var labelCompletionStatus: UIImageView!  // Change to UIImageView for displaying an image

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelTitle()
        setupLabelDifficulty()
        setupStarStackView()
        setupLabelTime()
        setupLabelCompletionStatus()  // Setup the new label
        
        initConstraints()
        
    }
    
    func setupLabelCompletionStatus() {
        labelCompletionStatus = UIImageView()
        labelCompletionStatus.contentMode = .scaleAspectFit
        labelCompletionStatus.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelCompletionStatus)
        }
    
    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
        
        //working with the shadows and colors...
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 6.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 4.0
        wrapperCellView.layer.shadowOpacity = 0.4
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
        
    }
    
    func setupLabelTitle(){
        labelTitle = UILabel()
        labelTitle.font = UIFont.boldSystemFont(ofSize: 16)
        labelTitle.textColor = .black
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelTitle)
        
    }
    
    func setupLabelDifficulty(){
        labelDifficulty = UILabel()
        labelDifficulty.font = UIFont.boldSystemFont(ofSize: 14)
        labelDifficulty.textColor = .gray
        labelDifficulty.textAlignment = .right
        labelDifficulty.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelDifficulty)
        
    }
    
    func setupStarStackView(){
        starStackView = UIStackView()
        starStackView.axis = .horizontal
        starStackView.alignment = .fill
        starStackView.spacing = 4
        starStackView.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(starStackView)
        
    }
    
    func setupLabelTime(){
        labelTime = UILabel()
        labelTime.font = UIFont.boldSystemFont(ofSize: 14)
        labelTime.textAlignment = .right
        labelTime.textColor = .gray
        labelTime.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelTime)
        
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            labelTitle.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelTitle.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            labelTitle.heightAnchor.constraint(equalToConstant: 20),
            labelTitle.widthAnchor.constraint(equalToConstant: 200),
            
            labelDifficulty.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -16),
            labelDifficulty.centerYAnchor.constraint(equalTo: labelTitle.centerYAnchor),
            
            labelCompletionStatus.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor, constant: 16),
            labelCompletionStatus.widthAnchor.constraint(equalToConstant: 16),  // Fixed size for the icon
            labelCompletionStatus.heightAnchor.constraint(equalToConstant: 16), // Fixed size for the icon
            labelCompletionStatus.centerYAnchor.constraint(equalTo: starStackView.centerYAnchor),
            
            starStackView.trailingAnchor.constraint(equalTo: labelTime.leadingAnchor, constant:-8),
            starStackView.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 8),
            starStackView.heightAnchor.constraint(equalToConstant: 16),
            
            labelTime.trailingAnchor.constraint(equalTo: labelDifficulty.trailingAnchor),
            labelTime.centerYAnchor.constraint(equalTo: starStackView.centerYAnchor),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 56)
            // 10 + 8 + 20 + 8 + 16 = 56
        ])
    }
    
    func configure(with question:QuestionListItem, isCompleted: Bool){
        labelTitle.text = question.questionFrontendId + ". " + question.title
        labelDifficulty.text = question.difficulty
        
        let info = question.difficultyInfo
        configureStar(count: info.starCount)
        labelTime.text = info.time
        
        if isCompleted {
            labelCompletionStatus.image = UIImage(systemName: "checkmark.seal.fill")
            labelCompletionStatus.tintColor = .systemGreen  // Green for completed
            }
        else {
            labelCompletionStatus.image = UIImage(systemName: "checkmark.seal.fill")
            labelCompletionStatus.tintColor = .systemGray  // Green for completed
            }
        
    }
    
    private func configureStar(count:Int){
        starStackView.arrangedSubviews.forEach{$0.removeFromSuperview()}
        
        for i in 0..<3{
            let starImageView = UIImageView()
            if i < count {
                starImageView.image = UIImage(systemName: "star.fill")
            }
            else{
                starImageView.image = UIImage(systemName: "star")
            }
            starImageView.tintColor = .systemYellow
            starImageView.contentMode = .scaleAspectFit
            starStackView.addArrangedSubview(starImageView)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

