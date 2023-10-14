//
//  TriviaResponse.swift
//  Trivia
//
//  Created by yale on 10/14/23.
//

import Foundation

struct TriviaResponse: Decodable {
    let results: [TriviaQuestion]
}



