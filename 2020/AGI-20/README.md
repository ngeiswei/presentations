# AGI-20 tutorial

## Build docker image

```bash
cd docker
docker build -t ngeiswei/opencog:agi20 -f Dockerfile .
cd ..
```

## Upload docker image

```bash
docker login
docker push ngeiswei/opencog:agi20
```

## Build presentation

```bash
./render.sh
```
