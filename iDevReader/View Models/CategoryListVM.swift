//
//  CategoryListVM.swift
//  iDevReader
//
//  Created by Nilson Nascimento on 4/18/18.
//  Copyright © 2018 Nilson Nascimento. All rights reserved.
//

import Foundation

protocol CategoryListVMDelegate: class {
    func sender(_ sender: CategoryListVM, didSelect category: Category)
}

class CategoryListVM {
    
    func loadCategories(completion: @escaping () -> ()) {
        URLSession.shared.dataTask(with: URL(string: "https://raw.githubusercontent.com/daveverwer/iOSDevDirectory/master/content.json")!) { data, response, error in
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [[String: AnyObject]],
                let english = json.first(where: { item in
                    guard let language = item["language"] as? String else { return false }
                    return language == "en"
                }) else {
                    completion()
                    return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.categories = (try? JSONDecoder().decode([Category].self, from: JSONSerialization.data(withJSONObject: english["categories"] as Any, options: []))) ?? []
                completion()
            }
            }.resume()
    }
    
    func selectItem(at index: Int) {
        let selected = categories[index]
        selectedCategory = selected
    }
    
    // Outputs
    private(set) var categories: [Category] = []
    private(set) var selectedCategory: Category? {
        didSet { delegate?.sender(self, didSelect: selectedCategory!) }
    }
    
    weak var delegate: CategoryListVMDelegate?
    
}
