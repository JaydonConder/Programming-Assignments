#!/usr/bin/python

#the parent class of all of the different possible moves
class Element:
	def __init__(self, name):
		self.name = name
	def name():
		return name
	def compareTo(Element):
		raise NotImplementedError("Not yet implemented")
'''
undefined method that will be defined in the classes that implement this class.
It will be used to compare two instances of the different classes and see which
one will be considered the victor using the rules built into the game
'''

#The Rock class (fist). It will beat Scissors and Lizard, but is beaten by Paper and Spock
class Rock(Element):
	def __init__ (self, name):
		self.name = name

	def compareTo(self, Element):
		if Element.name == "Scissors":
			return ("Rock crushes Scissors", "Win")
		elif Element.name == "Paper":
			return ("Paper covers Rock", "Lose")
		elif Element.name == "Lizard":
			return ("Rock crushes Lizard", "Win")
		elif Element.name == "Spock":
			return ("Spock vaporizes Rock", "Lose")
		else:
			return ("Rock equals Rock", "Tie")

#The Scissors class (V between middle and index fingers). It will beat Paper and Lizard, but is beaten by Rock and Spock
class Scissors(Element):
	def __init__(self, name):
		self.name = name

	def compareTo(self, Element):
		if Element.name == "Rock":
			return ("Rock crushes Scissors", "Lose")
		elif Element.name == "Paper":
			return ("Scissors cut Paper", "Win")
		elif Element.name == "Lizard":
			return ("Scissors decapitate Lizard", "Win")
		elif Element.name == "Spock":
			return ("Spock smashes Scissors", "Lose")
		else:
			return ("Scissors equals Scissors", "Tie")

#The Paper class (flat hand parallel to the floor). It will beat Rock and Spock, but is beaten by Scissors and Lizard
class Paper (Element):
	def __init__(self, name):
		self.name = name

	def compareTo(self, Element):
		if Element.name == "Rock":
			return ("Paper covers Rock", "Win")
		elif Element.name == "Scissors":
			return ("Scissors cut Paper", "Lose")
		elif Element.name == "Lizard":
			return ("Lizard eats Paper", "Lose")
		elif Element.name == "Spock":
			return ("Paper disproves Spock", "Win")
		else:
			return ("Paper equals Paper", "Tie")

#The Lizard class (slightly curved fingers with thumb bent up toward the rest). It will beat Paper and Spock, but is beaten by Rock and Scissors
class Lizard(Element):
	def __init__(self, name):
		self.name = name

	def compareTo(self, Element):
		if Element.name == "Rock":
			return ("Rock crushes Lizard", "Lose")
		elif Element.name == "Paper":
			return ("Lizard eats Paper", "Win")
		elif Element.name == "Scissors":
			return ("Scissors decapitates Lizard", "Lose")
		elif Element.name == "Spock":
			return ("Lizard poisons Spock", "Win")
		else:
			return ("Lizard equals Lizard", "Tie")

#The Spock class (V between middle and ring fingers with thumb pointing off to the side). It will beat Rock and Scissors, but is beaten by Paper and Lizard
class Spock(Element):
	def __init__(self, name):
		self.name = name

	def compareTo(self, Element):
		if Element.name == "Rock":
			return ("Spock vaporizes Rock", "Win")
		elif Element.name == "Scissors":
			return ("Spock smashes Scissors", "Win")
		elif Element.name == "Paper":
			return ("Paper disproves Spock", "Lose")
		elif Element.name == "Lizard":
			return ("Lizard poisons Spock", "Lose")
		else:
			return ("Spock equals Spock", "Tie")


#A global list to hold a concrete instance of each of the five Elements
moves = [Rock("Rock"), Paper("Paper"), Scissors("Scissors"), Lizard("Lizard"), Spock("Spock")]

'''
The parent class to all of the different player types (Human, StupidBot, RandomBot,
IterativeBot, LastPlayBot, and MyBot
'''
class Player:
    def __init__ (self, name):
        self.name = name

    def name():
        return name

    def play():
        raise NotImplementedError("Not yet implemented")
'''
A global variable that will be used by both the LastPlayBot and MyBot that will
determine which moves each of those classes will make. Starts as Rock, but changes
each round.
'''
lastMove = moves[0]


'''
A bot that always throws the same class every round (in this case, it will use
Spock every single time (because Spock is awesome))
'''
class StupidBot(Player):
    def __init__(self, name):
        self.name = name

    def play(self):
        move = moves[4]
        global lastMove
        lastMove = move
        return move

'''
A bot that will throw out a random option every time, chosing any of the five
options that it has available
'''
class RandomBot(Player):
    def __init__(self, name):
        self.name = name

    def play(self):
        from random import randrange
        rand = int(randrange(5))
        move = moves[rand]
        global lastMove
        lastMove = move
        return move
