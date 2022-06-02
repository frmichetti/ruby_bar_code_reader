require 'sinatra'
require 'rghost'
require 'zipruby'
require 'zxing'

class Image
    attr_reader :path
    def initialize(path);
      @path = path
    end
  end

get '/' do
  'Hello World'  
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