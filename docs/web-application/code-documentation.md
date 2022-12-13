# Code Documentation

## Uploading Scripts
Scripts uploaded to the web application are saved to disk so that they can be used when sessions are started in the future and have their meta data save to the database. But before doing so a validator checks the script to make sure that the script is valid. It checks if the 'main' function is present and if it uses the correct amount of paramaters. If the validator detects a problem a message is send to the web application informing the user what's wrong with the uploaded script.
![Validator error message](images/validator-error-message.png)
In this case the 'main' function is messing it's third parameter.

## Handeling Sessions
When sessions are started in the app, they connect to a websocket on the server. Every bit of data comming of the sensors is directly send to the webserver over this websocket. Websockets are use because they create a continuous connection between the app and the server, reducing the overhead per send message and therefor allowing for a high number of messages to be send back and forth. This is very important because the sensors will be sending data up to hundreds of times per second.<br>

## Handeling Scripts
New sessions, started by connecting to the websocket, specify which scripts to run for that session. For each of these scripts a process is started .... 
-- more to come --