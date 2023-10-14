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

    private var triviaQuestions = [TriviaQuestion]()
    private var currentQuestionIndex = 0
    private var correctAnswersCount = 0

    private let triviaQuestionService = TriviaQuestionService()

    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        questionContainerView.layer.cornerRadius = 8.0
        loadTriviaQuestions()
    }

    private func loadTriviaQuestions() {
        triviaQuestionService.fetchTriviaQuestions { [weak self] questions in
            if let questions = questions, !questions.isEmpty {
                self?.triviaQuestions = questions
                self?.currentQuestionIndex = 0
                self?.correctAnswersCount = 0
                DispatchQueue.main.async {
                    self?.updateQuestion(withQuestionIndex: self?.currentQuestionIndex ?? 0)
                }
            } else {
                // Handle the case where questions could not be fetched
                print("Failed to fetch trivia questions.")
            }
        }
    }

    private func decodeHTMLEntities(_ input: String) -> String {
        if let data = input.data(using: .utf8),
           let decodedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil).string {
            return decodedString
        }
        return input
    }

    
    private func updateQuestion(withQuestionIndex questionIndex: Int) {
        currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(triviaQuestions.count)"
        let question = triviaQuestions[questionIndex]
        questionLabel.text = decodeHTMLEntities(question.question)
        categoryLabel.text = "Category: \(decodeHTMLEntities(question.category))"

        if question.incorrectAnswers.count == 1 {
            // True or False question
            answerButton2.isHidden = true
            answerButton3.isHidden = true

            answerButton0.setTitle("True", for: .normal)
            answerButton1.setTitle("False", for: .normal)
        } else {
            // Multiple-choice question, show all answer buttons
            answerButton2.isHidden = false
            answerButton3.isHidden = false

            let answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()
            answerButton0.setTitle(decodeHTMLEntities(answers[0]), for: .normal)
            answerButton1.setTitle(decodeHTMLEntities(answers[1]), for: .normal)
            answerButton2.setTitle(decodeHTMLEntities(answers[2]), for: .normal)
            answerButton3.setTitle(decodeHTMLEntities(answers[3]), for: .normal)
        }
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
            self.loadTriviaQuestions() // Fetch new questions and reset game variables
        }
        alertController.addAction(resetAction)
        present(alertController, animated: true, completion: nil)
    }


    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                                UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
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
