require 'sinatra'
require 'rghost'
require 'zipruby'
require 'zxing'
require "mini_magick"



class Image
    attr_reader :path
    def initialize(path);
      @path = path
    end
  end

get '/' do 
  'Hello World!'
end  

get '/crop' do
  
image = MiniMagick::Image.open("data/boleto20220510-51214-e07e6a.png")
image.path #=> "/var/folders/k7/6zx6dx6x7ys3rv3srh0nyfj00000gn/T/magick20140921-75881-1yho3zc.jpg"
image.format "png"
image.resize "1920x1080"
image.rotate "-180"
image.crop "100%x25%+0+0"
image.rotate "-180"

image.trim '+repage'


image.write "output.png"
end

post '/decode' do     

    attach_path = params[:file][:tempfile].path

    decoded = ZXing.decode! Image.new(attach_path)
    p decoded    
end

post '/pdf2png' do
    
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