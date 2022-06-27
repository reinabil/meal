//
//  SignInViewController.swift
//  Meal
//
//  Created by Anselmus Pavel Adriska on 18/06/22.
//

import UIKit
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseFirestore

class SignInViewController: UIViewController {

    let defaults = UserDefaults.standard
    var db: Firestore!
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    
    override func viewDidLoad() {
        
            
        
        navigationItem.hidesBackButton = true  
        super.viewDidLoad()

        // [START setup]
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        // Do any additional setup after loading the view.
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    //Continue with Apple button pressed
    @IBAction func buttonPressed(_ sender: UIButton) {
        print("Sign in with apple")
        
        //MARK: - remove comment
        let request  = createAppleIDRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])

        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self

        authorizationController.performRequests()
        
        self.performSegue(withIdentifier: "goToJoinCreateFamily", sender: self)
        
    }
    
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        return request
    }
 
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    fileprivate var currentNonce: String?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "goToJoinCreateFamily" {
              guard segue.destination is JoinCreateFamilyViewController else { return }
          }
      }
}

extension SignInViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
                                      
            guard let nonce = currentNonce else {
                fatalError("Invalid state : A login callback was received, but no login was sent")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data : \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString , rawNonce: nonce)
            Auth.auth().signIn(with: credential) {
                (authDataResult, error) in
                
                // Mak a request to set user's display name on Firebase
                let changeRequest = authDataResult?.user.createProfileChangeRequest()
                changeRequest?.displayName = appleIDCredential.fullName?.givenName ?? ""
                if error == nil {
                    UserDefaults.standard.set(true, forKey: "usersignedin")
                    UserDefaults.standard.synchronize()
                    print(authDataResult?.user.email ?? "")
                }
                
                changeRequest?.commitChanges(completion: { (error) in

                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        
                        if Auth.auth().currentUser?.displayName != nil {
                            self.db.collection("user").document(Auth.auth().currentUser!.uid).setData([
                                "family_id": "",
                                "username": "\(Auth.auth().currentUser!.displayName!)",
                                "email": "\(Auth.auth().currentUser!.email ?? "" )"
                            ]) { err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                } else {
                                    print("Document successfully written!")
                                    UserDefaults.standard.set(Auth.auth().currentUser?.displayName, forKey: "username")
                                }
                            }
                        }
                        
                        self.performSegue(withIdentifier: "goToJoinCreateFamily", sender: self)
                    }
                })
                
//                if let user = authDataResult?.user {
//                    print("Nice! you logged in as \(user.uid) with \(user.email)" ?? "unknwon")
//                    self.performSegue(withIdentifier: "goToJoinFamilyPage", sender: self)
//                }
                
                
            }
            
        }
    }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
