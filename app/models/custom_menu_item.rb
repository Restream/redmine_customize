class CustomMenuItem < Hashie::Dash
  property :body
  property :url
  property :title

  def initialize(*args)
    options = args.extract_options!
    options[:body] = args[0] if args.length > 0
    options[:url] = args[1] if args.length > 1
    options[:title] = args[2] if args.length > 2
    super(options)
  end

  def to_s
    [body, url, title].compact.join(',')
  end
end
