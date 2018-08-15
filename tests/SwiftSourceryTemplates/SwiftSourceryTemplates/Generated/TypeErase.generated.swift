// Generated using Sourcery 0.13.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

//swiftlint:disable function_body_length
//swiftlint:disable line_length
//swiftlint:disable vertical_whitespace

import RxSwift

// MARK: - Type erasure for `ErrorPopoverPresentable`

private class _AnyErrorPopoverPresentableBase<EventType>: ErrorPopoverPresentable {
    init() {
        guard type(of: self) != _AnyErrorPopoverPresentableBase.self else {
            fatalError("_AnyErrorPopoverPresentableBase<EventType> instances can not be created; create a subclass instance instead")
        }
    }

    func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType> {
        fatalError("Must override")
    }
}

private final class _AnyErrorPopoverPresentableBox<Concrete: ErrorPopoverPresentable>: _AnyErrorPopoverPresentableBase<Concrete.EventType> {
    private let concrete: Concrete
    typealias EventType = Concrete.EventType

    init(_ concrete: Concrete) {
        self.concrete = concrete
    }

    override func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType> {
        return concrete.show(relativeTo: positioningRect, of: positioningView, preferredEdge: preferredEdge)
    }
}

final class AnyErrorPopoverPresentable<EventType>: ErrorPopoverPresentable {
    private let box: _AnyErrorPopoverPresentableBase<EventType>

    init<Concrete: ErrorPopoverPresentable>(_ concrete: Concrete) where Concrete.EventType == EventType {
        self.box = _AnyErrorPopoverPresentableBox(concrete)
    }

    func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType> {
        return box.show(relativeTo: positioningRect, of: positioningView, preferredEdge: preferredEdge)
    }
}

// MARK: - Type erasure for `ErrorPopoverPresentableRawRepresentable`

private class _AnyErrorPopoverPresentableRawRepresentableBase<EventType>: ErrorPopoverPresentableRawRepresentable where EventType: RawRepresentable, EventType: Hashable {
    init() {
        guard type(of: self) != _AnyErrorPopoverPresentableRawRepresentableBase.self else {
            fatalError("_AnyErrorPopoverPresentableRawRepresentableBase<EventType> instances can not be created; create a subclass instance instead")
        }
    }

    func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType> {
        fatalError("Must override")
    }
}

private final class _AnyErrorPopoverPresentableRawRepresentableBox<Concrete: ErrorPopoverPresentableRawRepresentable>: _AnyErrorPopoverPresentableRawRepresentableBase<Concrete.EventType> {
    private let concrete: Concrete
    typealias EventType = Concrete.EventType

    init(_ concrete: Concrete) {
        self.concrete = concrete
    }

    override func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType> {
        return concrete.show(relativeTo: positioningRect, of: positioningView, preferredEdge: preferredEdge)
    }
}

final class AnyErrorPopoverPresentableRawRepresentable<EventType>: ErrorPopoverPresentableRawRepresentable where EventType: RawRepresentable, EventType: Hashable {
    private let box: _AnyErrorPopoverPresentableRawRepresentableBase<EventType>

    init<Concrete: ErrorPopoverPresentableRawRepresentable>(_ concrete: Concrete) where Concrete.EventType == EventType {
        self.box = _AnyErrorPopoverPresentableRawRepresentableBox(concrete)
    }

    func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType> {
        return box.show(relativeTo: positioningRect, of: positioningView, preferredEdge: preferredEdge)
    }
}
