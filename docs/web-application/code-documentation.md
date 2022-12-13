# Code Documentation

## Uploading Scripts
Scripts uploaded to the web application are saved to disk so that they can be used when sessions are started in the future and have their meta data save to the database. But before doing so a validator checks the script to make sure that the script is valid. It checks if the 'main' function is present and if it uses the correct amount of paramaters. If the validator detects a problem a message is send to the web application informing the user what's wrong with the uploaded script.
![Validator error message](/images/validator-error-message.png)
In this case the 'main' function is messing it's third parameter.

## Handeling Sessions
When sessions are started in the app, they connect to a websocket on the server. Every bit of data comming of the sensors is directly send to the webserver over this websocket.
