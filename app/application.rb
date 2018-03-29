require 'pry'
class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []
  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      path = /cart/
      resp.write cart_list(path)
    elsif req.path.match(/add/)
      if @@items.include?(req.params["item"])
        @@cart << req.params["item"]
        resp.write "added #{req.params["item"]}"
      elsif !@@items.include?(req.params["item"])
        resp.write "We don't have that item"
      end
      #binding.pry
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end

  def cart_list(cart_path)
    if @@cart.size == 0
      return "Your cart is empty"
    elsif @@cart.size > 0
      @@cart.each do |item|
         "#{item}".join("\n")
      end
    end
  end
end
