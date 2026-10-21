FROM ollama/ollama:0.40.7@sha256:2e6cc92ffa43b4b1a2e70e315407e00ac97ec125afc71277d73c7efe01c4f31b AS ollama

FROM ghcr.io/open-webui/open-webui:v0.12.3-slim@sha256:5adfb0355bbe4a5860c0ba9482cc0b40f573de3749a21a64cf4789391a14fffc

COPY --from=ollama /bin/ollama /bin/ollama
COPY --from=ollama /usr/lib/ollama /usr/lib/ollama

RUN test -x /bin/ollama && test -d /usr/lib/ollama

ENV USE_OLLAMA_DOCKER=true \
    OLLAMA_HOST=127.0.0.1:11434 \
    OLLAMA_BASE_URL=http://127.0.0.1:11434 \
    OLLAMA_KEEP_ALIVE=0 \
    OLLAMA_NUM_PARALLEL=1 \
    OLLAMA_MAX_LOADED_MODELS=1 \
    OLLAMA_CONTEXT_LENGTH=4096 \
    OLLAMA_NO_CLOUD=1

HEALTHCHECK --interval=30s --timeout=5s --start-period=120s --retries=3 CMD curl --fail --silent http://127.0.0.1:8080/health > /dev/null && curl --fail --silent http://127.0.0.1:11434/api/version > /dev/null