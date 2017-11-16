def main(device_id ,zip_filename)
  unless device_id > 0
    print "device_id is not determined."
    return
  end
  Picture.save_to_zip(device_id, "", nil, zip_filename)

end

# ruby zip-pictures.rb device_id path_zip
main(ARGV[0].to_i, ARGV[1])
