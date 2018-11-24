$master_password = nil

begin
  $conn = PG.connect(dbname: 'rahab', user: 'rahab', password: 'rahab', port: '5433')
rescue PG::Error => e
  puts e.message
end



class Table

  @@connection = $conn

  def self.all(&block)
    @@connection.exec("SELECT * FROM users", &block)
  end
end

module Utils
  # Returns a String of HTML
  def layout(title, body)
    <<-EOHTML
      <!DOCTYPE html>
      <html>
        <head>
          <meta http-equiv="content-type" content="text/html; charset=utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1" />
          <meta name="HandheldFriendly" content="true" />
          <title>#{title}</title>
          <script src="/js/script.js"></script>
          <link rel="stylesheet" href="/css/styles.css" />
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
          <h1>Enter the master password of this instance</h1>
          <p>This needs to be entered every time the application loads:</p>
          <form method="POST" action="/password">
            <label for="pass">Password</label>
            <br/>
            <input name="password" type="password" id="pass" />
            <input type="submit" />
          </form>
          <p>If you don't know what is this password, please contact the system administrator.</p>
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

class Logout
  include Utils

  def call(env)
    $master_password = nil
    [ 302, { 'Location' => '/' }, '']
  end
end
