import UIKit
import RxSwift

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    test()
  }
  
  func test() {
    let observable: Observable<Int> = Observable<Int>.just(4)
    let observable2 = Observable.of(3, 4, 2)
    let observable3 = Observable.of([3, 4, 2])
    let observable4 = Observable.from([3, 5, 6])
    
    observable4.subscribe { event in
      print(event)
    }
    
    observable2.subscribe { event in
      if let element = event.element {
        print(element)
      }
    }
    
    observable3.subscribe(onNext: {element in
      print(element)
    })
    
    let emptyObserver = Observable<Void>.empty()
    emptyObserver.subscribe(onNext: {element in print(element)}, onCompleted: {print("done")})
    
    let anyObserver = Observable<Any>.never()
    anyObserver.subscribe(onNext: {element in print(element)}, onCompleted: {print("done")})
    
    let observableCancel = Observable.of("A", "B", "C")
    let subscription = observable.subscribe { event in
      print(event)
    }
    subscription.dispose()
    
    let disposeBag = DisposeBag()
    Observable.of("A", "B", "C")
      .subscribe {
        print($0)
      }
      .disposed(by: disposeBag)
    
    enum MyError: Error {
      case anError
    }
    
    let disposeBag1 = DisposeBag()
    Observable<String>.create { observer in
      observer.onNext("1")
      observer.onError(MyError.anError)
      observer.onCompleted()
      observer.onNext("?")
      return Disposables.create()
      }.subscribe(
        onNext: {print($0)},
        onError: {print($0)},
        onCompleted: {print("Completed")},
        onDisposed: {print("Disposed")})
      .disposed(by: disposeBag1)
  }
}

