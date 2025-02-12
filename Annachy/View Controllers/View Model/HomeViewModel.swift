//
//  HomeViewModel.swift
//  Annachy
//
//  Created by Prabakaran Muthusamy on 12/02/25.
//

import Foundation
import Combine

class ProductViewModel: ObservableObject {
    
    @Published var products: [ProductModel] = []
    @Published var searchText: String = ""
    @Published var filteredProducts: [ProductModel] = []
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchProducts()
        
        $searchText
            .combineLatest($products)
            .map { (text, products) -> [ProductModel] in
                guard !text.isEmpty else { return products }
                return products.filter { $0.title.lowercased().contains(text.lowercased()) }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$filteredProducts)
    }
    
    func fetchProducts() {
        guard let url = URL(string: "https://fakestoreapi.com/products") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [ProductModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch products: \(error.localizedDescription)"
                    self?.products = []
                    self?.filteredProducts = []
                case .finished:
                    self?.errorMessage = nil
                }
            }, receiveValue: { [weak self] products in
                self?.products = products
                self?.filteredProducts = products
            })
            .store(in: &cancellables)
    }
}
