//
//  SignInWApple.swift
//  schnupfbible
//
//  Created by Jesse Born on 24.01.23.
//

import CryptoKit
import Foundation
import FirebaseAuth
import AuthenticationServices

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

private func sha256(_ input: String) -> String {
  let inputData = Data(input.utf8)
  let hashedData = SHA256.hash(data: inputData)
  let hashString = hashedData.compactMap {
    String(format: "%02x", $0)
  }.joined()

  return hashString
}



// Unhashed nonce.
fileprivate var currentNonce: String?

func startSignInWithAppleFlow() {
  let nonce = randomNonceString()
  currentNonce = nonce
  let appleIDProvider = ASAuthorizationAppleIDProvider()
  let request = appleIDProvider.createRequest()
  request.requestedScopes = [.fullName, .email]
  request.nonce = sha256(nonce)

  let authorizationController = ASAuthorizationController(authorizationRequests: [request])
  authorizationController.delegate = self
  authorizationController.presentationContextProvider = self
  authorizationController.performRequests()
}
