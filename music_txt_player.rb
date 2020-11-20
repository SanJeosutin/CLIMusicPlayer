require './input_functions'
################### CLASSES ###################
#module Genre
#    POP, KPOP, EDM, ROCK, JAZZ, CLASSICAL, BLUES, FUNK, SOUL, LOFI  = *1..10
#end
GENRE_NAME = ['Null', 'POP', 'KPOP', 'EDM', 'ROCK', 'JAZZ', 'CLASSICAL', 'BLUES', 'FUNK', 'SOUL', 'LOFI'] #PRINT OUT THE OPTIONS

class Album
	attr_accessor :title, :artist, :genre, :tracks
	def initialize (title, artist, genre, tracks)
	  @title = title
	  @artist = artist
	  @genre = genre
	  @tracks = tracks
	end
end
  
class Track
	attr_accessor :name, :location
	def initialize (name, location)
	  @name = name
	  @location = location
	end
end
################### CLASSES ###################



################### miscellaneous ###################
#Displaying Title and clearing the console everytime it called
#Pre'much like a header for a website
def menu_title()
    puts "\e[H\e[2J" #Clear console ##COMMENT THIS LINE FOR DEBUGING
    puts "================="
    puts "Text Music Player"
    puts "================="
end
############## miscellaneous ###################




################### Printing Album Info ###################
def print_track(track)
    puts "Title: " + track.name
    puts "Location: " + track.location
end

def print_tracks(tracks)
    index = 0
    while (index < tracks.length)
        puts "Track No: " + index.to_s
        print_track(tracks[index])
        index += 1
    end
end

def read_tracks(file_album)
    tracks = Array.new()
    count = file_album.gets().to_i
    index = 0

    while (index < count)
        track = read_track(file_album)
        tracks << track
        index += 1
    end
    return tracks
end

def read_track(file_album)
    track_title = file_album.gets()
    track_location = file_album.gets()
    track = Track.new(track_title, track_location)
    return track
end

def read_album(file_album)
    albums = Array.new()
    album_amount = file_album.gets().to_i
    index = 0
    while (index < album_amount)
        album_title = file_album.gets()
        album_artist = file_album.gets()
        album_genre = file_album.gets()
        tracks = read_tracks(file_album)
        index += 1
        album = Album.new(album_title, album_artist, album_genre, tracks)
        albums << album
    end
    #puts "1\n"
    #print albums
    return albums
end

def print_album(album)
    puts "========ALBUM======="
    puts "Title: " + album.title.to_s
    puts "Artist: " + album.artist.to_s
    puts "Genre: " + album.genre.to_s
    puts "=======TRACKS======="
    print_tracks(album.tracks)
end

def print_all_content(albums)
    #print albums

    count = albums.length
    index = 0
    while (index < count)
        puts "\nAlbum No: " + index.to_s + "\n"
        print_album(albums[index])
        index += 1
    end
    read_string("Press any key to continue..")
end
################### Printing Album Info ###################

def albums_genre(albums)
    file_genre = Array.new()
    i = 0
    while (i < albums.length)
        file_genre << albums[i].genre.chomp
        i += 1
    end
    return file_genre

end

################### Search by Genre ###################
def search_genre_from_file(album_genres, user_choice, file_album)
    index = 0
    while (index < album_genres.length)
        if(album_genres[index] == user_choice + "\n")
            genre_match = album_genres[index]            

            #READ THE FILE ON ALBUM GENRE, THEN COMPARE IT WITH THE genre_match
            #THEN READ THE NUMBER OF TRACKS THAT ARE STORED INSIDE THE ALBUM
            #PRINT THEM OUT (IF THERE'S 2 OR MORE OF THE SAME GENRE, PRINT THEM
            #ALL OUT)
            search_genre(file_album, genre_match)
        end
        index += 1
    end
end

def search_genre(albums, genre_match)
    index = 0
    while (index < albums.length)
        if(albums[index].genre == genre_match)#CHECK IF GENRE MATCHES WITH GENRE INSIDE AN ARRAY
            print_album(albums[index])
        end
        index += 1
    end
end

def genre_exist_on_file(album_genres, file_album)
    puts "Here's all the genre from the current file: "
    album_genres = album_genres.uniq
    index = 0

    while (index < album_genres.length)
        puts "- " + album_genres[index]
        index += 1
    end
    finished = false
    begin
        #print file_album
        #print album_genres #UN-COMMENT THIS LINE TO SEE THE ARRAY STORED IN album_genres
        user_choice = read_string("Which genre would you like to select: ").upcase().chomp
        menu_title()
        if (GENRE_NAME.include? user_choice)
            search_genre_from_file(album_genres, user_choice, file_album)
            finished = true
        else
            puts "Please try again.."
        end
    end until finished
    read_string "Press any key to continue.."
end

def get_file_genre(file_album)
    album_genres = Array.new()
    count = file_album.length
    i = 0

    while (i < count)
        album_genres << file_album[i].genre
        i += 1
    end
   genre_exist_on_file(album_genres, file_album)
