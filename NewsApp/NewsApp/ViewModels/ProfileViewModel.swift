import FirebaseAuth

protocol ProfileViewModelDelegate: AnyObject {
    func didSignOut(success: Bool, error: Error?)
}

class ProfileViewModel {
    weak var delegate: ProfileViewModelDelegate?

    init(delegate: ProfileViewModelDelegate) {
        self.delegate = delegate
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            print("Logout Success")
            delegate?.didSignOut(success: true, error: nil)
        } catch let signOutError as NSError {
            print("Logout Error: \(signOutError.localizedDescription)")
            delegate?.didSignOut(success: false, error: signOutError)
        }
    }
}
