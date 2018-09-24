//
//  terminalGame.swift
//  
//
//  Created by Benoit Fagot on 06/09/2018.
//

import Foundation


//Weapon class contains a value of power and a special power (My bonus)
class Weapon{
    var weaponPower: Int
    var weaponPowerName : String
    init() {
        var weaponPowerPossibility = [10,20,30,40] //possibility of power value
        let randomWeaponPowerIndex = arc4random_uniform(UInt32(weaponPowerPossibility.count)) //random index
        self.weaponPower = weaponPowerPossibility[Int(randomWeaponPowerIndex)] //random value
        var weaponPowerNamePossibility = ["vampire","critical","badPower","poison","cecite"]
        let randomWeaponPowerNameIndex = arc4random_uniform(UInt32(weaponPowerNamePossibility.count))
        self.weaponPowerName = weaponPowerNamePossibility[Int(randomWeaponPowerNameIndex)] // random special power
    }
    
}
//the main class
class Character {
    var weaponPower = 0
    var basicAttack : Int
    var fullAttaque : Int
    var basicHeal : Int
    var fullHeal : Int
    var type : String
    var beDead : Bool = false
    var name : String
    var life  : Int
    var MAX_life : Int
    var putStatus : Int = 0
    var haveStatus : Int = 0
    
    
    init(life : Int , basicAttack : Int, basicHeal : Int , name : String ,type : String) {
        self.life = life
        self.basicAttack = basicAttack
        self.fullAttaque = basicAttack
        self.name = name
        self.basicHeal = basicHeal
        self.fullHeal = basicHeal
        self.type = type
        self.MAX_life = life
    }
//    the weapon have a value of his own power  and a special power
    func receiveWeapon(weapon : Weapon)
    {
        self.weaponPower = weapon.weaponPower
        self.fullAttaque =  self.basicAttack + weaponPower
       
        switch weapon.weaponPowerName {
//        var weaponPowerNamePossibility = ["vampire","critical","badPower","poison","cecite"]
        case "badPower":
            self.weaponPower = 0
        case "critical":
            self.weaponPower = weaponPower + Int(weaponPower/2)
        case "vampire" :
            self.putStatus = 1
        case "poison" :
            self.putStatus = 2
        case "cecite" :
            self.putStatus = 3
        default :
           self.putStatus = 9
        }
        print("you have a new weapon!!! your weapon Power is : \(weaponPower) your attack is : \(fullAttaque)\n")
        
        print("the power of the weapon is \(weapon.weaponPowerName)\n")
    }
    func informations()
    {
        print("TYPE : \(type) , NAME : \(name) , LIFE : \(life) , ATTACK : \(fullAttaque) , HEAL : \(fullHeal)")
    }
    func receiveDamage(damage : Int){
        
        life -= damage
        
        if life <= 0
        {
            life = 0
            self.beDead = true
            print("the character is dead\n")
        }
    }
//    check for poison if the character is poisoned , he received - 5
    func checkStatus()
    {

        if (haveStatus == 2 )
        {
            print("you are poisoned \n")
            receiveDamage(damage : 5)
        }

    }
//    attack function
    func attack (character : Character) {
        character.haveStatus = self.putStatus
//        if blinded the character don't attack
        if (self.haveStatus == 3 )
        {
            print("your are blinded you miss your target \n")
            self.haveStatus = 0
        }
        else
        {
            character.receiveDamage(damage: self.fullAttaque)
        }
//        if the character have a weapon vampirise he heal himself
        if (character.haveStatus == 1 && self.beDead != true && character.beDead != true)
        {
            print("you vampirise \n")
            receiveHeal(fullHeal : self.fullAttaque/2)
            character.haveStatus = 0
        }

       
        
    }
//   f heal
    func receiveHeal(fullHeal : Int){
        if life != 0 {
            life += fullHeal
            if(life > MAX_life)
            {
                life = MAX_life
            }
        }
    }
//    for g
    func heal (character : Character) {
        character.receiveHeal(fullHeal: self.fullHeal)
    }

}


class Warrior: Character {
    init(name : String){
        super.init(life: 100, basicAttack: 10, basicHeal : 0, name: name, type :"Warrior")
    }

}
class Wizard: Character {
    init(name : String){
        super.init(life: 100, basicAttack: 0, basicHeal : 15 , name: name, type :"Wizard")
    }
    override func receiveWeapon(weapon : Weapon) // overiding receiveWeapon ,wizard have better heal with weapon
    {
        self.weaponPower = weapon.weaponPower
        self.fullHeal =  self.basicHeal + weaponPower
        print("you have a new weapon!!! your weapon Power is : \(weaponPower) your heal Power is : \(fullHeal)")
        
    }

}
class Titan: Character {

    init(name : String){
        super.init(life: 150, basicAttack: 5, basicHeal : 0, name: name, type :"Titan")
    }

}
class Dwarf: Character {

