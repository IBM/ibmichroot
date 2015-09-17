# python -m SimpleHTTPServer
# -- or using a program --
# python -m simple_web_server_python 8080
import sys
import SimpleHTTPServer
import SocketServer
    
if sys.argv[1:]:
    port = int(sys.argv[1])
else:
    port = 8000
   
Handler = SimpleHTTPServer.SimpleHTTPRequestHandler
httpd = SocketServer.TCPServer(("", port), Handler)
    
print "Serving at port", port
httpd.serve_forever()

