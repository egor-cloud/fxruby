require_relative 'ClientClasses/album_list'

#Fxlist позволяет создавать навигацию
class AlbumListView < FXList
  WIDTH = 100
  attr_accessor :album_list

  def initialize(p, opts)
    super(p, {:opts => opts, :width => WIDTH})
  end

  def to_s
    value.to_s
  end

  def inspect
    "#{self}"
  end

  def album_list=(albums)
    @album_list = albums
    @album_list.each_album do |album|
      add_album(album)
    end
  end

  def switcher=(sw)
    @switcher = sw
  end

  def add_album(album)
    appendItem(album.title)
    AlbumView.new(@switcher, album)
  end

end