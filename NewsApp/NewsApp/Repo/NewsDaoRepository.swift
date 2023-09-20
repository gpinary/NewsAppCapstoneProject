//
//  NewsDaoRepository.swift
//  NewsApp
//
//  Created by Gökçe Pınar Yıldız on 12.09.2023.
//

import Foundation
import RxSwift

class NewsDaoRepository {
    var newsList = BehaviorSubject<[Article]>(value: [])
    let disposeBag = DisposeBag()
    private let networkManager = NetworkManager()
    var error = PublishSubject<String?>()
    
    
    
    func fetchNewsData() {
        let apiKey = "4872c9cff16e456bb06734e84333b320"
        let urlString = "https://newsapi.org/v2/top-headlines?country=us&category=general&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Error fetch data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Empty data")
                return
            }
            
            do {
                let news = try JSONDecoder().decode(NewsResponse.self, from: data)
                self?.newsList.onNext(news.articles ?? [])
            } catch {
                print("JSON decoder error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func loadNews() {
        newsList
            .subscribe(onNext: { news in
                print("News came: \(news)")
            })
            .disposed(by: disposeBag)
        fetchNewsData()
        
    }
    
    func performSearch(query: String?) {
        networkManager.fetchNewsData(query: query)
            .subscribe(
                onNext: { [weak self] news in
                    self?.newsList.onNext(news)
                },
                onError: { [weak self] error in
                    self?.error.onNext(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
}
