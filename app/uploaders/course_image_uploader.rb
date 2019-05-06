class CourseImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  def store_dir

    # file name saved on the model. It is in the form:
    # filehash-randomstring.extension, see below...
    filename = model.send(:"#{mounted_as}_identifier")

    "/home/imber/images/#{filename[0..1]}/#{filename[3..4]}"
  end

  def filename
    if original_filename

      existing = model.send(:"#{mounted_as}_identifier")

      # reuse the existing file name from the model if present.
      # otherwise, generate a new one (and cache it in an instance variable)
      @generated_filename = "#{sha1_for file}-#{SecureRandom.hex(4)}.#{file.extension}"
    end
  end

  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  private

  def sha1_for file
    Digest::SHA1.hexdigest file.read
  end
end
