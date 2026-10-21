# Open WebUI + Ollama

One image containing Open WebUI's slim interface and Ollama's executable/GPU
runtime, with both upstream bases pinned by digest. It uses Open WebUI's native
bundled-server startup, not a custom inference application. Models, accounts,
database data, TLS keys and credentials are not baked into the image.

Published image: `d0ntblink/open-webui-ollama` on Docker Hub, `linux/amd64`.

## Automated Builds

Pushes to `master` build and publish `latest` and `sha-<full-commit-sha>`.
Pull requests targeting `master` build without publishing or registry secrets.
The Container Image workflow also supports manual runs from the Actions tab.
Actions and base images are commit/digest pinned; upgrades are reviewed source
changes rather than implicit floating-version upgrades.

Create a dedicated Docker Hub token with write access for `d0ntblink` and add
it as the GitHub repository Actions secret `DOCKERHUB_TOKEN`. No personal GitHub
token is needed: GitHub provides the workflow token automatically, limited here
to reading the repository. Never commit credentials or pass tokens as build args.
Publishing fails explicitly when its required secret is missing.

Image publishing does not redeploy the NAS. Infrastructure configuration and
deployment remain in the separate `owl.red` repository. Pin the resulting image
digest there after runtime qualification; do not automatically deploy `latest`.

## Runtime Contract

- Container port `8080` is the authenticated WebUI and API. Put it behind TLS
  and retain the intended administration-source restrictions.
- Ollama listens only on container-local `127.0.0.1:11434`. Do not publish it.
- Mount the existing model directory at `/root/.ollama` and durable WebUI files
  at `/app/backend/data`; preserve the existing PostgreSQL `DATABASE_URL` and
  stable `WEBUI_SECRET_KEY` through private runtime secrets.
- This slim-based combination is for chat/API use. Local speech/embedding and
  other full-image ML features are not included. A vector provider is separate.
- Grant NVIDIA access only on a qualified GPU host. CI builds do not certify
  GPU/driver compatibility or shared-GPU behavior.
- Defaults request one parallel job, one loaded model, context 4096 and unload
  after each response. Request-level overrides are possible; these are not GPU
  reservations or hard resource limits. Set container resource bounds separately.
- Docker health checks both WebUI and Ollama. Docker does not automatically
  restart a container solely because its health status becomes unhealthy.

Keep upstream Open WebUI branding and licensing intact. This image does not
include model weights; model licensing and downloads are managed separately.