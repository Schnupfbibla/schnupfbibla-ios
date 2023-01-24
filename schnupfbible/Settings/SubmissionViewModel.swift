//
//  SubmissionViewModel.swift
//  schnupfbible
//
//  Created by Jesse Born on 20.01.23.
//

import Foundation
import Combine

final class SubmissionViewModel: ObservableObject {
    
  // Input values from View
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var titel: String = ""
    @Published var bodytext: String = ""
  
  // Output subscribers
  @Published var formIsValid = false
  
  private var publishers = Set<AnyCancellable>()
  
  init() {
    isSignupFormValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.formIsValid, on: self)
      .store(in: &publishers)
  }
    
    func clear() {
        self.name = ""
        self.email = ""
        self.bodytext = ""
        self.titel = ""
    }
}

// MARK: - Setup validations
private extension SubmissionViewModel {
    
  var isUserNameValidPublisher: AnyPublisher<Bool, Never> {
    $name
      .map { name in
          return name.count >= 3
      }
      .eraseToAnyPublisher()
  }
  
  var isUserEmailValidPublisher: AnyPublisher<Bool, Never> {
    $email
      .map { email in
          let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
          return emailPredicate.evaluate(with: email)
      }
      .eraseToAnyPublisher()
  }
    var isBodyTextValid: AnyPublisher<Bool, Never> {
      $bodytext
        .map { bt in
            return bt.count >= 15
            
        }
        .eraseToAnyPublisher()
    }
    var isTitleValid: AnyPublisher<Bool, Never> {
      $titel
        .map { tl in
            return tl.count >= 15
            
        }
        .eraseToAnyPublisher()
    }
    
  var isSignupFormValidPublisher: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest4(
      isUserNameValidPublisher,
      isUserEmailValidPublisher,
        isBodyTextValid, isTitleValid)
      .map { isNameValid, isEmailValid, isTitleValid, isBTvalid in
          // print(isNameValid, isEmailValid, isTitleValid, isBTvalid)
          return isNameValid && isEmailValid && isTitleValid && isBTvalid
      }
      .eraseToAnyPublisher()
  }
}
