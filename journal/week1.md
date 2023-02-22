# Week 1 — App Containerization

Week 1's class was all about setting up our docker environment to a state where we could launch the Cruddur locally.

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


