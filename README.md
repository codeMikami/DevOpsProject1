
# DevOps Project 1
This project was made to develop my DevOps Skills.
It includes developing containerization skills and automating application builds.

The project was based on simple application with front-end and backend.<br>
`credits:` https://github.com/Faruqt/React-Flask

## What was made by me?
Here is the list of things I added to automate convenient application assembly:
- Containerization
  - Docker container for front-end
  - Docker container for back-end
  - Docker Compose to run application as whole at the same time
  - Docker Compose service for systemd systemctl control
- Automatization
  - Pipeline
    - Containers auto assembly
    - Unit and style tests for code
    - Dockle vulnerability tests
    - Deploy to the production server as systemd service using bash script

## Important
The deploy stage is inactive. To activate it, remove the line in github/workflows/main.yml:
`if: github.event_name == 'workflow_dispatch'`
Add the host's public key to .ssh/authorized_keys on the server.
And add the following variables to the repository's Secrets:
`SSH_HOST` - server IP/address
`SSH_USER` - host username
`SSH_PRIVATE_KEY` - host private key
Currently, these variables in the repository are empty because there is no active server.

