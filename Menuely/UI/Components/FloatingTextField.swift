//
//  FloatingTextField.swift
//  Menuely
//
//  Created by Benjamin Mecanović on 09.07.2021..
//

import SwiftUI

struct FloatingTextField: View {
    @Binding private var text: String
    @Binding private var isValid: Bool
    
    @StateObject private var viewModel = ViewModel()
    @State private var separatorColor: Color = Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1))
    @State private var placeholderColor: Color
    @State private var placeholderOffset: CGFloat
    @State private var placeholderScale: CGFloat
    @State private var titleWithMessage: String
    
    private let title: String
    private let type: FieldType
    private let validation: ValidationType
    
    init(text: Binding<String>, title: String, type: FieldType = .regular, validation: ValidationType, isValid: Binding<Bool>) {
        self._text = text
        self._isValid = isValid
        self.title = title
        self.titleWithMessage = title
        self.type = type
        self.validation = validation
        if !text.wrappedValue.isEmpty {
            placeholderColor = Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1))
            placeholderOffset = -25
            placeholderScale = 0.75
        } else {
            placeholderColor = Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1))
            placeholderOffset = 0
            placeholderScale = 1
        }
    }
    
    var body: some View {
       ZStack(alignment: .leading) {
        Text(titleWithMessage)
            .font(.body)
            .foregroundColor(placeholderColor)
            .offset(y: placeholderOffset)
            .scaleEffect(placeholderScale, anchor: .leading)
        
        TextField("", text: $text) { isActive in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                if !isActive {
                    separatorColor = Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1))
                } else {
                    viewModel.validate(text)
                    separatorColor = viewModel.isValid ? Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1)) : Color(#colorLiteral(red: 0.9781840444, green: 0.2009097934, blue: 0.2820017338, alpha: 1))
                }
            }
        }
        .frame(maxHeight: .infinity)
        .font(.body)
        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
        .onChange(of: text, perform: { value in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                viewModel.validate(text)
                placeholderColor = value.isEmpty ? Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1)) : Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1))
                if viewModel.isValid {
                    placeholderColor = Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1))
                    separatorColor = Color(#colorLiteral(red: 0.2075126171, green: 0.7053237557, blue: 0.3391282558, alpha: 1))
                    titleWithMessage = title
                    $isValid.wrappedValue = true
                } else {
                    placeholderColor = Color(#colorLiteral(red: 0.9781840444, green: 0.2009097934, blue: 0.2820017338, alpha: 1))
                    separatorColor = Color(#colorLiteral(red: 0.9781840444, green: 0.2009097934, blue: 0.2820017338, alpha: 1))
                    if let errorMessage = viewModel.errorMessage {
                        titleWithMessage = title + " | " + errorMessage
                    }
                    $isValid.wrappedValue = false
                }
                placeholderOffset = value.isEmpty ? 0 : -25
                placeholderScale = value.isEmpty ? 1 : 0.75
            }
        })
        
        if type == .secure {
            let width = text.widthOfString(usingFont: UIFont.preferredFont(forTextStyle: .body))
            RoundedRectangle(cornerRadius: 2)
                .frame(width: width < 0 ? 0 : width, height: 19)
                .foregroundColor(Color(#colorLiteral(red: 0.7803257108, green: 0.7804361582, blue: 0.7802907825, alpha: 1)))
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: text)
        }
        
        Divider()
            .frame(height: 1)
            .background(separatorColor)
            .offset(x: 0, y: 20)
       }
       .padding(.top, 15)
       .onAppear {
        viewModel.validation = validation
       }
   }
}

extension FloatingTextField {
    class ViewModel: ObservableObject {
        @Published var isValid: Bool = false
        @Published var errorMessage: String?
        
        var validation: ValidationType = .none
        
        func validate(_ input: String) {
            switch validation {
            case .none: break
            case .email: validateEmail(with: input)
            case .notEmpty: validateNotEmpty(with: input)
            case .lenght: validateLenght(with: input)
            case .int: validateInt(with: input)
            case .float: validateFloat(with: input)
            }
        }
        
        private func validateEmail(with input: String) {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if emailPred.evaluate(with: input) {
                isValid = true
                errorMessage = nil
            } else {
                isValid = false
                errorMessage = validation.errorMessage
            }
        }
        
        private func validateNotEmpty(with input: String) {
            if !input.isEmpty {
                isValid = true
                errorMessage = nil
            } else {
                isValid = false
                errorMessage = validation.errorMessage
            }
        }
        
        private func validateLenght(with input: String) {
            guard case ValidationType.lenght(let minimumLenght) = validation else { return }
            if input.count >= minimumLenght {
                isValid = true
                errorMessage = nil
            } else {
                isValid = false
                errorMessage = validation.errorMessage
            }
        }
        
        private func validateInt(with input: String) {
            if Int(input) != nil {
                isValid = true
                errorMessage = nil
            } else {
                isValid = false
                errorMessage = validation.errorMessage
            }
        }
        
        private func validateFloat(with input: String) {
            if Float(input) != nil {
                isValid = true
                errorMessage = nil
            } else {
                isValid = false
                errorMessage = validation.errorMessage
            }
        }
    }
}

extension FloatingTextField {
    enum FieldType {
        case regular
        case secure
    }
    
    enum ValidationType {
        case none
        case email
        case notEmpty
        case lenght(Int)
        case int
        case float
        
        var errorMessage: String? {
            switch self {
            case .none: return nil
            case .notEmpty: return "Can not be empty"
            case .email: return "Invalid email"
            case .lenght(let minimumLenght): return "Minimum \(minimumLenght) characters required"
            case .int: return "Needs to be an integer"
            case .float: return "Needs to be a decimal number"
            }
        }
    }
}

struct FloatingTextField_Previews: PreviewProvider {
    static var previews: some View {
        FloatingTextField(text: .constant("Text"), title: "Title", validation: .email, isValid: .constant(true))
    }
}
