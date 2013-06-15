class TwitterController < Rubot::Controller
  listener :matches => %r{http(s?)://(.*)twitter\.com\/(\w+)\/status(es)?\/(\d+)} do
    reply TwitterUtil.find_by_status(matches[5])
  end
end
