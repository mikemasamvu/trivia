//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Mike on 10/13/23.
//

import Foundation

struct TriviaQuestionService {
    let baseURL = "https://opentdb.com/api.php"
    
    func fetchTriviaQuestions(completion: @escaping ([TriviaQuestion]?) -> Void) {
        let apiURL = "https://opentdb.com/api.php?amount=10" // Fetch 10 questions

        guard let url = URL(string: apiURL) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching trivia questions: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received from the API.")
                completion(nil)
                return
            }

            do {
                let triviaResponse = try JSONDecoder().decode(TriviaResponse.self, from: data)
                completion(triviaResponse.results)
            } catch {
                print("Error decoding trivia questions: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }

}
