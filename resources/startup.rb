class Startup < Rubot::WebResource
  get :random, "http://nonstartr.com/" do |doc|
    doc.css("#pitch").strip.text
  end
end
