
# Example libpython-clj + conda + docker setup

Install docker and docker compose, then run with

```
docker compose up --build
```

You should then be able to connect to an nREPL over port 3851 (`:Connect 3851` in vim).

## Key to getting this to work

Setting up environments with conda is a little bit weird, so the key here is to use the `SHELL` command from the `Dockerfile` so that the conda environment is active during the setup.
However, this does not apply to the final `CMD` step in the `Dockerfile`, so `conda run` has to be used explicitly there to ensure that the Clojure process can access the correct python environment.


