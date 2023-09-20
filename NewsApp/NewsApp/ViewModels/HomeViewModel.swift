//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Gökçe Pınar Yıldız on 9.09.2023.
//

import Foundation
import RxSwift

class HomeViewModel {

        var nrepo = NewsDaoRepository()
        var newsList = BehaviorSubject<[Article]>(value: [])
        var disposeBag = DisposeBag()

        init() {
            newsList = nrepo.newsList
        }

        func search(searchKey:String){
            nrepo.performSearch(query: searchKey)
        }

        func loadNews(){
            nrepo.loadNews()
        }
    
}
