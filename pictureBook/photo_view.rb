# Встроенный класс виджет
class PhotoView < FXImageFrame
  MAX_WIDTH = 400
  MAX_HEIGHT = 400

  def initialize(p, photo)
    super(p, nil)
    load_image(photo.path)
    scale_to_thumbnail
  end

  def scaled_width(width)
    [width, MAX_WIDTH].min
    [width, MAX_WIDTH].min
  end

  def scaled_height(height)
    [height, MAX_HEIGHT].min
  end

  # изменить размер изображения во время загрузки
  def scale_to_thumbnail
    p image.width
    p image.height
    aspect_ratio = image.width.to_f/image.height
    p aspect_ratio
    if image.width > image.height
      # scale встроенный метод позволяющий настраивать размеры картинок
      image.scale(
        scaled_width(image.width),
        scaled_width(image.width)/aspect_ratio,
        1
      )
    else
      image.scale(
        aspect_ratio*scaled_height(image.height),
        scaled_height(image.height),
        1
      )
    end
  end

  # открываем файл для чтения флаг r и то что он бинарный флаг b
  # open автоматически закрывает сокет после работы с ним
  # каждый класс, представляющий виджет FXRuby, наследует метод экземпляра app()
  def load_image(path)
    File.open(path, "rb" ) do |io|
      self.image = FXJPGImage.new(app, io.read)
    end
  end
end