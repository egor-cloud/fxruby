class AlbumList
  def initialize
    @albums = []
  end

  def add_album(album)
    @albums << album
  end

  def remove_album(album)
    @albums.delete(album)
  end

  def each_album
    @albums.each { |album| yield album }
  end
end