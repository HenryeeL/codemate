
import UIKit

class MainScreenView: UIView {

    var labelWelcome: UILabel!
    var labelPopularStudyList: UILabel!
    var button1: UIButton!
    var button2: UIButton!
    var labelRecommendForYouList: UILabel!
    var button3: UIButton!
    var button4: UIButton!
    var button5: UIButton!
    var button6: UIButton!
    var button7: UIButton!
    var button8: UIButton!

    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        // Add gradient background
        setupGradientBackground()
        setupLabelWelcome()
        setupLabelPopularStudyList()
        setupbutton1()
        setupbutton2()
        setupLabelRecommendForYouList()
        setupbutton3()
        setupbutton4()
        setupbutton5()
        setupbutton6()
        setupbutton7()
        setupbutton8()
        initConstraints()
    }
    // Method to setup the gradient background
        func setupGradientBackground() {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = bounds
            
            // Define gradient colors with alpha for transparency
            gradientLayer.colors = [
                UIColor.systemBlue.withAlphaComponent(0.1).cgColor,  // Light blue
                UIColor.white.cgColor  // White color
            ]
            
            gradientLayer.locations = [0.0, 1.0]
            layer.insertSublayer(gradientLayer, at: 0) // Add the gradient as the background layer
        }
        
        // Update gradient background on bounds change (important for rotation/resizing)
        override func layoutSubviews() {
            super.layoutSubviews()
            if let gradientLayer = layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
                gradientLayer.frame = bounds
            }
        }
    
    func setupLabelWelcome(){
        labelWelcome = UILabel()
        labelWelcome.text = "Welcome"
        labelWelcome.font = .boldSystemFont(ofSize: 32)
        labelWelcome.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelWelcome)
    }
    
    func setupLabelPopularStudyList(){
        labelPopularStudyList = UILabel()
        labelPopularStudyList.font = .boldSystemFont(ofSize: 20)
        labelPopularStudyList.text = "Popular Study Lists"
        labelPopularStudyList.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelPopularStudyList)
        
    }
    
    func setupbutton1(){
        button1 = UIButton(type: .system)
        
        // Use the custom image from your asset catalog's "Image" folder
        if let image = UIImage(named: "array") {
            
            // Resize the image to a specific size (e.g., 60x60)
            let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 140, height: 140))
            // Add black border to the image
            let imageView = UIImageView(image: resizedImage)
            imageView.layer.borderColor = UIColor.black.cgColor // Set black border color
            imageView.layer.borderWidth = 2.0 // Set border width

            
            
            // Create a button configuration
            var buttonConfig = UIButton.Configuration.filled()

            // Set the resized image and title for the button
            buttonConfig.image = resizedImage
            buttonConfig.title = "Array"
            
            // Set the layout of the image and title
            buttonConfig.imagePlacement = .top       // Places the image at the top
            buttonConfig.imagePadding = 10            // Space between image and title
            buttonConfig.titlePadding = 8            // Padding around the title
            
            // Set the button background color to white
            buttonConfig.background = UIBackgroundConfiguration.clear() // Transparent background
            buttonConfig.background.backgroundColor = .clear  // Set the background color to white
            
            // Set the title color using attributedTitle
            buttonConfig.attributedTitle = AttributedString("Array", attributes: .init([.foregroundColor: UIColor.black]))

            // Apply the configuration to the button
            button1.configuration = buttonConfig
            
            // Customize the title font (if needed)
            button1.titleLabel?.font = .boldSystemFont(ofSize: 20)
            
            // Optionally, you can set the border properties directly to the button's image view, like so:
            button1.imageView?.layer.borderColor = UIColor.black.cgColor
            button1.imageView?.layer.borderWidth = 2.0
            
            // Ensure the content is centered
            button1.contentHorizontalAlignment = .center
            button1.contentVerticalAlignment = .center

            button1.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(button1)
            
        } else {
            print("Image 'array' not found in 'Image' folder in asset catalog.")
        }
    }

    // Helper function to resize the image to a target size
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Determine the scale factor to preserve aspect ratio
        let scaleFactor = min(widthRatio, heightRatio)
        let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        
        // Create a new image with the resized size
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage ?? image
    }
    
    func setupbutton2(){
        button2 = UIButton(type: .system)
        
        // Use the custom image from your asset catalog's "Image" folder
        if let image = UIImage(named: "string") {
            
            // Resize the image to a specific size (e.g., 60x60)
            let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 140, height: 140))
            // Add black border to the image
            let imageView = UIImageView(image: resizedImage)
            imageView.layer.borderColor = UIColor.black.cgColor // Set black border color
            imageView.layer.borderWidth = 2.0 // Set border width

            
            
            // Create a button configuration
            var buttonConfig = UIButton.Configuration.filled()

            // Set the resized image and title for the button
            buttonConfig.image = resizedImage
            buttonConfig.title = "String"
            
            // Set the layout of the image and title
            buttonConfig.imagePlacement = .top       // Places the image at the top
            buttonConfig.imagePadding = 10            // Space between image and title
            buttonConfig.titlePadding = 8            // Padding around the title
            
            // Set the button background color to white
            buttonConfig.background = UIBackgroundConfiguration.clear() // Transparent background
            buttonConfig.background.backgroundColor = .clear  // Set the background color to white
            
            // Set the title color using attributedTitle
            buttonConfig.attributedTitle = AttributedString("String", attributes: .init([.foregroundColor: UIColor.black]))

            // Apply the configuration to the button
            button2.configuration = buttonConfig
            
            // Customize the title font (if needed)
            button2.titleLabel?.font = .boldSystemFont(ofSize: 20)
            
          

            // Optionally, you can set the border properties directly to the button's image view, like so:
            button2.imageView?.layer.borderColor = UIColor.black.cgColor
            button2.imageView?.layer.borderWidth = 2.0
            
            // Ensure the content is centered
            button2.contentHorizontalAlignment = .center
            button2.contentVerticalAlignment = .center

            button2.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(button2)
            
        } else {
            print("Image 'array' not found in 'Image' folder in asset catalog.")
        }
    }
    
    func setupLabelRecommendForYouList(){
        labelRecommendForYouList = UILabel()
        labelRecommendForYouList.font = .boldSystemFont(ofSize: 20)
        labelRecommendForYouList.text = "Recommend For You"
        labelRecommendForYouList.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelRecommendForYouList)
        
    }
    
    func setupbutton3(){
        button3 = UIButton(type: .system)
        
        // Use the custom image from your asset catalog's "Image" folder
        if let image = UIImage(named: "sliding_window") {
            
            // Resize the image to a specific size (e.g., 60x60)
            let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 120, height: 120))
            // Add black border to the image
            let imageView = UIImageView(image: resizedImage)
            imageView.layer.borderColor = UIColor.black.cgColor // Set black border color
            imageView.layer.borderWidth = 2.0 // Set border width

            
            // Create a button configuration
            var buttonConfig = UIButton.Configuration.filled()

            // Set the resized image and title for the button
            buttonConfig.image = resizedImage
            buttonConfig.title = "Sliding window"
            
            // Set the layout of the image and title
            buttonConfig.imagePlacement = .top       // Places the image at the top
            buttonConfig.imagePadding = 10            // Space between image and title
            buttonConfig.titlePadding = 8            // Padding around the title
            
            // Set the button background color to white
            buttonConfig.background = UIBackgroundConfiguration.clear() // Transparent background
            buttonConfig.background.backgroundColor = .clear  // Set the background color to white
            
            // Set the title color using attributedTitle
            buttonConfig.attributedTitle = AttributedString("Sliding window", attributes: .init([.foregroundColor: UIColor.black]))

            // Apply the configuration to the button
            button3.configuration = buttonConfig
            
            // Customize the title font (if needed)
            button3.titleLabel?.font = .boldSystemFont(ofSize: 20)
            
        

            // Optionally, you can set the border properties directly to the button's image view, like so:
            button3.imageView?.layer.borderColor = UIColor.black.cgColor
            button3.imageView?.layer.borderWidth = 2.0
            
            // Ensure the content is centered
            button3.contentHorizontalAlignment = .center
            button3.contentVerticalAlignment = .center

            button3.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(button3)
            
        } else {
            print("Image 'array' not found in 'Image' folder in asset catalog.")
        }
    }
    
    func setupbutton4(){
        button4 = UIButton(type: .system)
        
        // Use the custom image from your asset catalog's "Image" folder
        if let image = UIImage(named: "two_pointer") {
            
            // Resize the image to a specific size (e.g., 60x60)
            let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 120, height: 120))
            // Add black border to the image
            let imageView = UIImageView(image: resizedImage)
            imageView.layer.borderColor = UIColor.black.cgColor // Set black border color
            imageView.layer.borderWidth = 2.0 // Set border width

        
            
            // Create a button configuration
            var buttonConfig = UIButton.Configuration.filled()

            // Set the resized image and title for the button
            buttonConfig.image = resizedImage
            buttonConfig.title = "Two pointer"
            
            // Set the layout of the image and title
            buttonConfig.imagePlacement = .top       // Places the image at the top
            buttonConfig.imagePadding = 10            // Space between image and title
            buttonConfig.titlePadding = 8            // Padding around the title
            
            // Set the button background color to white
            buttonConfig.background = UIBackgroundConfiguration.clear() // Transparent background
            buttonConfig.background.backgroundColor = .clear  // Set the background color to white
            
            // Set the title color using attributedTitle
            buttonConfig.attributedTitle = AttributedString("Two pointer", attributes: .init([.foregroundColor: UIColor.black]))

            // Apply the configuration to the button
            button4.configuration = buttonConfig
            
            // Customize the title font (if needed)
            button4.titleLabel?.font = .boldSystemFont(ofSize: 20)
            
    

            // Optionally, you can set the border properties directly to the button's image view, like so:
            button4.imageView?.layer.borderColor = UIColor.black.cgColor
            button4.imageView?.layer.borderWidth = 2.0
            
            // Set fixed image height to ensure same size across buttons
            button4.imageView?.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
            
            // Ensure the content is centered
            button4.contentHorizontalAlignment = .center
            button4.contentVerticalAlignment = .center

            button4.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(button4)
            
        } else {
            print("Image 'array' not found in 'Image' folder in asset catalog.")
        }
    }
    func setupbutton5(){
        button5 = UIButton(type: .system)
        
        // Use the custom image from your asset catalog's "Image" folder
        if let image = UIImage(named: "tree") {
            
            // Resize the image to a specific size (e.g., 60x60)
            let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 120, height: 120))
            // Add black border to the image
            let imageView = UIImageView(image: resizedImage)
            imageView.layer.borderColor = UIColor.black.cgColor // Set black border color
            imageView.layer.borderWidth = 2.0 // Set border width
            
            // Create a button configuration
            var buttonConfig = UIButton.Configuration.filled()

            // Set the resized image and title for the button
            buttonConfig.image = resizedImage
            buttonConfig.title = "Tree           "
            
            // Set the layout of the image and title
            buttonConfig.imagePlacement = .top       // Places the image at the top
            buttonConfig.imagePadding = 10            // Space between image and title
            buttonConfig.titlePadding = 8            // Padding around the title
            
            // Set the button background color to white
            buttonConfig.background = UIBackgroundConfiguration.clear() // Transparent background
            buttonConfig.background.backgroundColor = .clear  // Set the background color to white
            
            // Set the title color using attributedTitle
            buttonConfig.attributedTitle = AttributedString("Tree", attributes: .init([.foregroundColor: UIColor.black]))

            // Apply the configuration to the button
            button5.configuration = buttonConfig
            
            // Customize the title font (if needed)
            button5.titleLabel?.font = .boldSystemFont(ofSize: 20)
            
           

            // Optionally, you can set the border properties directly to the button's image view, like so:
            button5.imageView?.layer.borderColor = UIColor.black.cgColor
            button5.imageView?.layer.borderWidth = 2.0
            
            // Set fixed image height to ensure same size across buttons
            button5.imageView?.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
            
            // Ensure the content is centered
            button5.contentHorizontalAlignment = .center
            button5.contentVerticalAlignment = .center

            button5.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(button5)
            
        } else {
            print("Image 'array' not found in 'Image' folder in asset catalog.")
        }
    }
    
    func setupbutton6(){
        button6 = UIButton(type: .system)
        
        // Use the custom image from your asset catalog's "Image" folder
        if let image = UIImage(named: "graph") {
            
            // Resize the image to a specific size (e.g., 60x60)
            let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 120, height: 120))
            
            // Create a button configuration
            var buttonConfig = UIButton.Configuration.filled()

            // Set the resized image and title for the button
            buttonConfig.image = resizedImage
            buttonConfig.title = "Graph"
            
            // Set the layout of the image and title
            buttonConfig.imagePlacement = .top       // Places the image at the top
            buttonConfig.imagePadding = 10            // Space between image and title
            buttonConfig.titlePadding = 8            // Padding around the title
            
            // Set the button background color to white
            buttonConfig.background = UIBackgroundConfiguration.clear() // Transparent background
            buttonConfig.background.backgroundColor = .clear  // Set the background color to white
            
            // Set the title color using attributedTitle
            buttonConfig.attributedTitle = AttributedString("Graph", attributes: .init([.foregroundColor: UIColor.black]))

            // Apply the configuration to the button
            button6.configuration = buttonConfig
            
            // Customize the title font (if needed)
            button6.titleLabel?.font = .boldSystemFont(ofSize: 20)
            
            // Add black border to the image
            let imageView = UIImageView(image: resizedImage)
            imageView.layer.borderColor = UIColor.black.cgColor // Set black border color
            imageView.layer.borderWidth = 2.0 // Set border width

            // Optionally, you can set the border properties directly to the button's image view, like so:
            button6.imageView?.layer.borderColor = UIColor.black.cgColor
            button6.imageView?.layer.borderWidth = 2.0
            
            // Set fixed image height to ensure same size across buttons
            button6.imageView?.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
            
            // Ensure the content is centered
            button6.contentHorizontalAlignment = .center
            button6.contentVerticalAlignment = .center

            button6.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(button6)
            
        } else {
            print("Image 'array' not found in 'Image' folder in asset catalog.")
        }
    }
    
    func setupbutton7(){
        button7 = UIButton(type: .system)
        
        // Use the custom image from your asset catalog's "Image" folder
        if let image = UIImage(named: "stack") {
            
            // Resize the image to a specific size (e.g., 60x60)
            let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 120, height: 120))
            
            // Create a button configuration
            var buttonConfig = UIButton.Configuration.filled()

            // Set the resized image and title for the button
            buttonConfig.image = resizedImage
            buttonConfig.title = "Stack"
            
            // Set the layout of the image and title
            buttonConfig.imagePlacement = .top       // Places the image at the top
            buttonConfig.imagePadding = 10            // Space between image and title
            buttonConfig.titlePadding = 8            // Padding around the title
            
            // Set the button background color to white
            buttonConfig.background = UIBackgroundConfiguration.clear() // Transparent background
            buttonConfig.background.backgroundColor = .clear  // Set the background color to white
            
            // Set the title color using attributedTitle
            buttonConfig.attributedTitle = AttributedString("Stack", attributes: .init([.foregroundColor: UIColor.black]))

            // Apply the configuration to the button
            button7.configuration = buttonConfig
            
            // Customize the title font (if needed)
            button7.titleLabel?.font = .boldSystemFont(ofSize: 20)
            
            // Add black border to the image
            let imageView = UIImageView(image: resizedImage)
            imageView.layer.borderColor = UIColor.black.cgColor // Set black border color
            imageView.layer.borderWidth = 2.0 // Set border width

            // Optionally, you can set the border properties directly to the button's image view, like so:
            button7.imageView?.layer.borderColor = UIColor.black.cgColor
            button7.imageView?.layer.borderWidth = 2.0
            
            // Ensure the content is centered
            button7.contentHorizontalAlignment = .center
            button7.contentVerticalAlignment = .center

            button4.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(button7)
            
        } else {
            print("Image 'array' not found in 'Image' folder in asset catalog.")
        }
    }
    func setupbutton8(){
        button8 = UIButton(type: .system)
        
        // Use the custom image from your asset catalog's "Image" folder
        if let image = UIImage(named: "queue") {
            
            // Resize the image to a specific size (e.g., 60x60)
            let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 120, height: 120))
            
            // Create a button configuration
            var buttonConfig = UIButton.Configuration.filled()

            // Set the resized image and title for the button
            buttonConfig.image = resizedImage
            buttonConfig.title = "Queue"
            
            // Set the layout of the image and title
            buttonConfig.imagePlacement = .top       // Places the image at the top
            buttonConfig.imagePadding = 10            // Space between image and title
            buttonConfig.titlePadding = 8            // Padding around the title
            
            // Set the button background color to white
            buttonConfig.background = UIBackgroundConfiguration.clear() // Transparent background
            buttonConfig.background.backgroundColor = .clear  // Set the background color to white
            
            // Set the title color using attributedTitle
            buttonConfig.attributedTitle = AttributedString("Queue", attributes: .init([.foregroundColor: UIColor.black]))

            // Apply the configuration to the button
            button8.configuration = buttonConfig
            
            // Customize the title font (if needed)
            button8.titleLabel?.font = .boldSystemFont(ofSize: 20)
            // Add black border to the image
            let imageView = UIImageView(image: resizedImage)
            imageView.layer.borderColor = UIColor.black.cgColor // Set black border color
            imageView.layer.borderWidth = 2.0 // Set border width

            // Optionally, you can set the border properties directly to the button's image view, like so:
            button8.imageView?.layer.borderColor = UIColor.black.cgColor
            button8.imageView?.layer.borderWidth = 2.0
            
            // Ensure the content is centered
            button8.contentHorizontalAlignment = .center
            button8.contentVerticalAlignment = .center

            button8.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(button8)
            
        } else {
            print("Image 'array' not found in 'Image' folder in asset catalog.")
        }
    }
    
    
    func initConstraints(){
        
        // Ensure to add the stackView after its initialization
        let stackView = UIStackView(arrangedSubviews: [button3, button4, button5])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually // Distribute buttons equally within the stack
        stackView.spacing = 16 // Space between buttons
        // Align the stack view items at the top of the stack
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView) // Add stackView to the view
        
        // Ensure to add the stackView after its initialization
        let stackView2 = UIStackView(arrangedSubviews: [button6, button7, button8])
        stackView2.axis = .horizontal
        stackView2.distribution = .fillEqually // Distribute buttons equally within the stack
        stackView2.spacing = 16 // Space between buttons
        // Align the stack view items at the top of the stack
        stackView2.alignment = .top
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView2) // Add stackView to the view
        
        NSLayoutConstraint.activate([
            labelWelcome.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            labelWelcome.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            labelPopularStudyList.topAnchor.constraint(equalTo: self.labelWelcome.bottomAnchor, constant: 16),
            labelPopularStudyList.leadingAnchor.constraint(equalTo: self.labelWelcome.leadingAnchor),
            
            button1.topAnchor.constraint(equalTo: self.labelPopularStudyList.bottomAnchor, constant: 8),
            button1.leadingAnchor.constraint(equalTo: self.labelWelcome.leadingAnchor),
            button1.heightAnchor.constraint(equalToConstant: 200),
            button1.widthAnchor.constraint(equalToConstant: 200),
            
            button2.topAnchor.constraint(equalTo: self.button1.topAnchor),
            button2.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button2.heightAnchor.constraint(equalTo:self.button1.heightAnchor),
            button2.widthAnchor.constraint(equalTo:self.button1.widthAnchor),
            
            //button1.trailingAnchor.constraint(equalTo: self.button2.leadingAnchor, constant: -16),
            
            labelRecommendForYouList.topAnchor.constraint(equalTo: self.button1.bottomAnchor, constant: 4),
            labelRecommendForYouList.leadingAnchor.constraint(equalTo: self.labelWelcome.leadingAnchor),
            
            
            // Stack View Constraints for button3, button4, button5
            stackView.topAnchor.constraint(equalTo: self.labelRecommendForYouList.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 120), // Height for all buttons
            stackView.widthAnchor.constraint(equalToConstant: 80), // Height for all buttons
            
            // Stack View Constraints for button6, button7, button8
            stackView2.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            stackView2.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView2.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView2.heightAnchor.constraint(equalToConstant: 80), // Height for all buttons
            stackView2.widthAnchor.constraint(equalToConstant: 80) // Height for all buttons

        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}