end
################### Search by Genre ###################
def init_read_album_file(file_current)
    if (File.exist?(file_current))
        file_read = File.new(file_current, "r")
        albums = read_album(file_read)
        file_read.close()
        puts file_current + " has been load.\nReturning you to main menu."
    else
        read_string"Cannot find the requested file.\nPlease try again.."
    end
    return albums
end
################### Main Menu Functions ###################
                    ####1ST CHOICE####
def read_album_file()
    menu_title()
    puts "> MAIN MENU | 1.Read Album\n================="
    user_input = read_string("Please enter album file name:")
    albums = init_read_album_file(user_input)
    sleep(1)
    return albums
end
                    ####2ND CHOICE####
def display_albums(albums)
    finished = false
    begin 
        menu_title()
        puts "> MAIN MENU | 2.Display Album\n================="
        user_choice = read_integer_in_range("Would you like to see all the album or search by genre?\n1. Show all album\n2. Search by genre \n3. Back", 1, 3)
        case user_choice
        when 1
            menu_title()
            puts "> MAIN MENU | 2.Display Album > 1.Show all album\n================="
            puts "Showing all album"
            print_all_content(albums)
        when 2
            menu_title()
            index = 1
            puts "> MAIN MENU | 2.Display Album > 2.Search by Genre\n================="
            get_file_genre(albums)
        when 3
            finished = true
        else
            puts "Please enter a valid option"
        end
    end until finished
end
                    ####3RD CHOICE####
def found_album(user_choice, file_album)
    index = 0
	found_entry = -1
    while (index < file_album.length)
		if(index == user_choice)
			found_entry = index
		end
		index += 1
	end
  return found_entry
end

def show_album_list(file_album)
    index = 0
    while (index < file_album.length)
        album_title = file_album[index].title.chomp
        album_artist = file_album[index].artist.chomp
        puts index.to_s + ". " + album_title.to_s + " by: " + album_artist.to_s
        index += 1
    end
    return index
end

def play_from_album(file_album)
    menu_title()
    finished = false
    puts "> MAIN MENU | 3.Select Album\n================="
    index = show_album_list(file_album)
    user_choice = read_integer_in_range("Please select an album to play: ", 0 ,index)
    found = found_album(user_choice, file_album)
    
    index = 0
    album_current = file_album[found]
    menu_title()
    while (index < album_current.tracks.length)
        puts index.to_s + ". " + album_current.tracks[index].name.to_s
        index += 1
    end
    user_choice = read_integer_in_range("Please select track to play: ", 0 ,album_current.tracks.length - 1)
    menu_title()

    puts "Now playing...\n" + album_current.tracks[user_choice].name.chomp.to_s + " by: " + album_current.artist.chomp.to_s
    sleep(1.5)
end

def edit_album(albums)
    menu_title()
    finished = false
    puts "> MAIN MENU | 4.Update Album\n================="
    puts "Which album would you like to edit: "
    index = show_album_list(albums)
    user_choice = read_integer_in_range("Please select an album to edit: ", 0 ,index)
    found = found_album(user_choice, albums)

    index = 0
    album_current = albums[found]

    menu_title()

    puts "What would you like to edit: "
    user_choice = read_integer_in_range("1.Album Title\n2.Album Genre\n3.Back", 1, 3)
    begin
        case user_choice
        when 1
            puts "Editing Album Title for " + album_current.title.to_s
            user_input = read_string("Please enter new album name: ")
            album_current.title = user_input
            finished = true
        when 2
            puts "Editing Album Genre for " + album_current.title.to_s
            index = 1

            while(index < GENRE_NAME.length)#PRINT OUT THE OPTIONS FOR USER TO SELECT WHICH GENRE THEY WANTED TO CHANGE
                puts index.to_s + ". " + GENRE_NAME[index].to_s 
                index += 1
            end
            user_input = read_integer_in_range("Please select new album genre: ", 1, GENRE_NAME.length)
            user_input = GENRE_NAME[user_input]
            album_current.genre = user_input
            finished = true
        when 3
            puts "Returning you to main menu.\n Please wait"
            sleep(1)
            finished = true
        end
    end until finished
    #WIP
end                 
                     
                     
def main
    albums = Array.new()
    finished = false
    begin
    menu_title()
        puts "> MAIN MENU\n================="
        puts "Please choose the following"
        user_choice = read_integer_in_range("1. Read in album\n2. Display album\n3. Select album\n4. Update existing album\n5. exit", 1, 5)

        case user_choice
        when 1
            albums = read_album_file()
        when 2
            if(albums.length == 0)
                read_string "Please read the file 1st"
            else
            display_albums(albums)
            end
        when 3
            if(albums.length == 0)
                read_string "Please read the file 1st"
            else
                play_from_album(albums)
            end
        when 4
            if(albums.length == 0)
                read_string "Please read the file 1st"
            else
                edit_album(albums)
            end
        when 5
            read_string "Exiting the program\nGoodbye."
            finished = true
        else
            puts "Please enter a valid option"
        end
    end until finished
end
################### Main Menu Functions ###################

main()