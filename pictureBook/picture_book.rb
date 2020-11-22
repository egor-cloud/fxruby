require_relative 'ClientClasses/album'
require_relative 'ClientClasses/photo'
require_relative 'album_view'
require_relative 'album_list_view'
require 'yaml'

# встроенный класс окна приложения. Вся навигация и панели инициализируются внутри конструктора
class PictureBook < FXMainWindow

  def initialize(app)
    super(app, "Picture Book" , :width => 800, :height => 800)
    add_menu_bar
    # Наглядный пример использования исключений при дессериализации фотографий если они существуют, а если их нет??
    begin
      @album_list = YAML.load_file("picturebook.yml" )
    rescue NoMethodError
      #...
    rescue
      @album_list = AlbumList.new
      @album_list.add_album(Album.new("My Photos" ))
    end
    splitter = FXSplitter.new(self, :opts => SPLITTER_HORIZONTAL|LAYOUT_FILL)
    @album_list_view = AlbumListView.new(splitter, LAYOUT_FILL)
    @switcher = FXSwitcher.new(splitter, :opts => LAYOUT_FILL)
    # SEL_UPDATE для переключателя, мы говорим FOX как обновить состояние переключателя всякий раз, когда состояние
    # приложения изменяется, а именно идет переключение между альбомами.
    @switcher.connect(SEL_UPDATE) do
      @switcher.current = @album_list_view.currentItem
    end
    @album_list_view.switcher = @switcher
    @album_list_view.album_list = @album_list
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end

  def add_menu_bar
    # создание меню расположенного вверху LAYOUT_SIDE_TOP|LAYOUT_FILL_X
    menu_bar = FXMenuBar.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X)
    # создание дочернего меню
    file_menu = FXMenuPane.new(self)
    # меню заголовок состоящий из меню и подменю которое открывается при клике и включает в себя команды
    FXMenuTitle.new(menu_bar, "File" , :popupMenu => file_menu)

    # создание нового альбома
    new_album_command = FXMenuCommand.new(file_menu, "New Album..." )
    new_album_command.connect(SEL_COMMAND) do
      album_title = FXInputDialog.getString("My Album" , self, "New Album" , "Name:" )
      if album_title
        album = Album.new(album_title)
        @album_list.add_album(album)
        @album_list_view.add_album(album)
        AlbumView.new(@switcher, album)
      end
    end

    # добавление файла jpg
    import_cmd = FXMenuCommand.new(file_menu, "Import..." )
    import_cmd.connect(SEL_COMMAND) do
      # создать диалоговое окно, дочернее окно нашего окна
      dialog = FXFileDialog.new(self, "Import Photos" )
      # SELECTFILE_MULTIPLE - разрешить выбирать файлы
      dialog.selectMode = SELECTFILE_MULTIPLE
      dialog.patternList = ["JPEG Images (*.jpg, *.jpeg)" ]
      # Метод execute() для диалогового окна возвращает код завершения 0 или 1, в зависимости от того, щелкнул ли
      # пользователь Cancel, чтобы закрыть диалоговое окно или OK, чтобы принять выбранные файлы
      if dialog.execute != 0
        import_photos(dialog.filenames)
      end
    end
    exit_cmd = FXMenuCommand.new(file_menu, "Exit" )
    exit_cmd.connect(SEL_COMMAND) do
      store_album_list
      exit
    end
  end

  def current_album_view
    @switcher.childAtIndex(@switcher.current)
  end

  def current_album
    current_album_view.album
  end

  # Метод import_photos() выполняет итерации по именам файлов, собранным FXFileDialog и добавляет
  # фотографии для выбранного альбома
  def import_photos(filenames)
    filenames.each do |filename|
      photo = Photo.new(filename)
      current_album.add_photo(photo)
      current_album_view.add_photo(photo)
    end
    current_album_view.create
  end

  # сохранить содержание списка альбомов в файле
  def store_album_list
    File.open("picturebook.yml" , "w" ) do |io|
      io.write(YAML.dump(@album_list))
    end
  end

end
