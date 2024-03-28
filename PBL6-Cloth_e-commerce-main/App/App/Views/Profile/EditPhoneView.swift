//
//  EditPhoneView.swift
//  App
//
//  Created by Thanh Hien on 28/10/2023.
//

import SwiftUI

struct EditPhoneView: View {
    @ObservedObject var viewModel = ProfileViewModel()
    @Binding var path: NavigationPath
    var body: some View {
        ZStack {
            Color("F9F9F9")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer().frame(height: 15)
                HStack {
                    Button(action: {
                        path.removeLast()
                    }) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .foregroundColor(.black)
                            .frame(width: 18, height: 18)
                            .padding(.leading, 25)
                    }
                    Text("Sửa số điện thoại")
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .padding(.leading, 15)
                    Spacer()
                    Button(action: {
                        viewModel.updateProfile()
                        viewModel.showProfile()
                        path.removeLast()
                    }) {
                        Text("Lưu")
                            .font(.system(size: 17))
                            .foregroundColor(.gray)
                            .fontWeight(.medium)
                            .padding(.trailing, 20)
                    }
                }
                Spacer().frame(height: 18)
                Divider().background(Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 0).stroke(Color.gray.opacity(0.1), lineWidth: 1)
                    ).shadow(radius: 2)
                HStack() {
                    TextField("", text: $viewModel.phone)
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                        .padding(.leading, 15)
                    Spacer()
                    if !viewModel.phone.isEmpty {
                        Button(action: {
                            viewModel.phone = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 14)
                        }
                    }
                }
                .padding()
                .background(.white)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct EditPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        EditPhoneView(path: .constant(NavigationPath()))
    }
}
