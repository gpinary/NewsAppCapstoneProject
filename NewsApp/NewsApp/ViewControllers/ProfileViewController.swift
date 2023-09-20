import UIKit
import FirebaseAuth
import FirebaseFirestore

let db = Firestore.firestore()

class ProfileViewController: UIViewController {

    var viewModel: ProfileViewModel!
    

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ProfileViewModel(delegate: self)
        
        if let user = Auth.auth().currentUser {
            // Acccess collection and uid from Firebase database
            let userRef = db.collection("users").document(user.uid)

            // Get user name
            userRef.getDocument { (document, error) in
                if let error = error {
                    print("Firestore Error: \(error.localizedDescription)")
                } else if let document = document, document.exists {
                    if let userName = document.data()?["name"] as? String,let userEmail = document.data()?["email"] as? String {
                        // Display name
                        self.nameLabel.text = userName
                        self.emailLabel.text = userEmail
                    
                    }
                } else {
                    print("The document was not found.")
                }
            }
        }
    }

    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        viewModel.signOut()
    }
}

extension ProfileViewController: ProfileViewModelDelegate {
    func didSignOut(success: Bool, error: Error?) {
        if success {
            navigateToStartScreen()
        } else if let error = error {
            print("Logout Error: \(error.localizedDescription)")
        }
    }

    private func navigateToStartScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let startViewController = storyboard.instantiateViewController(withIdentifier: "StartViewController") as? StartViewController {
            navigationController?.pushViewController(startViewController, animated: true)
        }
    }
}
