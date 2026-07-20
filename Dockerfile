FROM dwgebler/geblang:1.32.0

WORKDIR /app

COPY geblang.yaml .
COPY src ./src
COPY database ./database

RUN mkdir -p database

EXPOSE 8013

ENV PORT=8013
ENV APP_HOST=0.0.0.0
ENV DB_DATABASE=/app/database/database.sqlite
ENV JWT_SECRET=change-me-in-production

CMD ["src/main.gb"]
