import Combine
import Foundation
import OSLog

typealias Reducer<State, Event> = (inout State, Event) -> AnyPublisher<Event, Never>?

// MARK: - StateMachine

@MainActor
open class StateMachine<State, Event>: NSObject, ObservableObject where State: Equatable {

  // MARK: Lifecycle

  public init(_ initialState: State) {
    state = initialState
    bag = .init()
  }

  // MARK: Open

  open func reducer(_ state: inout State, _ event: Event) -> AnyPublisher<Event, Never>? {
    fatalError("Override handleEvent(_:) before continuing.")
  }

  open func send(event: Event) async {
    guard let effect = reducer(&state, event) else { return }

    for await event in effect.values {
      await send(event: event)
    }
  }

  open func leaveState(_ state: State) {}

  open func enterState(_ state: State) {}

  // MARK: Public

  @Published public var stateError: Error?
  public var bag: Set<AnyCancellable>

  @Published public private(set) var state: State {
    willSet {
      leaveState(state)
    }

    didSet {
      enterState(state)
    }
  }
}
