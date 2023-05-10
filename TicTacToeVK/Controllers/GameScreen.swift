//
//  GameScreen.swift
//  TicTacToeVK
//
//  Created by Denis on 09.05.2023.
//

import UIKit


final class GameScreen: UIViewController {
    var cells: [Cell] = []
    let solver = Solver()
    let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
    let resetButton = UIButton()
    
    lazy var verticalStack = UIStackView(frame: CGRect(x: 10, y: 60,
                    width: view.frame.width - 20, height: view.frame.width - 20))
    
    lazy var horizontalTopStack = UIStackView(frame: CGRect(x: 10, y: 60,
                    width: view.frame.width - 20, height: view.frame.width/3 - 20))
    
    lazy var horizontalCenterStack = UIStackView(frame: CGRect(x: 10, y: 60,
                    width: view.frame.width - 20, height: view.frame.width/3 - 20))
 
    lazy var horizontalBottomStack = UIStackView(frame: CGRect(x: 10, y: 60,
                    width: view.frame.width - 20, height: view.frame.width/3 - 20))
  
    
    private func setupResetButton() {
        resetButton.setTitle("Перезапустить игру", for: .normal)
        resetButton.setTitleColor(.systemBlue, for: .normal)
        resetButton.addTarget(self, action: #selector(resetGame), for: .touchUpInside)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resetButton)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: resetButton.centerXAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: resetButton.topAnchor, constant: -30)
        ])
    }
    
    private func setupStacks() {
        verticalStack.axis = .vertical
        verticalStack.alignment = .fill
        verticalStack.distribution = .fillEqually
        let cellSpacing:CGFloat = 5
        verticalStack.spacing = cellSpacing
        verticalStack.layer.borderColor = UIColor.lightGray.cgColor
        verticalStack.layer.borderWidth = 4
        verticalStack.layer.cornerRadius = 10
        verticalStack.backgroundColor = .lightGray
        
        verticalStack.addArrangedSubview(horizontalTopStack)
        verticalStack.addArrangedSubview(horizontalCenterStack)
        verticalStack.addArrangedSubview(horizontalBottomStack)
        
        horizontalTopStack.addArrangedSubview(cells[0])
        horizontalTopStack.addArrangedSubview(cells[1])
        horizontalTopStack.addArrangedSubview(cells[2])
        horizontalTopStack.axis = .horizontal
        horizontalTopStack.alignment = .fill
        horizontalTopStack.distribution = .fillEqually
        horizontalTopStack.spacing = cellSpacing
        
        horizontalCenterStack.addArrangedSubview(cells[3])
        horizontalCenterStack.addArrangedSubview(cells[4])
        horizontalCenterStack.addArrangedSubview(cells[5])
        horizontalCenterStack.axis = .horizontal
        horizontalCenterStack.alignment = .fill
        horizontalCenterStack.distribution = .fillEqually
        horizontalCenterStack.spacing = cellSpacing
        
        horizontalBottomStack.addArrangedSubview(cells[6])
        horizontalBottomStack.addArrangedSubview(cells[7])
        horizontalBottomStack.addArrangedSubview(cells[8])
        horizontalBottomStack.axis = .horizontal
        horizontalBottomStack.alignment = .fill
        horizontalBottomStack.distribution = .fillEqually
        horizontalBottomStack.spacing = cellSpacing
    }
    
    private func setupCells() {
        cells = [Cell(), Cell(), Cell(), Cell(), Cell(), Cell(), Cell(), Cell(), Cell()]
        for (index, cell) in cells.enumerated() {
            cell.addGestureRecognizer(CellTapRecognizer(target: self, action: #selector(isPressed(sender: )), index: index))
        }
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        setupCells()
        solver.delegate = self
        alert.addAction(UIAlertAction(title: NSLocalizedString("Заново", comment: "Default action"), style: .default, handler: {_ in }))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStacks()
        view.addSubview(verticalStack)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupResetButton()
    }
    
    @objc func isPressed(sender: Any) {
        let index = (sender as! CellTapRecognizer).index!
        if cells[index].currentState != .blank { return }
        cells[index].switchState(new: .circle)
        solver.update(index: index)
        solver.takeTurn()
        
    }
    
    public func selectedBySolver(index: Int) {
        cells[index].switchState(new: .cross)
    }
    
    public func displayWinner(winner: State) {
        switch winner {
        case .circle:
            alert.title = "Победа!"
            alert.message = "Вы победили."
        case .cross:
            alert.title = "Поражение!"
            alert.message = "Вы проиграли"
        case .blank:
            alert.title = "Ничья..."
            alert.message = "Победителя нет"
        }
        self.present(alert, animated: true, completion: nil)
        resetGame()
    }
    
    @objc private func resetGame() {
        solver.reset()
        for cell in cells {
            cell.switchState(new: .blank)
        }
    }
    
}

// костыль, чтобы в вью не передавать его индекс
final class CellTapRecognizer: UITapGestureRecognizer {
    var index: Int?
    
    init(target: Any?, action: Selector?, index: Int) {
        super.init(target: target, action: action)
        self.index = index
    }
}