'''
A global variable that counts how many times IterativeBot.play() has been called
in order to determine which move will be used. It will go in the order:
Rock, Paper, Scissors, Lizard, and then Spock
'''
counter = 0

#See counter above for description
class IterativeBot(Player):
    def __init__(self, name):
        self.name = name

    def play(self):
        global counter
        move = moves[counter]
        counter += 1
        global lastMove
        lastMove = move
        return move

'''
A class that allows the user to chose whatever move he or she feels like using
during each round. It uses a while loop in order to make sure that the number
typed is a valid number and will keep asking the user for a new number until
a number between 1 and 5 is typed. Does not check for an empty line, letters,
or symbols so if chosen any of those will create an error.
'''
class Human(Player):
    def __init__ (self, name):
        self.name = name

    def checkChoice(self):
        choice = int(input("Enter your move: "))
        while choice > 5 or choice < 1:
            print ("Invalid move. Please try again")
            choice = int(input("Enter your move: "))
        return choice
            
    
    def play(self):
        print ("(1) : Rock")
        print ("(2) : Paper")
        print ("(3) : Scissors")
        print ("(4) : Lizard")
        print ("(5) : Spock")
        choice = self.checkChoice()
        move = moves[choice-1]
        global lastMove
        lastMove = move
        return move
    
'''
A cheating class that always looks to see what the other uses choses to do
first, and then will base its choice on what will beat that player. It uses
the more interesting winning situations: Spock vaporizes Rock, Lizard eats
Paper, Spock smashes Scissors, Scissors decapitate Lizard, and Paper
disproves Spock.
'''
class MyBot(Player):
    def __init__(self, name):
        self.name = name

    def play(self):
        
        global lastMove
        lm = lastMove.name
        if lm == "Rock":
            move = moves[4]
        elif lm == "Paper":
            move = moves[3]
        elif lm == "Scissors":
            move = moves[4]
        elif lm == "Lizard":
            move = moves[2]
        else:
            move = moves[1]
        lastMove = move
        return move

'''
A class that keeps track of the last move made by the other player and uses
that. It will always start the first round as Rock, and then will use the other
player's previous option. 
'''
class LastPlayBot(Player):
    def __init__ (self, name):
        self.name = name

    def play(self):
        global lastMove
        move = lastMove
        return move

'''
The main method of the class that welcomes the user and gives him or her the
option to chose what type of players they want to use. It checks both numbers
entered to make sure that they are usable numbers, and if not gives the user
an error message. 
'''
class Main:
    def __init__(self, name):
        self.name = name
    def start(self):
        print("Welcome to Rock, Paper, Scissors, Lizard, Spock, implemented by Jaydon Conder. \n")
        print("Please choose two players: \n     (1) Human\n     (2) StupidBot\n     (3) RandomBot")
        print("     (4) IterativeBot\n     (5) LastPlayBot\n     (6) MyBot\n")

        p1 = int(input("Select Player 1: "))
        p2 = int(input("Select Player 2: "))
        print("")
        players=[Human("Human"), StupidBot("StupidBot"), RandomBot("RandomBot"), IterativeBot("IterativeBot"), LastPlayBot("LastPlayBot"), MyBot("MyBot")]
        while p1 > 6 or p1 < 0:
            p1 = int(input("Error. Please enter a valid number for Player 1: "))
        while p2 > 6 or p2 < 0:
            p2 = int(input("Error. Please enter a valid number for Player 2: "))

        pl1 = players[p1-1]
        pl2 = players[p2-1]

        print(pl1.name + " vs " + pl2.name + ". Go! \n")

        #Counters that count how many times each player has won so far
        p1wins = 0
        p2wins = 0

        #A for loop that allows the players to do five rounds and counts who wins each round
        for x in range(0, 5):
        
                 print("Round " + str(x + 1) + ":")
                 if p2 == 5 or p1 == 6:
                     p2move = pl2.play()
                     p1move = pl1.play()
                 else:
                     p1move = pl1.play()
                     p2move = pl2.play()
                 print("   Player 1 chose " + p1move.name)
                 print("   Player 2 chose " + p2move.name)
                 sent, win = p1move.compareTo(p2move)
                 print("  ", sent)
                 if win == "Win":
                     p1wins += 1
                     print("   Player 1 won the round")
                 elif win == "Lose":
                     p2wins += 1
                     print("   Player 2 won the round")
                 else:
                     print("   Round was a draw")
                 print("")
        print("The score was", p1wins, "to", p2wins)
        #checks which player won the game by comparing number of wins
        if p1wins > p2wins:
                 print("Player 1 won the game")
        elif p1wins < p2wins:
                 print("Player 2 won the game")
        else:
                 print("Game was a draw")


main = Main('main')
main.start()
