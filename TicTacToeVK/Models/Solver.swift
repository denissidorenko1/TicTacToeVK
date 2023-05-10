//
//  Solver.swift
//  TicTacToeVK
//
//  Created by Denis on 10.05.2023.
//

import UIKit

enum State {
    case circle
    case cross
    case blank
}

final class Solver {
    weak var delegate: GameScreen?
    private var data: [State] = [.blank, .blank, .blank, .blank, .blank, .blank, .blank, .blank, .blank]
    
    public func takeTurn() {
        // после хода игрока может быть определен выигрыш или окончание игры, нужно проверить
        if findWinner() {
            return
        }
        let blanks = data.indices.filter {data[$0] == .blank}
        let selected = blanks.randomElement()!
        data[selected] = .cross
        delegate?.selectedBySolver(index: selected)
        // проверка после хода устройства
        findWinner()
    }
    
    // обновляем модель вслед за UI
    public func update(index: Int) {
        data[index] = .circle
    }
    
    // обнуляем модель для начала новой игры
    public func reset() {
        data = [.blank, .blank, .blank, .blank, .blank, .blank, .blank, .blank, .blank]
    }
    
    // перебираем победные комбинации, возвращаем флаг завершения игры
    private func findWinner() -> Bool {
        if data[0] == data[1] && data[1] == data[2] && data[0] != .blank {
            delegate?.displayWinner(winner: data[0])
            return true
        } else if data[3] == data[4] && data[4] == data[5] && data[3] != .blank {
            delegate?.displayWinner(winner: data[3])
            return true
        } else if data[6] == data[7] && data[7] == data[8] && data[6] != .blank {
            delegate?.displayWinner(winner: data[6])
            return true
        } else if data[0] == data[3] && data[3] == data[6] && data[0] != .blank {
            delegate?.displayWinner(winner: data[0])
            return true
        } else if data[1] == data[4] && data[4] == data[7] && data[1] != .blank {
            delegate?.displayWinner(winner: data[1])
            return true
        } else if data[2] == data[5] && data[5] == data[8] && data[2] != .blank {
            delegate?.displayWinner(winner: data[2])
            return true
        } else if data[0] == data[4] && data[4] == data[8] && data[0] != .blank {
            delegate?.displayWinner(winner: data[0])
            return true
        } else if data[2] == data[4] && data[4] == data[6] && data[2] != .blank {
            delegate?.displayWinner(winner: data[2])
            return true
        } else if data.filter({$0 == .blank}).count == 0 {
            delegate?.displayWinner(winner: .blank)
            return true
        }
        return false
    }
}