    init(name : String){
        super.init(life: 50, basicAttack: 40, basicHeal : 0, name: name, type :"Dwarf")
    }

}
// Player class with name and team fighter

class Player {
    let name : String
    var fighters = [Character]()
    
    init(name : String, fighters : [Character]) {
        self.name = name
        self.fighters = fighters
    }
    func getfighters() { // print all the fighters information
        var i = 0
        for perso in fighters{
            
            print("N°\(i+1)")
            perso.informations()
            i += 1
        }
        print("\n")
    }
    func getFighter(fighter : Int) ->Character{ // get one fighter of the selected index
        return fighters[fighter]
    }
}

//choose player name
func playerName ()  -> String {
    print("Enter the name of the player ")
    var result = String()
    if let name = readLine()
    {
        result = name
    }
    return result
}

var arrayOfFighter =  [String]()

// fighter name
func askFighterName() -> String
{
    var result = String()
    
    print("enter the name of the character ")
    
    if let name = readLine() //unwrapping the name of character
    {

        result = name
    }
    return result
}
// return true if the name is available
func checkNameAvailable(arrayOfFighter : [String], name : String) -> Bool
{
    for fighter in arrayOfFighter
    {
        if fighter == name{
            print("the name is unavailable")
            return false
        }
    }
    return true
}
//choose type of the character

func chooseCharacterType(name: String) -> Character
{
    var i : Bool = false
    let warrior = Warrior(name: name)
    let dwarf = Dwarf(name: name)
    let titan = Titan(name: name)
    let wizard = Wizard(name: name)
    var perso : Character = warrior
    
    while  i == false{ // repeat until you choose a good character
        i = true
        print("which class do you want to choose?"
            + "\n1. Warrior"
            + "\n2. Wizard"
            + "\n3. Dwarf"
            + "\n4. Titan")
        if let choice = readLine() // unwrapping the choice
        {
            switch choice // choose the character type
            {
                case "1":
                    perso = warrior
                case "2":
                    perso = wizard
                case "3":
                    perso = dwarf
                case "4":
                    perso = titan
                default:
                    i = false
                    print("I don't understand , please follow the instruction")
            }
        }
    }

    return perso //return the character
}
//  create the name of the fighter ,check is the name is OK  and choose the character type .
func createFighter(arrayOfFighter : [String]) -> Character
{

    var perso : Character
    var name : String

        name = askFighterName()
        while checkNameAvailable(arrayOfFighter : arrayOfFighter, name : name) == false
       {
        name = askFighterName()
        }
        
        perso = chooseCharacterType(name: name)
    return perso
}






////                                  !!!!!          AUTO FILLING       !!!!
//var persos = [Character]()
//var persos2 = [Character]()
//var persotest1 = Dwarf(name: "pif")
//var persotest2 = Wizard(name: "paf")
//var persotest3 = Warrior(name: "pouf")
//
//var persotestP = Dwarf(name: "riri")
//var persotestP1 = Wizard(name: "fifi")
//var persotestP2 = Warrior(name: "loulou")
//
//persos.append(persotest1)
//persos.append(persotest2)
//persos.append(persotest3)
//
//persos2.append(persotestP)
//persos2.append(persotestP1)
//persos2.append(persotestP2)
//
//
//var player1 = Player(name : "Player1" , fighters : persos)
//var player2 = Player(name : "Player2" , fighters : persos2)
//
//
//
//

//// instance of the 2 PLAYERS with the NAME and the TEAM FIGHTER    !!!   MANUAL FILLING   !!!!

var teamfighter1 = [Character]() // team of the fighter 1
var teamfighter2 = [Character]()// team   of the fighter 2

var perso : Character
var nameOfPlayer1 = playerName() // name of player 1

// team of the fighter 1 filling
for _ in 0..<3
{
    perso = createFighter(arrayOfFighter: arrayOfFighter)
    teamfighter1.append(perso)
    arrayOfFighter.append(perso.name)
}
var nameOfPlayer2 = playerName()  // name of player 2

// team of the fighter 2 filling
for _ in 0..<3
{
    perso = createFighter(arrayOfFighter: arrayOfFighter)
    teamfighter2.append(perso)
    arrayOfFighter.append(perso.name)
}
// players take a name and a team fighter
var player1 = Player(name : nameOfPlayer1 , fighters : teamfighter1)
var player2 = Player(name : nameOfPlayer2 , fighters : teamfighter2)

// Summary of player 1
print("the name of the player 1 is : \(player1.name) the fighter are :")
player1.getfighters()


// Summary of player 2
print("the name of the player 2 is : \(player2.name) the fighter are :")
player2.getfighters()


print("//////////////////////////////////////////////////////////////////////")
print("///////////////////NOW TAKE PLACE TO THE FIGHT////////////////////////")
print("////////////////////////////////////////////////////////////////////// ")

