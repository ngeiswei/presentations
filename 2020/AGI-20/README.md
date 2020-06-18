# AGI-20 tutorial

## Build docker image

```bash
docker build -t ngeiswei/opencog:agi20 -f Dockerfile .
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
