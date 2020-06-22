# AGI-20 tutorial

## Docker

### Build docker image

```bash
cd docker
docker build --no-cache -t ngeiswei/opencog:agi20 -f Dockerfile .
cd ..
```

### Upload docker image

```bash
docker login
docker push ngeiswei/opencog:agi20
```

### Download docker image

```bash
docker pull ngeiswei/opencog:agi20
```

### Run docker image

```bash
docker run -it ngeiswei/opencog:agi20 bash
```

## Presentation

### Build presentation

```bash
./render.sh
```
