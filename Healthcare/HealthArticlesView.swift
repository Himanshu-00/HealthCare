//
//  HealthArticlesView.swift
//  Healthcare
//
//  Created by Himanshu Vinchurkar on 02/05/24.
//

import Foundation
import SwiftUI

struct healthArticlesView: View {
    let healthDetails = [
        HealthArticle(title: "Walking Daily", imageName: "health1"),
        HealthArticle(title: "Home care of COVID-19", imageName: "health2"),
        HealthArticle(title: "Stop Smoking", imageName: "health3"),
        HealthArticle(title: "Menstrual Cramps", imageName: "health4"),
        HealthArticle(title: "Healthy Gut", imageName: "health5")
    ]
    
    var body: some View {
            List(healthDetails) { article in
                NavigationLink(destination: HealthArticleDetailsView(article: article)) {
                    HealthArticleRow(article: article)
                }
            }
            .navigationTitle("Health Articles")
        
    }
}

struct HealthArticle: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
}

struct HealthArticleRow: View {
    let article: HealthArticle
    
    var body: some View {
        HStack {
            Image(article.imageName)
                .resizable()
                .frame(width: 50, height: 50)
            Text(article.title)
                .font(.headline)
        }
    }
}

struct HealthArticleDetailsView: View {
    let article: HealthArticle
    
    var body: some View {
        VStack {
            Image(article.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            Text(article.title)
                .font(.title)
                .padding()
            Spacer()
        }
        .navigationTitle(article.title)
    }
}

struct healthArticlesView_Previews: PreviewProvider {
    static var previews: some View {
        healthArticlesView()
    }
}

