//
//  PaginationInfo.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import Foundation

// MARK: - Pagination Info
struct PaginationInfo {
    let currentPage: Int
    let pageSize: Int
    let totalItems: Int
    let hasMorePages: Bool
    
    var totalPages: Int {
        Int(ceil(Double(totalItems) / Double(pageSize)))
    }
    
    var isFirstPage: Bool {
        currentPage == 0
    }
    
    var isLastPage: Bool {
        !hasMorePages
    }
    
    init(currentPage: Int, pageSize: Int, totalItems: Int, hasMorePages: Bool) {
        self.currentPage = currentPage
        self.pageSize = pageSize
        self.totalItems = totalItems
        self.hasMorePages = hasMorePages
    }
}
