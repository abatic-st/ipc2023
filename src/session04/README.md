Docker Install

docker run --rm -it --name ipc-rabbit -p 15672:15672 -p 5672:5672 -p 61613:61613 rabbitmq:3-management

Into Docker Console
rabbitmq-plugins list
rabbitmq-plugins enable rabbitmq_stomp


Open Explorer:
http://localhost:15672/


Another resources

https://stomp.github.io/stomp-specification-1.2.html

https://en.wikipedia.org/wiki/Streaming_Text_Oriented_Messaging_Protocol
https://github.com/search?q=stomp+language%3APascal+&type=repositories

https://activemq.apache.org/
https://www.rabbitmq.com/
https://hub.docker.com/_/rabbitmq
https://sourceforge.net/p/synalist/code/HEAD/tree/trunk/
https://blogs.embarcadero.com/working-example-code-of-using-stomp-in-your-application/
https://www.esegece.com/delphi/stomp
https://github.com/danieleteti/delphistompclient/tree/master

