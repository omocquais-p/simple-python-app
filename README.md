### 1 .create a virtual environment
```
python3 -m venv venv
```

### 2 .Activate the environment
```
source venv/bin/activate
```

### 3 .Install the requirements
```
pip install -r requirements.txt
```

### 4. Run the application
`python app.py`

### 4. Build the container image
`docker build -t my-simple-python-app .`

- Run the application
```
docker run -p 5001:5001 my-simple-python-app
```

- Run the application (detached mode)
```
docker run -d -p 5001:5001 my-simple-python-app
```
