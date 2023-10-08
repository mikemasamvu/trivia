import UIKit

class TriviaViewController: UIViewController {
    
    @IBOutlet weak var currentQuestionNumberLabel: UILabel!
    @IBOutlet weak var questionContainerView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var answerButton0: UIButton!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    
    private var triviaQuestions = [TriviaQuestion]() // Assuming TriviaQuestion is correctly imported
    private var currentQuestionIndex = 0
    private var correctAnswersCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionContainerView.layer.cornerRadius = 8.0
        loadSampleTriviaQuestions()
        updateQuestion(withQuestionIndex: currentQuestionIndex)
    }
    
    private func loadSampleTriviaQuestions() {
        // Sample trivia questions
        let question1 = TriviaQuestion(
            category: "Geography", question: "What is the capital of Zimbabwe?",
            correctAnswer: "Harare",
            incorrectAnswers: ["South Africa", "Berlin", "France"]
        )
        
        let question2 = TriviaQuestion(
            category: "Science", question: "Which planet is known as the Red Planet?",
            correctAnswer: "Mars",
            incorrectAnswers: ["Earth", "Venus", "Jupiter"]
        )
        
        let question3 = TriviaQuestion(
            category: "Sports", question: "Which team won the latest World Cup'?",
            correctAnswer: "Argentina",
            incorrectAnswers: ["Morocco", "France", "England"]
        )
        
        // Add sample questions to the array
        triviaQuestions = [question1, question2, question3]
    }
    
    private func updateQuestion(withQuestionIndex questionIndex: Int) {
        currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(triviaQuestions.count)"
        let question = triviaQuestions[questionIndex]
        questionLabel.text = question.question
        categoryLabel.text = "Category: \(question.category)"
        
        let answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()
        answerButton0.setTitle(answers[0], for: .normal)
        answerButton1.setTitle(answers[1], for: .normal)
        answerButton2.setTitle(answers[2], for: .normal)
        answerButton3.setTitle(answers[3], for: .normal)
    }
    
    private func updateToNextQuestion(answer: String) {
        if isCorrectAnswer(answer) {
            correctAnswersCount += 1
        }
        currentQuestionIndex += 1
        if currentQuestionIndex < triviaQuestions.count {
            updateQuestion(withQuestionIndex: currentQuestionIndex)
        } else {
            showFinalScore()
        }
    }
    
    private func isCorrectAnswer(_ answer: String) -> Bool {
        return answer == triviaQuestions[currentQuestionIndex].correctAnswer
    }
    
    private func showFinalScore() {
        let alertController = UIAlertController(title: "Game Over!",
                                                message: "Final score: \(correctAnswersCount)/\(triviaQuestions.count)",
                                                preferredStyle: .alert)
        let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
            currentQuestionIndex = 0
            correctAnswersCount = 0
            updateQuestion(withQuestionIndex: currentQuestionIndex)
        }
        alertController.addAction(resetAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func didTapAnswerButton0(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
    
    @IBAction func didTapAnswerButton1(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
    
    @IBAction func didTapAnswerButton2(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
    
    @IBAction func didTapAnswerButton3(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
}
