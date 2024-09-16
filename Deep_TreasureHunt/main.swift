// DEEP PATEL


import Foundation


var player1Name = "Player1"
var player2Name = "Player2"
var player1Treasures = 0
var player2Treasures = 0
var player1Points = 0
var player2Points = 0
var player1GamesWon = 0
var player2GamesWon = 0

var currentPlayer = ""
var currentPlayerTreasures = 0
var currentPlayerPoints = 0
var currentPlayerGamesWon = 0

var islands = [
    "Emerald Isle": [3, 5, 7].randomElement()!,
    "Ruby Cove": [3, 5, 7].randomElement()!,
    "Sapphire Shore": [3, 5, 7].randomElement()!
]

// set a special treasure to the number of count  (if it rendomly set as 3, then player must get 3 treasures form the island to get a special treasure)
var specialTreasures = [
    "Emerald Isle": Int.random(in: 1...islands["Emerald Isle"]!),
    "Ruby Cove": Int.random(in: 1...islands["Ruby Cove"]!),
    "Sapphire Shore": Int.random(in: 1...islands["Sapphire Shore"]!)
]

var luckyIsland = islands.keys.randomElement()!
var luckyIslandUsed = false

// to track the turn
var turnCount = 0


// ----- Functions -----

func switchTurn() {
    if currentPlayer == player1Name {
        currentPlayer = player2Name
        player1Treasures += currentPlayerTreasures
        currentPlayerTreasures = 0
        player1Points += currentPlayerPoints
        currentPlayerPoints = 0
    } else {
        currentPlayer = player1Name
        player2Treasures += currentPlayerTreasures
        currentPlayerTreasures = 0
        player2Points += currentPlayerPoints
        currentPlayerPoints = 0
    }
    turnCount += 1
}

func stealTreasure(opponent: inout Int, amount: Int) -> Bool {
    if opponent >= amount {
        opponent -= amount
        currentPlayerTreasures += amount
        currentPlayerPoints += amount * 5
        return true
    }
    return false
}

func collectTreasures(islandName: String, amount: Int) {
    let treasures = islands[islandName]!
    
    if  treasures >= amount {
        islands[islandName]! -= amount
        currentPlayerTreasures += amount
        
        let points = amount * 5
        if islandName == luckyIsland && !luckyIslandUsed {
            currentPlayerPoints += points * 2
            luckyIslandUsed = true
            print("🍀 Lucky Island! Double points!")
        } else {
            currentPlayerPoints += points
        }
        
        if amount == specialTreasures[islandName] {
            print("🎉 Special Treasure Found! \(currentPlayer) gets an extra turn!")
        } else {
            switchTurn()
        }
        
        
        if let randomIsland = islands.keys.filter({ islands[$0]! > 0 }).randomElement() {
                    islands[randomIsland]! += Int.random(in: 1...3)
                    print("New treasures appeared on \(randomIsland)! +\(islands[randomIsland]!) treasures.")
                }
        

        
    } else {
        print("Not enough treasures in \(islandName)!")
    }
}

func showScoreboard() {
    print("Scoreboard:")
    print("\(player1Name): Games won: \(player1GamesWon), Treasures: \(player1Treasures), Points: \(player1Points)")
    print("\(player2Name): Games won: \(player2GamesWon), Treasures: \(player2Treasures), Points: \(player2Points)")
}

func isGameOver() -> Bool {
    return islands.values.allSatisfy { $0 == 0 }
}

func declareWinner() {
    if player1Points > player2Points {
        player1GamesWon += 1
        print("Congratulations, \(player1Name)! You won the game!")
    } else if player2Points > player1Points {
        player2GamesWon += 1
        print("Congratulations, \(player2Name)! You won the game!")
    } else {
        print("It's a tie!")
    }
}

func resetGame() {
    player1Treasures = 0
    player2Treasures = 0
    player1Points = 0
    player2Points = 0
    islands = [
        "Emerald Isle": [3, 5, 7].randomElement()!,
        "Ruby Cove": [3, 5, 7].randomElement()!,
        "Sapphire Shore": [3, 5, 7].randomElement()!
    ]
    specialTreasures = [
        "Emerald Isle": Int.random(in: 1...islands["Emerald Isle"]!),
        "Ruby Cove": Int.random(in: 1...islands["Ruby Cove"]!),
        "Sapphire Shore": Int.random(in: 1...islands["Sapphire Shore"]!)
    ]
    luckyIsland = islands.keys.randomElement()!
    luckyIslandUsed = false
    turnCount = 0
    currentPlayer = player1Name
    
//    print(specialTreasures)  // print special Treasures
}

// main Function

func main() {
    print("--- Treasure Hunt ---")
    print("Enter Player 1 name: ", terminator: "")
    player1Name = readLine() ?? "Player 1"
    print("Enter Player 2 name: ", terminator: "")
    player2Name = readLine() ?? "Player 2"
    
    currentPlayer = player1Name
    var isPlaying = true
    
    while isPlaying {
        print("--- Treasure Hunt ---")
        print("1. Start a new game")
        print("2. Show scoreboard")
        print("3. Exit")
        print("Choose an option: ", terminator: "")
        let choice = Int(readLine() ?? "")
        if choice == 1 {
            resetGame()
            while !isGameOver() {
                print("\(currentPlayer)'s turn.")
                print("Current Treasures:")
                for (island, treasures) in islands {
                    print("\(island): \(treasures) treasures")
                }
                
                print("Select an island: ", terminator: "")
                let selectedIsland = readLine() ?? ""
                
                if islands.keys.contains(selectedIsland) {
                    print("How many treasures do you want to collect from \(selectedIsland)? ", terminator: "")
                    let amount = Int(readLine() ?? "")!
                    if  amount > 0 {
                        collectTreasures(islandName: selectedIsland, amount: amount)
                    }
                }
                
                if turnCount % 3 == 0 {
                    print("Do you want to steal treasures from the opponent? (yes/no): ", terminator: "")
                    let stealChoice = readLine() ?? "no"
                    if stealChoice.lowercased() == "yes" {
                        print("How many treasures do you want to steal? ", terminator: "")
                        let amount = Int(readLine() ?? "")!
                        if  amount > 0 {
                            if currentPlayer == player1Name {
                                if stealTreasure(opponent: &player2Treasures, amount: amount) {
                                    print("\(currentPlayer) stole \(amount) treasures from \(player2Name).")
                                } else {
                                    print("\(player2Name) doesn't have enough treasures.")
                                }
                            } else {
                                if stealTreasure(opponent: &player1Treasures, amount: amount) {
                                    print("\(currentPlayer) stole \(amount) treasures from \(player1Name).")
                                } else {
                                    print("\(player1Name) doesn't have enough treasures.")
                                }
                            }
                            switchTurn()  // Skip next turn after stealing
                        }
                    }
                }
            }
            declareWinner()
        } else if choice == 2 {
            showScoreboard()
        } else if choice == 3 {
            isPlaying = false
            print("Exiting the game. Goodbye!")
        } else {
            print("Invalid choice. Please try again.")
        }
    }
}

main()
