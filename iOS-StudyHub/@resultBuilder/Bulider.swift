//
//  Bulider.swift
//  iOS-StudyHub
//
//  Created by 최민준 on 4/12/25.
//

import Foundation

struct Person {
  var name: String
  let age: Int
}

// resultBuilder 응용
@resultBuilder enum Builder<T> {
  static func buildBlock(_ component: T) -> T { component }
  static func buildEither(first component: T) -> T { component }
  static func buildEither(second component: T) -> T { component }
}
func builder<T>(@Builder<T> _ closure: () -> T) -> T { closure() }

@resultBuilder struct PersonBuilder {
  static func buildBlock(_ components: Person...) -> [Person] {
    components.map { Person(name: $0.name + "🍎", age: $0.age) }
  }
}

@PersonBuilder
func getPerson() -> [Person] {
  Person(name: "minjun", age: 20)
  Person(name: "choi", age: 22)
  Person(name: "joon", age: 32)
}

//private func getPerson2() -> Person {
//  builder {
//    if num % 2 == 0 {
//      Person(name: "jake", age: 2)
//    } else {
//      Person(name: "jake", age: 1)
//    }
//  }
//}
