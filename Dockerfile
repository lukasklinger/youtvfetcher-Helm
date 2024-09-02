# step 1: builder
FROM library/node:18-alpine AS builder

WORKDIR /app

# install dependencies
RUN apk add git

# fetch code
RUN git clone https://github.com/maxnowack/youtvfetcher.git

WORKDIR /app/youtvfetcher

# install npm dependencies
RUN npm install && npm run prepare

# build distributable version
RUN npm run build

# step 2: runtime image
FROM library/node:18-alpine

WORKDIR /app

COPY --from=builder /app/youtvfetcher .

ENTRYPOINT [ "node", "./dist/index.js" ]