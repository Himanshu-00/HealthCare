//
//  SwiftUIView.swift
//  Healthcare
//
//  Created by Himanshu Vinchurkar on 30/04/24.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Spacer()
            
            HStack(alignment: .center, spacing: 0) {
                Text("Welcome")
                    .font(.system(size: 30, weight: .bold, design: .default))
                    .foregroundColor(Color.blue)
                    .padding(.horizontal, 5)
                Text("To")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(Color.pink)
                    .padding(.horizontal, 20)
                Text("HealthCare")
                    .font(.system(size: 30, weight: .bold, design: .default))
                    .foregroundColor(Color.blue)
                    .padding(.horizontal, 5)
            }
            .padding(.bottom, 50)
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            NavigationLink(destination: RegisterView()) {
                Text("Get Started")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.pink.opacity(0.6)]), startPoint: .leading, endPoint: .trailing))
                    )
                    .padding(.horizontal)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.edgesIgnoringSafeArea(.all)) // Background color
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
