# ---- Builder: augment the server with Postgres driver/support ----
FROM quay.io/keycloak/keycloak:26.0 AS builder

ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

RUN /opt/keycloak/bin/kc.sh build --db=postgres

FROM quay.io/keycloak/keycloak:26.0

COPY --from=builder /opt/keycloak/ /opt/keycloak/

ENV KC_DB=postgres
ENV KC_PROXY=edge
ENV KC_HTTP_ENABLED=true
ENV KC_HTTP_RELATIVE_PATH=/auth
ENV KC_HOSTNAME_STRICT=false
ENV KC_HOSTNAME_STRICT_HTTPS=false


EXPOSE 8443 8444

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]

CMD ["start",
     "--db=postgres",
     "--http-enabled=true",
     "--http-host=0.0.0.0",
     "--http-port=${PORT}"]