// choose the Character your team
func isDead(currentFighter : Int, currentPlayer : Player) -> Bool
{
    let fighterOfCurrentPlayer = currentPlayer.getFighter(fighter : currentFighter)
    let isdead = fighterOfCurrentPlayer.beDead
    return isdead
}

func characterChoice(currentPlayer : Player) -> Int
{
    var fighterNumber : Int = 0
    var i = false
    
    while i == false //if the character is dead or the readline don't work correctly, we loop
    {
        if let choice = readLine(){ // unwrapping the readline
            
            i = true
            if (choice == "1" || choice == "2"   || choice == "3" )
            {
// the goal here is to know if the selected character is dead or not
                if let unwrappedintchoice = Int(choice) // unwrapping the choice inted
                {

// if isDead is true (player is dead )
                    if isDead(currentFighter : unwrappedintchoice - 1, currentPlayer : currentPlayer)
                    {
                        i = false
                        print("the character is dead , please select a another character")
                    }
                }
            }
            switch choice {
            case "1":
                fighterNumber = 0
            case "2":
                fighterNumber = 1
            case "3":
                fighterNumber = 2
            default:
                i = false
                print("I don't understand please put '1' or '2' or '3' ")
                
            }
        }
    }
//    return the character
    return fighterNumber
}



// if all the member are dead return true
func areDead(teamfighter : Player) -> Bool
{
    if teamfighter.fighters[0].beDead == true && teamfighter.fighters[1].beDead == true && teamfighter.fighters[2].beDead == true
    {
        return true
    }
    else {
        return false
    }
}
func wizardSpell(currentFighter : Character ,currentTarget : Character )
{
    
    currentFighter.heal(character : currentTarget) //heal
}


var round = 0
// while player one or player two has character, the game is running
while areDead(teamfighter : player2) == false && areDead(teamfighter : player1) == false
{
    

    if round % 2 == 0 // to alternate player1 /player 2 , here player 1 play
    {
        print("\(player1.name) select your character : ")
        player1.getfighters()// print all player1's  team
        
        let fighterNumber = characterChoice(currentPlayer : player1) //choose my character
        let fighterPlayer1 = player1.getFighter(fighter : fighterNumber) //load my character

        let newWepon = Weapon() //create a new weapon
        fighterPlayer1.receiveWeapon(weapon : newWepon) // give the weapon to player one
        
// if the character chosen is a Wizard , we will select a allie , and heal him
        if fighterPlayer1.type == "Wizard"
        {
            print("\(player1.name) Select who do you want to heal ? ")
            player1.getfighters()
            let targetNumber = characterChoice(currentPlayer : player1) //choose the allie
            let targetAllie = player1.getFighter(fighter : targetNumber)// load the allie

            wizardSpell(currentFighter : fighterPlayer1 ,currentTarget : targetAllie ) //heal him
        }
        else
        {
            print("\(player1.name) Select your target ?")
            player2.getfighters()

            let targetNumber = characterChoice(currentPlayer : player2) // choose the target
            let targetPlayer1 = player2.getFighter(fighter : targetNumber) //load the target
            
            fighterPlayer1.attack(character : targetPlayer1) //attack
            targetPlayer1.checkStatus() // if poison target take damage from poison
        }
        
    }
    else // player2 play
    {
        print("\(player2.name) select your character : ")
        player2.getfighters()
        let fighterNumber2 = characterChoice(currentPlayer : player2)
        let fighterPlayer2 = player2.getFighter(fighter : fighterNumber2)
        let newWepon = Weapon()
        fighterPlayer2.receiveWeapon(weapon : newWepon)
        
        if fighterPlayer2.type == "Wizard"
        {
            print("\(player2.name) Select who do you want to heal ?")
            player2.getfighters()
            let targetNumber2 = characterChoice(currentPlayer : player2) //choose the allie
            let targetAllie2 = player2.getFighter(fighter : targetNumber2)
            
            wizardSpell(currentFighter : fighterPlayer2 ,currentTarget : targetAllie2 )
        }
        else
        {
            print("\(player2.name) Select your target ?")
            player1.getfighters()
            let targetNumber2 = characterChoice(currentPlayer : player1)
            let targetPlayer2 = player1.getFighter(fighter : targetNumber2)
            
            fighterPlayer2.attack(character : targetPlayer2)
            targetPlayer2.checkStatus()
        }
    }
    round += 1
}
// end of the game
if areDead(teamfighter : player2) == true
{
    print("//////////////////////////////////////////////////////////////////////")
    print("//////////////////player1 win in \(round + 1) round ////////////////////////////")
    print("//////////////////////////////////////////////////////////////////////\n")
}
else{
    print("//////////////////////////////////////////////////////////////////////")
    print("/////////////player 2 win in \(round + 1) round/////////////////////////////////")
    print("//////////////////////////////////////////////////////////////////////\n")
}



