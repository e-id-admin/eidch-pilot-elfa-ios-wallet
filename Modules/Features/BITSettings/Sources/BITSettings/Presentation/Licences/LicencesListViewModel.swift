import BITCore
import Combine
import Factory
import Foundation

public class LicencesListViewModel: StateMachine<LicencesListViewModel.State, LicencesListViewModel.Event> {

  // MARK: Lifecycle

  public init(
    _ initialState: State = .loading,
    fetchPackagesUseCase: FetchPackagesUseCaseProtocol = Container.shared.fetchPackagesUseCase())
  {
    self.fetchPackagesUseCase = fetchPackagesUseCase
    super.init(initialState)
  }

  // MARK: Public

  public enum State: Equatable {
    case loading
    case results
    case empty
    case error
  }

  public enum Event {
    case fetch
    case setPackages(_ packages: [PackageDependency])
    case setError(_ errror: Error)
    case selectPackage(_ package: PackageDependency)
  }

  public override func reducer(_ state: inout State, _ event: Event) -> AnyPublisher<Event, Never>? {
    switch (state, event) {
    case (_, .fetch):
      return AnyPublisher.run {
        try self.fetchPackagesUseCase.execute()
      } onSuccess: { packages in
        .setPackages(packages)
      } onError: { error in
        .setError(error)
      }
    case (.loading, .setPackages(let packages)):
      self.packages = packages
      selectedPackage = packages.first
      state = self.packages.isEmpty ? .empty : .results
    case (_, .setError(let error)):
      stateError = error
      state = .error
    case (.error, _):
      packages = []

    case (.results, .selectPackage(let package)):
      selectedPackage = package
      isPackageDetailPresented = true

    default:
      return super.reducer(&state, event)
    }

    return nil
  }

  // MARK: Internal

  @Published var packages: [PackageDependency] = []
  @Published var selectedPackage: PackageDependency?
  @Published var isPackageDetailPresented: Bool = false

  // MARK: Private

  private let fetchPackagesUseCase: FetchPackagesUseCaseProtocol

}
