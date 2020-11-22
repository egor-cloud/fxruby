require 'fox16'
# require 'pry'

include Fox
Dir.glob("./pictureBook/*.rb").each { |file| require file }

if __FILE__ == $0
  # Пример передачи самого себя в блок
  FXApp.new do |app|
    PictureBook.new(app)
    app.create
    app.run
  end
end


# FXTable.new()
