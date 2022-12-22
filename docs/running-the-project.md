# Running the project
This section lists commands to run the various parts of the project.<br>

All commands should be used from the projects source directory.

???+ warning "Before Running" 

    Make sure you have a valid `.env` file in the projects source directory before running. This file contains all the secret keys and is not included in the repository.

### Flutter App
`make flutter-run` - run app (debug mode)<br>

### Web Application
`make next-dev` - start in development mode<br>
`make next-production` - start in production mode<br>

### Documentation (requires python)
`make pip-install` - install python requirements for documentation server<br>
`make docs` - starts local documentation server<br>
