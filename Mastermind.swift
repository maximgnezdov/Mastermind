//
//  Mastermind.swift
//  Group_1
//
//  Created by Max on 20/06/2021.
//

import Foundation

class Board {
    private enum Pegs: CaseIterable{
        case Red, Yellow, Green, Blue, White, Black, Empty, blackStatus, whiteStatus, emptyStatus
    }
    
    let rows = 10
    let columns = 8
    let numberOfGuesses = 10
    var row = 0
    var gameStatus = 0
    var blackPegsGuessCounter = 0
    
    private var board: [[Pegs]]
    
    private var code: [Pegs]
    
    public init() {
        board = Array(repeating: Array(repeating: .Empty, count: columns), count: rows)
        
        code = Array(repeating: .Empty, count: 4)
    }
    
    public func printBoard() {
        var boardString = ""
        for i in 0..<8 {
            switch i {
            case 0: print("1️⃣", terminator:"")
            case 1: print("2️⃣", terminator:"")
            case 2: print("3️⃣", terminator:"")
            case 3: print("4️⃣", terminator:"")
            case 4: print("⬇️", terminator:"")
            case 5: print("⬇️", terminator:"")
            case 6: print("⬇️", terminator:"")
            case 7: print("⬇️", terminator:"")
            default:
                print(i, terminator:"")
            }
            
        }
        
        for row in 0..<10 {
            boardString += "\n"
    
            for col in 0..<8 {
                switch board[row][col] {
                case .Empty:
                    boardString += "🟫"
                case .Red:
                    boardString += "🟥"
                case .Yellow:
                    boardString += "🟨"
                case .Green:
                    boardString += "🟩"
                case .Blue:
                    boardString += "🟦"
                case .White:
                    boardString += "⬜️"
                case .Black:
                    boardString += "⬛️"
                case .blackStatus:
                    boardString += "⚫️"
                case .whiteStatus:
                    boardString += "⚪️"
                case .emptyStatus:
                    boardString += "🟤"
                }
            }
        }
        boardString += "\n"
        print(boardString)
    }
    
    public func makeCode(board: Board) {
        var i: Int = 0
        
        while(i<4) {
            board.code[i] = Pegs.allCases.randomElement()!
            if(board.code[i] == .blackStatus) {board.code[i] = .Black}
            else if(board.code[i] == .whiteStatus) {board.code[i] = .White}
            else if(board.code[i] == .emptyStatus) {board.code[i] = .Empty}
            
            i += 1
        }
    }
    
    
    public func makeGuess(board: Board) {
        
        blackPegsGuessCounter = 0
        
        var choice: Int
        var i: Int = 0
        var black: Int = 0
        var white: Int = 0
        
        //MAKE A GUESS
        while(i<4) {
            choice = readSoloInt() - 1
            
            switch choice {
            case 0:
                board.board[row][i] = .Red
            case 1:
                board.board[row][i] = .Yellow
            case 2:
                board.board[row][i] = .Green
            case 3:
                board.board[row][i] = .Blue
            case 4:
                board.board[row][i] = .White
            case 5:
                board.board[row][i] = .Black
            case 6:
                board.board[row][i] = .Empty
            default:
                board.board[row][i] = .Empty
            }
            i += 1
        }
        
        //CHECK AND MARK GUESS
        i = 0
    
        while(i<4) {
            if(board.board[row][i] == board.code[i]) {
                board.board[row][i+4] = .blackStatus
                blackPegsGuessCounter += 1
            }
            i += 1
        }
        
        i = 0
        while(i<4) {
            var j: Int = 0
            while (j<4) {
                if (board.board[row][j] == board.code[i] && board.board[row][j+4] != .blackStatus) {
                    board.board[row][j+4] = .whiteStatus
                }
                else if (board.board[row][j] != board.code[i] && board.board[row][j+4] != .blackStatus && board.board[row][j+4] != .whiteStatus) {
                    board.board[row][j+4] = .emptyStatus
                    
                }
                j += 1
            }
            i += 1
        }
        
        
        i = 0
    
        while(i<4) {
            if(board.board[row][i+4] == .blackStatus) {
                black += 1
            } else if(board.board[row][i+4] == .whiteStatus) {
                white += 1
            }
            i += 1
        }
        
        //print(black)
        //print(white)

        board.board[row][4] = .emptyStatus
         board.board[row][5] = .emptyStatus
        board.board[row][6] = .emptyStatus
        board.board[row][7] = .emptyStatus
        
        var numbers = [4, 5, 6, 7]
        var n:Int = 0
        numbers.shuffle()
        //print("numbers: ")
        //print(numbers)
    
        var b: Int = 1
        if black > 0 {
            while b<=black {
                //print(numbers[n])
                board.board[row][numbers[n]] = .blackStatus
                n+=1
                b+=1
            }
        }
 
        var w: Int = 1
        if white > 0 {
            while w<=white {
                //print(numbers[n])
                board.board[row][numbers[n]] = .whiteStatus
                n+=1
                w+=1
            }
        }
 

        row += 1
    }
    
    public func printCode() {
        for i in code {
            print(i)
        }
        
    }
    
    private func readSoloInt() -> Int {
        var optional: Int? = nil
        repeat {
            print("Enter number: (1 - Red, 2 - Yellow, 3 - Green, 4 - Blue, 5 - White, 6 - Black, 7 - Empty)")
            optional = Int(readLine()!)
        }while optional == nil;
        return optional!
    }
    
    public func runGame(gameBoard: Board) {
        
        gameBoard.makeCode(board: gameBoard)
        while(true) {
            gameBoard.printBoard()
            gameBoard.printCode()//CODE
            
            gameBoard.makeGuess(board: gameBoard)
            
            gameStatus += 1
            
            print("gameStatus: ",gameStatus)
            
            if(blackPegsGuessCounter == 4) {
                gameBoard.printBoard()
                print("-----❗️❗️❗️Congratulations You Won❗️❗️❗️-----")
                break
            }
            else if (gameStatus == numberOfGuesses) {
                gameBoard.printBoard()
                print("-----☠️YOU LOST☠️-----")
                break
            }
        }
    }
}
