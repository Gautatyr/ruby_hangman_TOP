#Author: Hugo Delautre
#29/05/2022
#Desc: Create a hanman in the console that load words from a file and 
#can be serialized to save and load an ongoing game

require "json"

def secret_word_randomizer 
  dictionnary = File.read("google-10000-english-no-swears.txt").split(" ")
  index = rand(dictionnary.length)

  while dictionnary[index].length < 5 || dictionnary[index].length > 12
    index = rand(dictionnary.length)
  end

  dictionnary[index]
end

def choose_letter
  puts "Choose a letter"
  letter = gets.chomp.downcase
  if letter.length != 1
    puts `clear`
    puts "Incorrect format letter"
    choose_letter
  else 
    letter
  end
end

def verify_guess(letter, guessed_word, secret_word)
  indexes = secret_word.each_index.select{|i| secret_word[i] == letter} 
  indexes.each do |index|
    guessed_word[index] = letter
  end
  return guessed_word
end

def save?
  answer = " "
  while answer != "y" && answer != "n"
    puts "\n \nDo you want to save? [Y/N]"
    answer = gets.chomp
    answer = answer.downcase
    if answer == "y"
      return true 
    elsif answer == "n"
      return false
    else 
      puts "Please use Y to save or N to continue playing"
    end
  end
end

def saving (secret_word, guessed_word, attempt_left, alphabet)
  temp_hash = {
    "secret_word" => secret_word,
    "guessed_word" => guessed_word,
    "attempt_left" => attempt_left,
    "alphabet" => alphabet
  }
  File.open("save.json", "w") do |f|
    f.write(temp_hash.to_json)
  end
end

def game(init)
  #Initialisation
  if init == 0
  puts "Let the game begins!"
  secret_word = secret_word_randomizer.split("")
  guessed_word = Array.new(secret_word.length)
  guessed_word.map! {|word|
    word = "_"
  }
  alphabet = ("a".."z").to_a
  do_you_save = false
  attempt_left = 7
  win = 0
  init = 1
  end
  
  #load save
  if init == 2
    save =""
    File.open("save.json") do |f|
      save = JSON.parse(f.read)
    end
    secret_word = save["secret_word"]
    guessed_word = save["guessed_word"]
    attempt_left = save["attempt_left"]
    alphabet = save["alphabet"]
    win = 0
  end

  #Display
  puts "Attempt left: #{attempt_left} \n"
      puts guessed_word.join(" ")
      puts "\n"
      puts alphabet.join("-")
      puts "\n"
  
  #Game
  while attempt_left > 0 && win == 0
    if init == 2
      do_you_save = false
      init = 1
    end
    if do_you_save == false
      chosen_letter = choose_letter
      alphabet.delete(chosen_letter)
      if secret_word.include? chosen_letter
        guessed_word = verify_guess(chosen_letter, guessed_word, secret_word)
      else 
        attempt_left -= 1
      end
      if guessed_word == secret_word
        win = 1
      end
      puts `clear`
      puts "Attempt left: #{attempt_left} \n"
      puts guessed_word.join(" ")
      puts "\n"
      puts alphabet.join("-")
      puts "\n"
    elsif do_you_save == true
      puts `clear`
      saving(secret_word, guessed_word, attempt_left, alphabet)
      begin
        exit
      rescue => exception
        puts "Goodbye !"
      end
    end
    do_you_save = save?
  end

  if win == 1
    puts "Good job!"
  elsif attempt_left == 0
    puts "Bad luck! The word was: #{secret_word.join(" ")}"
  else
    puts "Error with winning or loosing condition"
  end
end

def load?
  answer = " "
  while answer != "y" && answer != "n"
    puts "do you want to load your save? [Y/N]"
    answer = gets.chomp.downcase
  end
  if answer == "y"
    return true
  elsif answer == "n"
    return false
  else   
    put "Error with the load? def"
  end
end

def start
  answer = load?
  if answer == true
    puts `clear`
    game(2)
  elsif answer == false
    puts `clear`
    game(0)
  end
end
answer = " "



start



