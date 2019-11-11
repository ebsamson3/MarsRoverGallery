//
//  Observer.swift
//  ObserverExample
//
//  Created by Edward Samson on 9/21/19.
//  Copyright © 2019 Edward Samson. All rights reserved.
//

import Foundation

/// Observer protocol that ensures an observer has a dispose bag for destroying observable subsciptions on de-init
protocol Observer: class {
	var disposeBag: DisposeBag { get set }
}

extension Observer {
	
	/// A function that subscribes to an observation and puts the returned disposable in the dispose bag.
	func observe<T>(
		_ observable: Observable<T>,
		options: ObservableOptions = [],
		didChange: @escaping Observable<T>.ChangeHandler) {
		
		observable.addObserver(self, options: options, didChange: didChange)
			.disposed(by: disposeBag)
	}
	
	/// Removes all observations from the observer
	func removeAllObservations() {
		disposeBag = DisposeBag()
	}
}
