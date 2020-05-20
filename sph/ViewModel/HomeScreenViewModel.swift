//
//  HomeScreenViewModel.swift
//  sph
//
//  Created by Sujewan Vijayakumar on 5/18/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import Foundation
import Alamofire

protocol HomeScreenViewModelInput {
    func viewDidLoad()
}

enum HomeScreenViewModelLoading {
    case fetching
}

protocol HomeScreenViewModelOutput {
    var items: Observable<[DataUsageItemViewModel]> { get }
    var loadingType: Observable<HomeScreenViewModelLoading?> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
}

protocol HomeScreenViewModel: HomeScreenViewModelInput, HomeScreenViewModelOutput {}

final class DefaultHomeScreenViewModel: HomeScreenViewModel {
    private let dataUsageRepo: DataUsageRepository
    private var recordLoadTask: Cancellable? { willSet { recordLoadTask?.cancel() } }

    // MARK: - OUTPUT
    let items: Observable<[DataUsageItemViewModel]> = Observable([])
    let loadingType: Observable<HomeScreenViewModelLoading?> = Observable(.none)
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }
    let emptyDataTitle = NSLocalizedString("Search results", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")

    init(dataUsageUseCase: DataUsageRepository) {
        self.dataUsageRepo = dataUsageUseCase
    }

    private func reset() {
        items.value.removeAll()
    }

    private func load(loadingType: HomeScreenViewModelLoading) {
        self.loadingType.value = loadingType
    
        recordLoadTask = dataUsageRepo.execute(
           cached: appendRecords,
           completion: { result in
               switch result {
                case .success(let records):
                    self.appendRecords(records)
                    self.loadingType.value = .none
                case .failure(let error):
                    self.handle(error: error)
                    self.loadingType.value = .none
               }
       })
    }
    
    private func appendRecords(_ records: [YearlyRecord]) {
        self.items.value = records.map(DataUsageItemViewModel.init)
    }
        
    private func handle(error: Error) {
        self.error.value = InternetConnectionManager.isConnectedToNetwork() ?
            NSLocalizedString("Server Failed. Please Try Again", comment: "")
            : NSLocalizedString("No Internet Connection", comment: "")
    }

    private func update() {
        reset()
        load(loadingType: .fetching)
    }
}

extension DefaultHomeScreenViewModel {
    func viewDidLoad() {
        load(loadingType: .fetching)
    }
}
