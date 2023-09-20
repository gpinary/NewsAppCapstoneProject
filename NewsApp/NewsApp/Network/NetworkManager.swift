//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Gökçe Pınar Yıldız on 9.09.2023.
//

import Foundation
import RxSwift

final class NetworkManager {
    private let disposeBag = DisposeBag()


      func fetchNewsData(query: String?) -> Observable<[Article]> {
          let apiKey = "4872c9cff16e456bb06734e84333b320"
          var urlString = "https://newsapi.org/v2/top-headlines?country=us&category=general&apiKey=\(apiKey)"


          if let query = query, !query.isEmpty {
              urlString = "https://newsapi.org/v2/everything?q=\(query)&apiKey=\(apiKey)"
          }

          guard let url = URL(string: urlString) else {
              return Observable.error(NSError(domain: "Invalid URL", code: 0, userInfo: nil))
          }

          return Observable.create { observer in
              let task = URLSession.shared.dataTask(with: url) { data, _, error in
                  if let error = error {
                      observer.onError(error)
                      return
                  }

                  guard let data = data else {
                      observer.onError(NSError(domain: "Empty Data", code: 1, userInfo: nil))
                      return
                  }

                  do {
                      let articles = try JSONDecoder().decode(NewsResponse.self, from: data)
                      observer.onNext(articles.articles!)
                      observer.onCompleted()
                  } catch {
                      observer.onError(error)
                  }
              }

              task.resume()

              return Disposables.create {
                  task.cancel()
              }
          }
      }
}

