# Week 1 — App Containerization

Week 1's class was all about setting up our docker environment to a state where we could launch the Cruddur locally.
## Containerize Backend

### Add Dockerfile

First step was to create a dockerfile in the backend-flask dropdown and then paste the following code in it.

```dockerfile
FROM python:3.10-slim-buster

WORKDIR /backend-flask

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .

ENV FLASK_ENV=development

EXPOSE ${PORT}
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0", "--port=4567"]
```

![Dockerfile commands](assets/Week_1_Dockerfile.PNG)

### Running python
On the terminal type in the following code in order to install the python libraries used for the app.
```
cd backend-flask/
pip3 install -r requirements.txt
```
### Build Container

```sh
docker build -t  backend-flask ./backend-flask
```

### Run Container

Run the following commands 
```sh
docker run --rm -p 4567:4567 -it -e FRONTEND_URL='*' -e BACKEND_URL='*' backend-flask
```
Make sure you unlock the 4567 port to the public as well as open the link for 4567 in your browser and append to the url to `/api/activities/home`

![Running container](assets/Week_01_Running_Container.PNG)

## Containerize Frontend

### Run NPM Install

We have to run NPM Install before building the container since it needs to copy the contents of node_modules

```
cd frontend-react-js
npm i
```
While that is running we go ahead and create a new `Dockerfile` in the frontend directory and then paste in the commands below


Create a file here: `frontend-react-js/Dockerfile`

```dockerfile
FROM node:16.18

ENV PORT=3000

COPY . /frontend-react-js
WORKDIR /frontend-react-js
RUN npm install
EXPOSE ${PORT}
CMD ["npm", "start"]
```
## Multiple Containers
In order to run multiple containers we are going to create a Docker-compose file which will enable us to run multiple containers instead of having to do it manually.

### Create a docker-compose file

Create `docker-compose.yml` at the root of your project.

```yaml
version: "3.8"
services:
  backend-flask:
    environment:
      FRONTEND_URL: "https://3000-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
      BACKEND_URL: "https://4567-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
    build: ./backend-flask
    ports:
      - "4567:4567"
    volumes:
      - ./backend-flask:/backend-flask
  frontend-react-js:
    environment:
      REACT_APP_BACKEND_URL: "https://4567-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
    build: ./frontend-react-js
    ports:
      - "3000:3000"
    volumes:
      - ./frontend-react-js:/frontend-react-js

# the name flag is a hack to change the default prepend folder
# name when outputting the image names
networks: 
  internal-network:
    driver: bridge
    name: cruddur
```

In order to test it we can right-click on the docker-compose on the right and select up and it should configure the environment variables for us as well as install all the dependancies we need.

On the ports tab we should see that both `port 3000 and port 4567` are highlited and that they are both open to the public.
![Ports open to public](assets/Week_1_Open_ports.PNG)

We then click on the address associated with the port 3000 and it should open the home page of our cruddur app
![Cruddue App ](assets/Week_1_Cruddur_APP.PNG)







