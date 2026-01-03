import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    // Storyboard outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkExistingSession()
        FirebaseManager.shared.logScreenView("Login")
        
        // Demo credentials for assessment
        if let emailField = emailField {
            emailField.text = "admin@replate.com"
        } else {
            emailTextField?.text = "admin@replate.com"
        }
        
        if let passwordField = passwordField {
            passwordField.text = "demo123"
        } else {
            passwordTextField?.text = "demo123"
        }
        
        // Hide error label initially
        errorLabel?.isHidden = true
    }
    
    private func checkExistingSession() {
        if UserSessionManager.shared.isLoggedIn {
            navigateToMainApp()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Title styling
        titleLabel.text = "Welcome to RePlate"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .primaryGreen
        titleLabel.textAlignment = .center
        
        // Subtitle styling
        subtitleLabel.text = "Reducing food waste, one meal at a time"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textColor = .gray
        subtitleLabel.textAlignment = .center
        
        // Email field styling
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.font = UIFont.systemFont(ofSize: 16)
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        
        // Password field styling
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.font = UIFont.systemFont(ofSize: 16)
        passwordTextField.isSecureTextEntry = true
        
        // Login button styling
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .primaryGreen
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        loginButton.layer.cornerRadius = 8
        
        // Sign up button styling
        signUpButton.setTitle("Don't have an account? Sign Up", for: .normal)
        signUpButton.setTitleColor(.primaryGreen, for: .normal)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        signUpButton.backgroundColor = .clear
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let email = emailField?.text ?? emailTextField?.text ?? ""
        let password = passwordField?.text ?? passwordTextField?.text ?? ""
        
        guard !email.isEmpty, !password.isEmpty else {
            showAlert(message: "Please enter both email and password")
            return
        }
        
        let button = signInButton ?? loginButton
        button?.isEnabled = false
        
        // Demo login for assessment
        if email == "admin@replate.com" && password == "demo123" {
            let demoUser = User(
                id: "demo_admin",
                name: "Demo Admin",
                email: email,
                role: .admin,
                isActive: true,
                joinDate: Date(),
                profileImageURL: nil
            )
            
            UserSessionManager.shared.login(user: demoUser)
            navigateToMainApp()
        } else {
            // Firebase authentication
            FirebaseManager.shared.signIn(email: email, password: password) { [weak self] result in
                DispatchQueue.main.async {
                    button?.isEnabled = true
                    
                    switch result {
                    case .success(let user):
                        UserSessionManager.shared.login(user: user)
                        self?.navigateToMainApp()
                    case .failure(let error):
                        self?.showAlert(message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func navigateToMainApp() {
        let storyboard = UIStoryboard(name: "Admin", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "AdminTabBarController")
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true)
    }
    
    @IBAction func signInTapped(_ sender: UIButton) {
        loginButtonTapped(sender)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "RePlate", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}