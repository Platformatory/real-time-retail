FROM python:3.8-slim
  
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

RUN pip install --trusted-host pypi.python.org -r requirements.txt

EXPOSE 5000

CMD ["python","-u","app.py"]