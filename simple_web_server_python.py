import sys
if sys.version_info >= (3,0):
  # python3 -m http.server 8080
  # -- or using a program --
  # python3 -m simple_web_server_python 8080
  import http.server
  import socketserver
else:
  # python -m SimpleHTTPServer
  # -- or using a program --
  # python -m simple_web_server_python 8080
  import SimpleHTTPServer
  import SocketServer
    
if sys.argv[1:]:
    port = int(sys.argv[1])
else:
    port = 8000
   
if sys.version_info >= (3,0):
  Handler = http.server.SimpleHTTPRequestHandler
  httpd = socketserver.TCPServer(("", port), Handler)
else:
  Handler = SimpleHTTPServer.SimpleHTTPRequestHandler
  httpd = SocketServer.TCPServer(("", port), Handler)
    
print("Serving at port", port)
httpd.serve_forever()
