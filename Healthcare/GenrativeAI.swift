//
//  GenrativeAI.swift
//  Healthcare
//
//  Created by Himanshu Vinchurkar on 01/09/24.
//

import SwiftUI
import GoogleGenerativeAI

struct GenrativeAI: View {
    
    
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    
    @State var  isLoading = false
    @State var  response:LocalizedStringKey =  "Hey, How can i help you?"
    @State var  userPrompt = ""
    
    var body: some View {

        VStack {
            Text("Accura.")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding(.top, 40)
        
        ZStack{
            ScrollView{
                Text(response)
                     .font(.title2)
            }
            
            
            if isLoading {
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.blue))
                    .scaleEffect(4)
            }
            
            }
            
            TextField("Ask Anything?", text: $userPrompt, axis: .vertical)
                .lineLimit(5)
                .font(.title)
                .padding()
                .background(Color.indigo.opacity(0.2), in: Capsule())
                .disableAutocorrection(true)
                .onSubmit {
                generateResponse()
            }
            
        }
        .padding()
       
        
  
    }
    
    func generateResponse() {
        isLoading = true
        response = ""
        
        
        Task {
            do {
                let result = try await model.generateContent(userPrompt)
                isLoading = false
                response = LocalizedStringKey(result.text ?? "No Response Found")
                userPrompt = ""
            }
            catch {
                response = "Something went wrong\(error.localizedDescription)"
            }
        }
        
    }
}

struct GenrativeAI_Preview: PreviewProvider {
    static var previews: some View{
        GenrativeAI()
    }
}
