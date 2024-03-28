//
//  RegisterViewModel.swift
//  App
//
//  Created by Thanh Hien on 11/10/2023.
//

import Foundation
import Moya

class RegisterViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var gender = ""
    @Published var image = ""
    @Published var address = ""
    @Published var phone = ""
    @Published var isRegister = false
    @Published var errorMessage = ""
    
    func Register(completed: @escaping (Bool) -> Void) {
        guard invalid() else {
            return
        }
        let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        let provider = MoyaProvider<MyService>(plugins: [plugin])
        provider.request(.register(name: name, email: email, password: password, gender: gender, image: image,address: address, phone: phone)) { result in
            switch result {
            case let .success(moyaResponse):
                print("token la token token")
                do {
                    let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                    let token = try filteredResponse.map(TokenResponse.self)
                    print("token la token token")
                    print("token: \(token)")
                    print(self.name)
                    UserDefaults.standard.set(token.token, forKey: Constanst.tokenKey)
                }
                catch {}
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    self.isRegister = true
                    completed(self.isRegister)
                } else {
                    self.errorMessage = "Email already exists."
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^\\d{10}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }
    
    private func invalid() -> Bool {
        errorMessage = ""
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty, !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty, !address.trimmingCharacters(in: .whitespaces).isEmpty, !phone.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill all fileds"
            return false
        }
        guard isValidEmail(email: email) else {
            errorMessage = " Please enter valid email "
            return false
        }
        guard isValidPhone(phone: phone) else {
            errorMessage = "Please enter a valid 10-digit phone number"
            return false
        }
        return true
    }
}
