class Inventory
  attr_accessor :books

  def initialize
    @books = []
  end

  def write_to_files(mode)
      File.write("data.txt", @books, mode: mode){
        @books.each do |book|
          {
            title:book[:title],
            author:book[:author],
            isbn:book[:isbn],
            count: book[:count]
          }
        end
      }
  end

  def add_book(title, author, isbn)
    if( title == "" || author == "" || isbn == "")
      puts "Please enter all the fields"
      return
    end

    if( !title.is_a?(String) || !author.is_a?(String) || !isbn.is_a?(String) )
      puts "input must be string"
      return
    end

    @books.each do |book|
      if book[:isbn] == isbn
        book[:count] += 1

        book[:title] =title
        book[:author] = author

        write_to_files("w")
        return
      end
    end
    @books.push({
      title:title,
      author:author,
      isbn:isbn,
      count: 1
    })
    write_to_files("a")

  end

  def list_books()
    @books.each do |book|
      puts "Book details"
      puts "Title: #{book[:title]}\nAuthor: #{book[:author]}\nISBN: #{book[:isbn]}\nCount: #{book[:count]}"
    end
  end

  def remove_book(isbn)
    if isbn == ""
      puts "Please enter ISBN"
      return
    end

    book = @books.find{ |book| book[:isbn] == isbn }
    if book.nil?
      puts "Book not found"
      return
    end

    @books.delete_if{ |book| book[:isbn] == isbn }
    write_to_files("w",book[:count])
  end

  def sort_books()
    @books.sort_by! { |book| book[:isbn] }
    puts "sort books"
    list_books()
  end


  def search_books(query)
    @books.each do |book|
      if book[:title].include?(query) || book[:author].include?(query) || book[:isbn].include?(query)
        puts "Title: #{book[:title]}\nAuthor: #{book[:author]}\nISBN: #{book[:isbn]}\nCount: #{book[:count]}"
      end
    end
  end

end



inv = Inventory.new


flag = 0
while flag
  puts "1. Add book"
  puts "2. List books"
  puts "3. Remove book"
  puts "4. Sort books"
  puts "5. Search books"
  puts "6. Exit"
  puts "Enter choice: "
  choice = gets.to_i

  case choice
  when 1
    puts "Enter title: "
    title = gets
    puts "Enter author: "
    author = gets
    puts "Enter ISBN: "
    isbn = gets
    inv.add_book(title, author, isbn)
    puts "-------------------------------------------------------------"
  when 2
    inv.list_books()
    puts "-------------------------------------------------------------"
  when 3
    puts "Enter ISBN: "
    isbn = gets
    inv.remove_book(isbn)
    puts "-------------------------------------------------------------"
  when 4
    inv.sort_books()
    puts "-------------------------------------------------------------"
  when 5
    print "Enter search query: "
    query = gets
    inv.search_books(query)
    puts "-------------------------------------------------------------"
  when 6
    flag=1
    break
  end
end
