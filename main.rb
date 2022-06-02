require 'sinatra'
require 'rghost'
require 'zipruby'
require 'zxing'
require 'mini_magick'
require 'securerandom'




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

image.rotate "-180"
image.crop "100%x25%+0+0"
image.rotate "-180"
image.resize "1280x720"
image.write "output/#{uuid}.png"
send_file(image.path, :filename => "#{params[:file][:filename].split('.')[0]}.png", :type => "image/png")
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