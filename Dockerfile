# use an official Node.js runtime as a parent image
FROM node:22-alpine

# set timezone
ENV TZ=${TZ:-UTC}
RUN apk add --no-cache tzdata

# set the working directory in the container
WORKDIR /usr/src/app

# copy the npm dependencies file
COPY package.json .

# install dependencies and packages specified in package.json
RUN apk add --no-cache --virtual .gyp \
        python3 \
        make \
        g++ \
    && npm install \
    && apk del .gyp

# create the cache directory and set permissions
RUN mkdir -p ./cache && chown -R node:node /usr/src/app

# copy the current directory contents into the container at the workdir
COPY --chown=node:node . .

# define environment variables
ENV NODE_ENV=production

# run entrypoint script when the container launches
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
