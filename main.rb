require 'sinatra'
require 'rghost'
require 'zipruby'
require 'zxing'
require 'mini_magick'
require 'securerandom'
require 'fileutils'
require 'tempfile'


class Image
    attr_reader :path
    def initialize(path);
      @path = path
    end
  end
  

get '/' do 
  send_file File.join(settings.public_folder, 'index.html')
end  

post '/crop' do
       
  attach_path = nil  

  unless params[:file]
    content_type :json
    return [400, {msg: "File is not provided"}.to_json]    
  end  
    
  attach_path = params[:file][:tempfile].path
  
  uuid = SecureRandom.uuid
  
image = MiniMagick::Image.open(attach_path)

image.format "png"
# image.flatten
# image.fuzz '1%'
# image.trim '+repage'
# image.gravity 'south'
# image.frame '0x50'
# image.mattecolor 'white'
# image.annotate "+0+25"

image.rotate "-180"
image.crop "100%x25%+0+0"
image.rotate "-180"
image.resize "1280x720"
image.write "output/#{uuid}.png"
send_file(image.path, :filename => "#{params[:file][:filename].split('.')[0]}.png", :type => "image/png")
end

post '/decode_batch' do
  attach_path = nil  

  unless params[:file]
    content_type :json
    return [400, {msg: "File is not provided"}.to_json]    
  end  
    
  attach_path = params[:file][:tempfile].path
  extracted_files = []

  Zip::Archive.open(attach_path) do |ar|
    n = ar.num_files # number of entries
  
    n.times do |i|
      entry_name = ar.get_name(i) # get entry name from archive
  
      # open entry
      ar.fopen(entry_name) do |f| # or ar.fopen(i) do |f|
        
        name = f.name           # name of the file
        size = f.size           # size of file (uncompressed)
        comp_size = f.comp_size # size of file (compressed)
  
        content = f.read # read entry content
        
        tmpfile = File.new("./extracted/#{f.name}", 'w')
        tmpfile.puts(content)
            
        tmpfile.close

        extracted_files << tmpfile.path

      end
    end
  end

  codes = []

  extracted_files.each{|path|
    decoded = ZXing.decode Image.new(path)

    codes << {filename: path.split('./extracted/')[1], code: decoded}
    
    begin
      File.open(path, 'r') do |f|
        # do something with file
        File.delete(f)
      end
    rescue Errno::ENOENT

    end
  }
  
  content_type :json
  [200, {codes: codes}.to_json]

end

post '/decode' do     
    content_type :json
      
    attach_path = nil  
  
    unless params[:file]
      return [400, {msg: "File is not provided"}.to_json]    
    end   
    
    begin
      attach_path = params[:file][:tempfile].path

      decoded = ZXing.decode! Image.new(attach_path)
       
      [200, {code: decoded}.to_json]
    rescue ZXing::ReaderException => exception
      [200, {msg: "No Code detected"}.to_json]
    end
end

post '/pdf2png_cropped' do 
  attach_path = nil  

  unless params[:file]
    content_type :json
    return [400, {msg: "File is not provided"}.to_json]    
  end  
    
  attach_path = params[:file][:tempfile].path
  preview = RGhost::Convert.new(attach_path)
  
  cfile = preview.to :png, :multipage => true, :resolution => 300  #returns an Array of Files

  cropped_files = []
  cfile.each do |file| 
    
    uuid = SecureRandom.uuid
  
      image = MiniMagick::Image.open(file)

      image.format "png"

      image.rotate "-180"
      image.crop "100%x25%+0+0"
      image.rotate "-180"
      image.resize "1280x720"
      image.write "output/#{uuid}.png" 
    
      cropped_files << "output/#{uuid}.png"
  end   

  zipfile = Tempfile.new('my.zip')
  Zip::Archive.open(zipfile.path, Zip::CREATE) do |zip|
 
    cropped_files.each do |file| 
      zip.add_file file 
    end     
  end

    send_file(zipfile.path, :filename => "#{params[:file][:filename].split('.')[0]}_cropped.zip", :type => "application/zip")

end

post '/pdf2png' do  
      
  attach_path = nil  

  unless params[:file]
    content_type :json
    return [400, {msg: "File is not provided"}.to_json]    
  end  
    
  attach_path = params[:file][:tempfile].path
  preview = RGhost::Convert.new(attach_path)
  
  cfile = preview.to :png, :multipage => true, :resolution => 300  #returns an Array of Files

  zipfile = Tempfile.new('my.zip')
  Zip::Archive.open(zipfile.path, Zip::CREATE) do |zip|
 
    cfile.each do |file| 
      zip.add_file file 
    end     
 
end    

    send_file(zipfile.path, :filename => "#{params[:file][:filename].split('.')[0]}.zip", :type => "application/zip")

end