require_relative 'photo_view'

class AlbumView < FXScrollWindow # FXMatrix - другой компановщик
  attr_reader :album

  def initialize(p, album)
    # binding.pry
    # LAYOUT_FILL|MATRIX_BY_COLUMNS
    # LAYOUT_FILL, которое говорит матрице быть жадной и занимать столько места, сколько возможно
    # MATRIX_BY_COLUMNS, фиксировать число столбцов и позволить числу строк изменяться
    super(p, :opts => LAYOUT_FILL)
    @album = album
    FXMatrix.new(self, :opts => LAYOUT_FILL|MATRIX_BY_COLUMNS)
    @album.each_photo { |photo| add_photo(photo) }
  end

  def add_photo(photo)
    PhotoView.new(contentWindow, photo)
  end

  #Всякий раз, когда размер окна изменяется FOX гарантирует, что метод layout() будет вызван, чтобы он мог
  # обновить позиции и размеры его дочерних окон (подробно это рассмотрено на. Мы собираемся использовать это, чтобы
  # повторно вычислить число столбцов для матрицы прежде, чем будет выполнено расположение
  def layout
    contentWindow.numColumns = [width/PhotoView::MAX_WIDTH, 1].max
    super
  end
end