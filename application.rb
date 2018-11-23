$master_password = nil

module Utils
  # Returns a String of HTML
  def layout(title, body)
    <<-EOHTML
      <!DOCTYPE html>
      <html>
        <head>
          <title>#{title}</title>
        </head>
        <body>
          #{body}
        </body>
      </html>
    EOHTML
  end
end

class Application
  puts Process.pid
  include Utils


  def call(env)
    if $master_password.nil?
      html = <<-EOHTML
          <form method="POST" action="/password">
            <input name="password" type="password" />
            <input type="submit" />
          </form>
        EOHTML
    else
      html = <<-EOHTML
          <h1>Master password</h1>
          <p>#{$master_password}</p>
        EOHTML
    end
    [ 200, { 'Content-Type' => 'text/html' }, [
      layout("Hello, admin", html )
    ] ]
  end
end

class Password
  include Utils

  def call(env)
    params = Rack::Request.new(env).params
    $master_password = params["password"]
    [ 302, { 'Location' => '/' }, '']
  end
end

