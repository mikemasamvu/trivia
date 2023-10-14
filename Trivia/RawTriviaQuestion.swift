//
//  RawTriviaQuestion.swift
//  Trivia
//
//  Created by yale on 10/14/23.
//

import Foundation

struct RawTriviaQuestion: Decodable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    func convertToTriviaQuestion() -> TriviaQuestion {
        // Decode HTML entities in the question and answers
        let decodedQuestion = decodeHTMLEntities(self.question)
        let decodedCorrectAnswer = decodeHTMLEntities(self.correctAnswer)
        let decodedIncorrectAnswers = self.incorrectAnswers.map { decodeHTMLEntities($0) }
        
        return TriviaQuestion(
            category: self.category,
            question: decodedQuestion,
            correctAnswer: decodedCorrectAnswer,
            incorrectAnswers: decodedIncorrectAnswers
        )
    }
    
    private func decodeHTMLEntities(_ input: String) -> String {
        if let data = input.data(using: .utf8),
           let decodedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil).string {
            return decodedString
        }
        return input
    }
}

