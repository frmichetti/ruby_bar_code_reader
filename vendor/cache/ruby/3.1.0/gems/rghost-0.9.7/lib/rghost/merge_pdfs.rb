class RGhost::MergePdfs
  attr_reader :error, :errors
  DEFAULT_OPTIONS = { :convert =>  true }

  def self.merge(pdfs, options={})
    rge = RGhost::Engine.new(pdfs,DEFAULT_OPTIONS.merge(options))
    out = rge.render(:pdf)
    @error = rge.error
    @errors = rge.errors
    out
  end
end