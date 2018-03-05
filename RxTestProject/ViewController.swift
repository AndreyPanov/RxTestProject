import UIKit
import RxSwift

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    subjects()
  }
  
  func test() {
    let observable: Observable<Int> = Observable<Int>.just(4)
    let observable2 = Observable.of(3, 4, 2)
    let observable3 = Observable.of([3, 4, 2])
    let observable4 = Observable.from([3, 5, 6])
    
    observable.subscribe { event in
      //print(event.element)
    }
    
    
    observable2.subscribe { event in
      if let element = event.element {
        //print(element)
      }
    }
    
    observable3.subscribe(onNext: {element in
      //print(element)
    })
    
    observable4.subscribe { event in
      //print(event)
    }
    
    let emptyObserver = Observable<Void>.empty()
    emptyObserver.subscribe(onNext: {element in print(element)}, onCompleted: {print("done")})
    
    let anyObserver = Observable<Any>.never()
    anyObserver.subscribe(onNext: {element in print(element)}, onCompleted: {print("done")})
    
    let observableCancel = Observable.of("A", "B", "C")
    let subscription = observableCancel.subscribe { event in
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
  
  func factory() {
    let disposeBag = DisposeBag()
    var flip = false
    let factory: Observable<Int> = Observable.deferred {
      flip = !flip
      if flip {
        return Observable.of(1, 2, 3)
      } else {
        return Observable.of(4, 5, 6)
      }
    }
    
    for _ in 0...3 {
      factory.subscribe(onNext: {
        print($0)
      }).disposed(by: disposeBag)
    }
  }
  
  func challengeFirst() {
    let disposeBag = DisposeBag()
    let neverObserver = Observable<Any>.never()
    neverObserver
      .do(onNext: { element in print("I can print it! \(element)")},
          onError: {_ in}, onCompleted: {print("done")}, onSubscribe: {print("subscribed")}, onSubscribed: {}, onDispose: {print("disposed")})
      .subscribe(onNext: {element in print(element)}, onCompleted: {print("done")})
      .disposed(by: disposeBag)
    
  }
  
  func challengeSecond() {
    let disposeBag = DisposeBag()
    let string = ""
    let neverObserver = Observable<Any>.never()
    neverObserver
      .debug(string, trimOutput: false)
      .subscribe(onNext: {element in print(element)}, onCompleted: {print("done")})
      .disposed(by: disposeBag)
    print(string)
  }
  
  func subjects() {
    let subject = PublishSubject<String>()
    
    let listner = subject.subscribe({ string in
      print(string)
    })
    subject.on(.next("1"))
    listner.dispose()
    subject.onNext("Listen?")
    
    let subscriptionTwo = subject
      .subscribe { event in
        print("2)", event.element ?? event)
    }
    subject.on(.next("33"))
  }
}

