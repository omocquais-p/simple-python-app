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

- Run the application (detached mode)
```
docker run --env PORT=5003 -d -p 5003:5003 my-simple-python-app
```

Build the app with Cloud Native Buildpacks
```
pack build python-app-pack --builder paketobuildpacks/builder:base
```

```
docker run --env PORT=5003 --publish 5003:5003 python-app-pack
```


```
docker rmi -f python-app-pack
```

### Deploy on TAP

```
make claims
make workload-deploy
```
